unit Parser.ContentString;

interface

uses
  System.Classes,
  Contract.HTTPEventData;

type

  TContentStringParser = class
  private
    { private declarations }
  protected
    { protected declarations }
    class function ExtractValue(const AKey: string; const AStringList: TStringList): string;
  public
    { public declarations }
    class function Parse(const AContentString: string): IHTTPEventData;
  end;

implementation

uses
  System.SysUtils,
  System.StrUtils,
  Event.HTTPEventData;

{ TContentStringParser }

class function TContentStringParser.ExtractValue(const AKey: string; const AStringList: TStringList): string;
var
  LTempString: TArray<string>;
  LEndParse: Boolean;
  I: Integer;
begin
  I := 0;
  LEndParse := False;
  while I < AStringList.Count do
  begin
    if AStringList.Strings[I].StartsWith(AKey + ': ') then
    begin
      LTempString := [AStringList.Strings[I].Substring((AKey + ': ').Length)];
      AStringList.Delete(I);
      while I < AStringList.Count do
      begin
        if (AStringList.Strings[I].StartsWith('id: ')) or (AStringList.Strings[I].StartsWith('event: ')) or (AStringList.Strings[I].StartsWith('data: ')) then
        begin
          Break;
          LEndParse := True;
        end;
        LTempString := LTempString + [AStringList.Strings[I]];
        AStringList.Delete(I);
        if LEndParse then
          Break;
      end;
    end;
    Inc(I);
  end;
  Result := string.Join(sLineBreak, LTempString).TrimRight;
end;

class function TContentStringParser.Parse(const AContentString: string): IHTTPEventData;
var
  LId: string;
  LEvent: string;
  LData: string;
  LStringList: TStringList;
begin
  LStringList := TStringList.Create;
  try
    LStringList.Text := AContentString;
    LId := ExtractValue('id', LStringList);
    LEvent := ExtractValue('event', LStringList);
    LData := ExtractValue('data', LStringList);
  finally
    LStringList.Free;
  end;

  Result := THTTPEventData.New(LId, LEvent, LData);
end;

end.

unit Event.HTTPEventData;

interface

uses
  Contract.HTTPEventData;

type

  THTTPEventData = class(TInterfacedObject, IHTTPEventData)
  strict private
    { strict private declarations }
    constructor Create(const AId: string; const AEvent: string; const AData: string);
  private
    { private declarations }
    FId: string;
    FEvent: string;
    FData: string;
  protected
    { protected declarations }
  public
    { public declarations }
    function GetId: string;
    function GetEvent: string;
    function GetData: string;
    class function New(const AId: string; const AEvent: string; const AData: string): IHTTPEventData;
  end;

implementation

{ THTTPEventData }

constructor THTTPEventData.Create(const AId: string; const AEvent: string; const AData: string);
begin
  FId := AId;
  FEvent := AEvent;
  FData := AData;
end;

function THTTPEventData.GetData: string;
begin
  Result := FData;
end;

function THTTPEventData.GetEvent: string;
begin
  Result := FEvent;
end;

function THTTPEventData.GetId: string;
begin
  Result := FId;
end;

class function THTTPEventData.New(const AId: string; const AEvent: string; const AData: string): IHTTPEventData;
begin
  Result := Self.Create(AId, AEvent, AData);
end;

end.

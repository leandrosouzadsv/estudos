unit Horse.SSE.Message;

interface

uses
  Horse.SSE.Contract.Message;

type

  TSSEMessage = class(TInterfacedObject, ISSEMessage)
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
    class function New(const AId: string; const AEvent: string; const AData: string): ISSEMessage;
  end;

implementation

{ TSSEMessage }

constructor TSSEMessage.Create(const AId: string; const AEvent: string; const AData: string);
begin
  FId := AId;
  FEvent := AEvent;
  FData := AData;
end;

function TSSEMessage.GetData: string;
begin
  Result := FData;
end;

function TSSEMessage.GetEvent: string;
begin
  Result := FEvent;
end;

function TSSEMessage.GetId: string;
begin
  Result := FId;
end;

class function TSSEMessage.New(const AId: string; const AEvent: string; const AData: string): ISSEMessage;
begin
  Result := Self.Create(AId, AEvent, AData);
end;

end.

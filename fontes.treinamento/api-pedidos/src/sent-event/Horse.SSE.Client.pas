unit Horse.SSE.Client;

interface

uses
  Web.HTTPApp,
  Horse.SSE.Contract.Client,
  Horse.SSE.Contract.Message,
  System.SyncObjs;

type

  TSSEClient = class(TInterfacedObject, ISSEClient)
  strict private
    { strict private declarations }
    constructor Create(const ARoomName: string);
  private
    { private declarations }
    FRoomName: string;
    FSSEId: string;
    FIsTerminated: Boolean;
    FSimpleEvent: TSimpleEvent;
    FWebRequest: TWebRequest;
    FWebResponse: TWebResponse;
  protected
    { protected declarations }
    function PrepareMessage(const AMessage: ISSEMessage): string;
  public
    { public declarations }
    destructor Destroy; override;
    function GetSSEId: string;
    function GetRoom: string;
    procedure InitializeSSE(const ARequest: TWebRequest; const AResponse: TWebResponse);
    procedure UnInitializeSSE;
    procedure SendMessage(const AMessage: ISSEMessage);
    class function New(const ARoomName: string): ISSEClient;
  end;

implementation

uses
  System.SysUtils,
  System.Hash;

{ TSSEClient }

constructor TSSEClient.Create(const ARoomName: string);
begin
  FRoomName := ARoomName;
  FIsTerminated := False;
  FSimpleEvent := TSimpleEvent.Create;
  FSSEId := THash.GetRandomString(32);
end;

destructor TSSEClient.Destroy;
begin
  UnInitializeSSE;
  FSimpleEvent.Free;
  inherited;
end;

function TSSEClient.GetRoom: string;
begin
  Result := FRoomName;
end;

function TSSEClient.GetSSEId: string;
begin
  Result := FSSEId;
end;

procedure TSSEClient.InitializeSSE(const ARequest: TWebRequest; const AResponse: TWebResponse);
var
  LHeader: string;
begin
  FWebRequest := ARequest;
  FWebResponse := AResponse;
  FIsTerminated := False;
  FWebResponse.CustomHeaders.AddPair('X-Sseid', GetSSEId);
  // DoOnClientConnected(FSSEId, AResponse.HTTPRequest);
  LHeader :=
    'HTTP/1.1 200 OK' + sLineBreak +
    'Cache-Control: no-store' + sLineBreak +
    'X-Sseid: ' + FSSEId + sLineBreak +
    'Content-Type: text/event-stream' + sLineBreak + sLineBreak;
  AResponse.HTTPRequest.WriteString(LHeader);
  while not FIsTerminated do
  begin
    FSimpleEvent.WaitFor(INFINITE);
    FSimpleEvent.ResetEvent;
    // DoOnClientDisconnected(LSSEId);
  end;
end;

class function TSSEClient.New(const ARoomName: string): ISSEClient;
begin
  Result := Self.Create(ARoomName);
end;

function TSSEClient.PrepareMessage(const AMessage: ISSEMessage): string;
begin
  Result := EmptyStr;
  if not AMessage.GetEvent.IsEmpty then
    Result := Result + Format('event: %s', [AMessage.GetEvent + sLineBreak]);
  if not AMessage.GetId.IsEmpty then
    Result := Result + Format('id: %s', [AMessage.GetId + sLineBreak]);
  Result := Result + Format('data: %s', [AMessage.GetData + sLineBreak + sLineBreak]);
end;

procedure TSSEClient.SendMessage(const AMessage: ISSEMessage);
var
  LMessage: string;
begin
  LMessage := PrepareMessage(AMessage);
  FWebRequest.WriteString(LMessage);
end;

procedure TSSEClient.UnInitializeSSE;
begin
  FIsTerminated := True;
  FSimpleEvent.SetEvent;
end;

end.

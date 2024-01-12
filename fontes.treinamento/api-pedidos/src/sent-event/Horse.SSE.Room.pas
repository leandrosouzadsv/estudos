unit Horse.SSE.Room;

interface

uses
  System.SysUtils,
  System.SyncObjs,
  System.Generics.Collections,
  Horse.SSE.Contract.Room,
  Horse.SSE.Contract.Message,
  Horse.SSE.Callback,
  Web.HTTPApp,
  Horse.SSE.Contract.Client;

type

  TSSERoom = class(TInterfacedObject, ISSERoom)
  strict private
    { strict private declarations }
    constructor Create(const ARoomName: string);
  private
    { private declarations }
    FClientCollection: TDictionary<string, ISSEClient>;
    FOnClientConnectedCallback: TClientConnectedCallback;
    FOnClientDisconnectedCallback: TClientDisconnectedCallback;
    FRoomName: string;
  protected
    { protected declarations }
    function PrepareMessage(const AMessage: ISSEMessage): string;
    procedure DoOnClientConnected(const AId: string; const AClient: ISSEClient);
    procedure DoOnClientDisconnected(const AId: string);
  public
    { public declarations }
    destructor Destroy; override;
    function GetRoomName: string;
    procedure SendMessage(const AMessage: ISSEMessage);
    procedure InitializeSSE(const ARequest: TWebRequest; const AResponse: TWebResponse);
    function GetClientCollection: TDictionary<string, ISSEClient>;
    procedure SetOnClientConnected(const AOnClientConnectedCallback: TClientConnectedCallback);
    procedure SetOnClientDisconnected(const AOnClientDisconnectedCallback: TClientDisconnectedCallback);
    class function New(const ARoomName: string): ISSERoom;
  end;

implementation

uses
  System.Hash,
  System.Threading,
  Horse.SSE.Client;

{ TSSERoom }

constructor TSSERoom.Create(const ARoomName: string);
begin
  FClientCollection := TDictionary<string, ISSEClient>.Create;
  FRoomName := ARoomName;
end;

destructor TSSERoom.Destroy;
begin
  FClientCollection.Free;
  inherited;
end;

procedure TSSERoom.DoOnClientConnected(const AId: string; const AClient: ISSEClient);
begin
  FClientCollection.Add(AId, AClient);
  if Assigned(FOnClientConnectedCallback) then
  begin
    FOnClientConnectedCallback(FRoomName, AClient);
  end;
end;

procedure TSSERoom.DoOnClientDisconnected(const AId: string);
begin
  FClientCollection.Remove(AId);
  if Assigned(FOnClientDisconnectedCallback) then
  begin
    FOnClientDisconnectedCallback(FRoomName, AId);
  end;
end;

function TSSERoom.GetClientCollection: TDictionary<string, ISSEClient>;
begin
  Result := FClientCollection;
end;

function TSSERoom.GetRoomName: string;
begin
  Result := FRoomName;
end;

procedure TSSERoom.InitializeSSE(const ARequest: TWebRequest; const AResponse: TWebResponse);
var
  LSSEClient: ISSEClient;
  LSSEId: string;
begin
  LSSEClient := TSSEClient.New(FRoomName);
  LSSEId := LSSEClient.GetSSEId;
  DoOnClientConnected(LSSEId, LSSEClient);
  try
    LSSEClient.InitializeSSE(ARequest, AResponse);
  finally
    DoOnClientDisconnected(LSSEId);
  end;
end;

class function TSSERoom.New(const ARoomName: string): ISSERoom;
begin
  Result := Self.Create(ARoomName);
end;

function TSSERoom.PrepareMessage(const AMessage: ISSEMessage): string;
begin
  Result := EmptyStr;
  if not AMessage.GetEvent.IsEmpty then
    Result := Result + Format('event: %s', [AMessage.GetEvent + sLineBreak]);
  if not AMessage.GetId.IsEmpty then
    Result := Result + Format('id: %s', [AMessage.GetId + sLineBreak]);
  Result := Result + Format('data: %s', [AMessage.GetData + sLineBreak + sLineBreak]);
end;

procedure TSSERoom.SendMessage(const AMessage: ISSEMessage);
var
  LKey: string;
begin
  for LKey in FClientCollection.Keys do
  begin
    try
      FClientCollection.Items[LKey].SendMessage(AMessage);
    except
      DoOnClientDisconnected(LKey);
    end;
  end;
end;

procedure TSSERoom.SetOnClientConnected(const AOnClientConnectedCallback: TClientConnectedCallback);
begin
  FOnClientConnectedCallback := AOnClientConnectedCallback;
end;

procedure TSSERoom.SetOnClientDisconnected(const AOnClientDisconnectedCallback: TClientDisconnectedCallback);
begin
  FOnClientDisconnectedCallback := AOnClientDisconnectedCallback;
end;

end.

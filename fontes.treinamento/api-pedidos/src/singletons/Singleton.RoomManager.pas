unit Singleton.RoomManager;

interface

uses
  System.SyncObjs,
  System.Classes,
  System.Generics.Collections,
  Horse.SSE.Contract.Room,
  Web.HTTPApp,
  Horse.SSE.Callback,
  Horse.SSE.Contract.Client;

type

  TRoomManagerSingleton = class
  private
    { private declarations }
    FRoomList: TDictionary<string, ISSERoom>;

  class var
    FPingClientThread: TThread;
    FSimpleEvent: TSimpleEvent;
    FRoomManagerSingleton: TRoomManagerSingleton;
    FRedisTimeoutCallback: Boolean;
    FOnClientConnectedCallback: TClientConnectedCallback;
    FOnClientDisconnectedCallback: TClientDisconnectedCallback;
  protected
    { protected declarations }
    procedure SubscribeRedis(const AChannelName: string);
    procedure SubscribeCallback(AChannelName: string; AMessage: string);
    function RedisTimeoutCallback: Boolean;
    procedure DoPingClientCallback;
    procedure DoOnClientConnectedCallback(const ARoomName: string; const AClient: ISSEClient);
    procedure DoOnClientDisconnectedCallback(const ARoomName: string; const ASSEId: string);
  public
    { public declarations }
    constructor Create;
    destructor Destroy; override;
    function GetRoom(const ARoomName: string): ISSERoom;
    function GetRoomCount: Integer;
    function GetRoomKeys: TDictionary<string, ISSERoom>.TKeyCollection;
    procedure RemoveRoom(const ARoomName: string);
    procedure SetOnClientConnected(const AOnClientConnectedCallback: TClientConnectedCallback);
    procedure SetOnClientDisconnected(const AOnClientDisconnectedCallback: TClientDisconnectedCallback);
    procedure UnInitializeSSE;
    class function GetDefault: TRoomManagerSingleton;
    class destructor UnInitialize;
  end;

implementation

uses
  System.SysUtils,
  System.JSON,
  System.Hash,
  Horse.SSE.Room,
  Connection.Redis.PoolManager,
  Redis.Client,
  Horse.SSE.Contract.Message,
  Horse.SSE.Message;

{ TRoomManagerSingleton }

constructor TRoomManagerSingleton.Create;
begin
  FSimpleEvent := TSimpleEvent.Create;
  FPingClientThread := TThread.CreateAnonymousThread(DoPingClientCallback);
  FPingClientThread.Start;
  FRoomList := TDictionary<string, ISSERoom>.Create;
  FRedisTimeoutCallback := True;
end;

destructor TRoomManagerSingleton.Destroy;
begin
  UnInitializeSSE;
  FRoomList.Free;
  FSimpleEvent.SetEvent;
  FSimpleEvent.Free;
  inherited;
end;

procedure TRoomManagerSingleton.DoOnClientConnectedCallback(const ARoomName: string; const AClient: ISSEClient);
begin
  if Assigned(FOnClientConnectedCallback) then
    FOnClientConnectedCallback(ARoomName, AClient);
end;

procedure TRoomManagerSingleton.DoOnClientDisconnectedCallback(const ARoomName: string; const ASSEId: string);
begin
  if FRoomList.ContainsKey(ARoomName) then
  begin
    if FRoomList.Items[ARoomName].GetClientCollection.Count = 0 then
      RemoveRoom(ARoomName);
  end;
  if Assigned(FOnClientDisconnectedCallback) then
    FOnClientDisconnectedCallback(ARoomName, ASSEId);
end;

procedure TRoomManagerSingleton.DoPingClientCallback;
var
  LKeys: string;
  LMessage: ISSEMessage;
  LWaitResult: TWaitResult;
begin
  while True do
  begin
    LWaitResult := FSimpleEvent.WaitFor(30000);
    LMessage := TSSEMessage.New(THash.GetRandomString, 'ping', '{"time": "' + FormatDateTime('yyyy-mm-dd"T"hh:nn:ss.zzz"Z"', Now) + '"}');
    FSimpleEvent.ResetEvent;
    if LWaitResult <> wrTimeout then
      Break;
    for LKeys in TRoomManagerSingleton.GetDefault.GetRoomKeys do
    begin
      TRoomManagerSingleton.GetDefault.GetRoom(LKeys).SendMessage(LMessage);
    end;
  end;
end;

class function TRoomManagerSingleton.GetDefault: TRoomManagerSingleton;
begin
  if FRoomManagerSingleton = nil then
    FRoomManagerSingleton := Self.Create;
  Result := FRoomManagerSingleton;
end;

function TRoomManagerSingleton.GetRoom(const ARoomName: string): ISSERoom;
var
  LSSERoom: ISSERoom;
begin
  if not FRoomList.ContainsKey(ARoomName) then
  begin
    LSSERoom := TSSERoom.New(ARoomName);
    LSSERoom.SetOnClientConnected(DoOnClientConnectedCallback);
    LSSERoom.SetOnClientDisconnected(DoOnClientDisconnectedCallback);
    FRoomList.Add(ARoomName, LSSERoom);
    SubscribeRedis(ARoomName);
  end;
  Result := FRoomList.Items[ARoomName];
end;

function TRoomManagerSingleton.GetRoomCount: Integer;
begin
  Result := FRoomList.Count;
end;

function TRoomManagerSingleton.GetRoomKeys: TDictionary<string, ISSERoom>.TKeyCollection;
begin
  Result := FRoomList.Keys;
end;

function TRoomManagerSingleton.RedisTimeoutCallback: Boolean;
begin
  Result := FRedisTimeoutCallback;
end;

procedure TRoomManagerSingleton.RemoveRoom(const ARoomName: string);
var
  LKey: string;
begin
  if FRoomList.ContainsKey(ARoomName) then
  begin
    for LKey in FRoomList.Items[ARoomName].GetClientCollection.Keys do
    begin
      FRoomList.Items[ARoomName].GetClientCollection.Items[LKey].UnInitializeSSE;
      FRoomList.Remove(ARoomName);
    end;
  end;
end;

procedure TRoomManagerSingleton.SetOnClientConnected(const AOnClientConnectedCallback: TClientConnectedCallback);
begin
  FOnClientConnectedCallback := AOnClientConnectedCallback;
end;

procedure TRoomManagerSingleton.SetOnClientDisconnected(const AOnClientDisconnectedCallback: TClientDisconnectedCallback);
begin
  FOnClientDisconnectedCallback := AOnClientDisconnectedCallback;
end;

procedure TRoomManagerSingleton.SubscribeCallback(AChannelName, AMessage: string);
var
  LMessage: ISSEMessage;
  LJJSONObject: TJSONObject;
  LSSEId: string;
begin
  LJJSONObject := TJSONObject.ParseJSONValue(AMessage) as TJSONObject;
  try
    if LJJSONObject <> nil then
    begin
      LMessage := TSSEMessage.New(LJJSONObject.GetValue<string>('id'), LJJSONObject.GetValue<string>('event'), LJJSONObject.GetValue<TJSONValue>('message').ToString);
      if LJJSONObject.TryGetValue<string>('sseId', LSSEId) then
      begin
        if FRoomList.Items[AChannelName].GetClientCollection.ContainsKey(LSSEId) then
          FRoomList.Items[AChannelName].GetClientCollection.Items[LSSEId].SendMessage(LMessage);
      end
      else
        FRoomList.Items[AChannelName].SendMessage(LMessage);
    end;
  finally
    LJJSONObject.Free;
  end;
end;

procedure TRoomManagerSingleton.SubscribeRedis(const AChannelName: string);
begin
  FRedisTimeoutCallback := True;
  TThread.CreateAnonymousThread(
    procedure
    begin
      TRedisPoolManager.DefaultManager.Connection(
        procedure(AConnection: TRedisClient)
        begin
          AConnection.SUBSCRIBE([AChannelName], SubscribeCallback, RedisTimeoutCallback);
        end)
    end).Start;
end;

class destructor TRoomManagerSingleton.UnInitialize;
begin
  FRoomManagerSingleton.Free;
end;

procedure TRoomManagerSingleton.UnInitializeSSE;
var
  LKey: string;
begin
  FRedisTimeoutCallback := False;
  for LKey in FRoomList.Keys do
  begin
    RemoveRoom(LKey);
  end;
end;

end.

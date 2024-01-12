unit Connection.Redis.PoolManager;

interface

uses
  PoolManager,
  Redis.Commons,
  Redis.Client,
  Redis.NetLib.INDY;

type

  TConnectionCallback = reference to procedure(AConnection: TRedisClient);

  TRedisPoolManager = class(TPoolManager<TRedisClient>)
  private
    { private declarations }
    class var FDefaultRedisPoolManager: TRedisPoolManager;
  protected
    { protected declarations }
    class procedure CreateDefaultInstance;
    class function GetDefaultRedisPoolManager: TRedisPoolManager; static;
  public
    { public declarations }
    procedure DoGetInstance(var AInstance: TRedisClient; var AInstanceOwner: Boolean); override;
    procedure Connection(AConnectionCallback: TConnectionCallback);
    class constructor Initialize;
    class destructor UnInitialize;
    class property DefaultManager: TRedisPoolManager read GetDefaultRedisPoolManager;
  end;

implementation

uses
  Config.Redis;

{ TRedisPoolManager }

procedure TRedisPoolManager.Connection(AConnectionCallback: TConnectionCallback);
var
  LItem: TPoolItem<TRedisClient>;
  LConnection: TRedisClient;
begin
  LItem := TRedisPoolManager.DefaultManager.TryGetItem;
  LConnection := LItem.Acquire;
  try
    LConnection.Connect;
    try
      AConnectionCallback(LConnection);
    finally
      LConnection.Disconnect;
    end;
  finally
    LItem.Release;
  end;
end;

class procedure TRedisPoolManager.CreateDefaultInstance;
begin
  FDefaultRedisPoolManager := TRedisPoolManager.Create(True);
  FDefaultRedisPoolManager.SetMaxIdleSeconds(60 * 60);
  FDefaultRedisPoolManager.Start;
end;

procedure TRedisPoolManager.DoGetInstance(var AInstance: TRedisClient; var AInstanceOwner: Boolean);
begin
  inherited;
  AInstanceOwner := True;
  AInstance := TRedisClient.Create(
    TRedisConfig.Host,
    TRedisConfig.Port);
end;

class function TRedisPoolManager.GetDefaultRedisPoolManager: TRedisPoolManager;
begin
  if (FDefaultRedisPoolManager = nil) then
  begin
    CreateDefaultInstance;
  end;
  Result := FDefaultRedisPoolManager;
end;

class constructor TRedisPoolManager.Initialize;
begin
  CreateDefaultInstance;
end;

class destructor TRedisPoolManager.UnInitialize;
begin
  if FDefaultRedisPoolManager <> nil then
  begin
    FDefaultRedisPoolManager.Free;
  end;
end;

end.

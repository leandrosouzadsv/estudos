unit Controller.Order;

interface

uses
  Horse;

type

  TOrderController = class
  strict private
    { strict private declarations }
  private
    { private declarations }
    class procedure PostNewOrder(ARequest: THorseRequest; AResponse: THorseResponse);
    class procedure GetOrderEventListen(ARequest: THorseRequest; AResponse: THorseResponse);
    class procedure GetOrderCollection(ARequest: THorseRequest; AResponse: THorseResponse);
    class procedure PutOrderStatus(ARequest: THorseRequest; AResponse: THorseResponse);
  protected
    { protected declarations }
  public
    { public declarations }
    class procedure RegisterRouter;
  end;

implementation

uses
  System.SysUtils,
  System.JSON,
  REST.JSON,
  Singleton.Facade.Order,
  Contract.Entity.Order,
  Entity.Order,
  Util.InterfacedObjectJson,
  Singleton.RoomManager,
  Connection.Redis.PoolManager,
  Redis.Client,
  Horse.SSE.Message;

{ TOrderController }

class procedure TOrderController.GetOrderCollection(ARequest: THorseRequest; AResponse: THorseResponse);
var
  LOrderCollection: TArray<IOrderEntity>;
  LBody: TJSONArray;
begin
  LOrderCollection := TOrderFacadeSingleton.New.GetOrderCollection;
  LBody := TInterfacedObjectJsonUtil.InterfacedObjectArrayToJsonArray<TOrderEntity, IOrderEntity>(LOrderCollection);
  AResponse.Send<TJSONArray>(LBody);
end;

class procedure TOrderController.GetOrderEventListen(ARequest: THorseRequest; AResponse: THorseResponse);
var
  LRoom: string;
begin
  LRoom := ARequest.Params.Field('id').AsString;
  TRoomManagerSingleton
    .GetDefault
    .GetRoom(LRoom)
    .InitializeSSE(ARequest.RawWebRequest, AResponse.RawWebResponse);
end;

class procedure TOrderController.PostNewOrder(ARequest: THorseRequest; AResponse: THorseResponse);
var
  LBody: TJSONObject;
  LOrderEntity: IOrderEntity;

begin
  LBody := ARequest.Body<TJSONObject>;

  if LBody = nil then
    raise Exception.Create('Invalid json');

  LOrderEntity := TInterfacedObjectJsonUtil.JsonObjectToInterfacedObject<TOrderEntity, IOrderEntity>(IOrderEntity, LBody);
  TOrderFacadeSingleton.New.PersistOrderEntity(LOrderEntity);

  AResponse.Status(THTTPStatus.Created);
end;

class procedure TOrderController.PutOrderStatus(ARequest: THorseRequest; AResponse: THorseResponse);
var
  LBody: TJSONObject;
  LOrderEntity: IOrderEntity;
begin
  LBody := ARequest.Body<TJSONObject>;

  if LBody = nil then
    raise Exception.Create('Invalid json');

  LOrderEntity := TInterfacedObjectJsonUtil.JsonObjectToInterfacedObject<TOrderEntity, IOrderEntity>(IOrderEntity, LBody);
  TOrderFacadeSingleton.New.UpdateOrder(LOrderEntity);

  AResponse.Status(THTTPStatus.NoContent);

  // TRoomManagerSingleton
  // .GetDefault
  // .GetRoom(LOrderEntity.GetId.ToString)
  // .SendMessage(TSSEMessage.New('0', 'order_status_update', LBody.ToString));

  TRedisPoolManager.DefaultManager.Connection(
    procedure(AConnection: TRedisClient)
    var
      LJSONEvent: TJSONObject;
    begin
      LJSONEvent := TJSONObject.Create;
      try
        LJSONEvent.AddPair('id', '0');
        LJSONEvent.AddPair('event', 'order_status_update');
        LJSONEvent.AddPair('message', LBody.Clone as TJSONObject);
        AConnection.PUBLISH(LOrderEntity.GetId.ToString, LJSONEvent.ToString);
      finally
        LJSONEvent.Free;
      end;
    end);

end;

class procedure TOrderController.RegisterRouter;
begin
  THorse.Post('/order', PostNewOrder);
  THorse.Get('/order', GetOrderCollection);
  THorse.Put('/order', PutOrderStatus);
  THorse.Get('/order/:id/event-listen', GetOrderEventListen);
end;

end.

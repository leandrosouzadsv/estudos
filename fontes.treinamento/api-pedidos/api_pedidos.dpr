program api_pedidos;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Contract.Repository.Order in 'src\contracts\Contract.Repository.Order.pas',
  Contract.Entity.Order in 'src\contracts\Contract.Entity.Order.pas',
  Enum.OrderStatus in 'src\enums\Enum.OrderStatus.pas',
  Contract.Entity.Product in 'src\contracts\Contract.Entity.Product.pas',
  Contract.Service.Order in 'src\contracts\Contract.Service.Order.pas',
  Repository.Order in 'src\repositories\Repository.Order.pas',
  Entity.Order in 'src\entities\Entity.Order.pas',
  Entity.Product in 'src\entities\Entity.Product.pas',
  Contract.Entity.Base in 'src\contracts\Contract.Entity.Base.pas',
  Entity.Base in 'src\entities\Entity.Base.pas',
  Service.Order in 'src\services\Service.Order.pas',
  State.Order in 'src\states\State.Order.pas',
  Contract.State.Order in 'src\contracts\Contract.State.Order.pas',
  Controller.Order in 'src\controller\Controller.Order.pas',
  Contract.Facade.Order in 'src\contracts\Contract.Facade.Order.pas',
  Facade.Order in 'src\facades\Facade.Order.pas',
  Singleton.Facade.Order in 'src\singletons\Singleton.Facade.Order.pas',
  Util.InterfacedObjectJson in 'src\utils\Util.InterfacedObjectJson.pas',
  Contract.Horse.ServerExceptionConverter in 'src\contracts\Contract.Horse.ServerExceptionConverter.pas',
  Horse.ServerException in 'src\middlewares\Horse.ServerException.pas',
  Horse.ExceptionConverter.InvalidJson in 'src\horse-exception-converters\Horse.ExceptionConverter.InvalidJson.pas',
  Horse.SSE.Callback in 'src\sent-event\Horse.SSE.Callback.pas',
  Horse.SSE.Contract.Client in 'src\sent-event\Horse.SSE.Contract.Client.pas',
  Horse.SSE.Contract.Message in 'src\sent-event\Horse.SSE.Contract.Message.pas',
  Horse.SSE.Contract.Room in 'src\sent-event\Horse.SSE.Contract.Room.pas',
  Horse.SSE.Message in 'src\sent-event\Horse.SSE.Message.pas',
  Horse.SSE.Room in 'src\sent-event\Horse.SSE.Room.pas',
  Singleton.RoomManager in 'src\singletons\Singleton.RoomManager.pas',
  Connection.Redis.PoolManager in 'src\connections\Connection.Redis.PoolManager.pas',
  Horse.SSE.Client in 'src\sent-event\Horse.SSE.Client.pas',
  Config.Redis in 'src\configs\Config.Redis.pas';

begin
  try
    THorse.Use(Jhonson);
    THorse.Use(THorseServerException.Invoke);
    TOrderController.RegisterRouter;
    THorse.Listen;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

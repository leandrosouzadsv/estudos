program Server.API;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Contract.Repository.Order in 'src\contracts\Contract.Repository.Order.pas',
  Contract.Entity.Order in 'src\contracts\Contract.Entity.Order.pas',
  Enum.OrderStatus in 'src\enums\Enum.OrderStatus.pas',
  Contract.Entity.Product in 'src\contracts\Contract.Entity.Product.pas',
  Contract.Service.Order in 'src\contracts\Contract.Service.Order.pas',
  Repository.Order in 'src\repository\Repository.Order.pas',
  Entity.Order in 'src\entities\Entity.Order.pas',
  Entity.Product in 'src\entities\Entity.Product.pas',
  Contract.Entity.Base in 'src\contracts\Contract.Entity.Base.pas',
  Entity.Base in 'src\entities\Entity.Base.pas',
  Service.Order in 'src\services\Service.Order.pas';

begin
  try
    Writeln('Service API is running');

  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

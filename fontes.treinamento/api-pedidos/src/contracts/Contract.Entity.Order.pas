unit Contract.Entity.Order;

interface

uses
  Enum.OrderStatus,
  Contract.Entity.Product,
  Contract.Entity.Base;

type

  IOrderEntity = interface(IBaseEntity)
    ['{D0033F3A-5F6E-4D13-9547-1FD4F07AE042}']
    function GetStatus: TOrderStatus;
    procedure SetStatus(const AStatus: TOrderStatus);
    // function GetProductCollection: TArray<IProductEntity>;
    // procedure SetProductCollection(const AProductCollection: TArray<IProductEntity>);
  end;

implementation

end.

unit Contract.Entity.Order;

interface

uses
  Enum.OrderStatus,
  Contract.Entity.Product,
  Contract.Entity.Base;

type
  IOrderEntity = interface(IEntityBase)
    function GetId: UInt64;
    function GetStatus: TOrderStatus;
//    function GetProductCollection:TArray<IProductEntity>;

//    procedure SetProductCollection(const poProductCollection: TArray<IProductEntity>);
    Procedure SetStatus(const peOrderStatus:TOrderStatus);
  end;

implementation

end.

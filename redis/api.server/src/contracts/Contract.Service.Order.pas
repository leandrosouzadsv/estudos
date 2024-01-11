unit Contract.Service.Order;

interface

uses
  Contract.Entity.Order;

type
  IOrderService = interface
    ['{528DE130-423B-4B94-82D8-F9AD0E6A8F38}']
    function GetOrderCollection:TArray<IOrderEntity>;

    procedure PersistOrderEntity(const pOrderEntity: IOrderEntity);
    procedure UpdateOrderById(const poOrderEntity: IOrderEntity);
    procedure RemoveOrderById(const piOrderId: UInt64);
  end;

implementation

end.

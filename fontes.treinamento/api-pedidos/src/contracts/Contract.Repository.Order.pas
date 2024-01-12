unit Contract.Repository.Order;

interface

uses
  Contract.Entity.Order;

type

  IOrderRepository = interface
    ['{5D037808-F836-4554-8104-969ACD997790}']
    function ExistsOrderById(const AOrderId: UInt64): Boolean;
    procedure PersistOrderEntity(const AOrderEntity: IOrderEntity);
    function GetOrderById(const AOrderId: UInt64): IOrderEntity;
    function GetOrderCollection: TArray<IOrderEntity>;
    procedure UpdateOrder(const AOrderEntity: IOrderEntity);
    procedure RemoveOrderById(const AOrderId: UInt64);
  end;

implementation

end.

unit Contract.Service.Order;

interface

uses
  Contract.Entity.Order;

type

  IOrderService = interface
    ['{B6BCF1E9-DAA9-4233-A8C4-4888B3A1CF85}']
    procedure PersistOrderEntity(const AOrderEntity: IOrderEntity);
    function GetOrderCollection: TArray<IOrderEntity>;
    procedure UpdateOrder(const AOrderEntity: IOrderEntity);
    procedure RemoveOrderById(const AOrderId: UInt64);
  end;

implementation

end.

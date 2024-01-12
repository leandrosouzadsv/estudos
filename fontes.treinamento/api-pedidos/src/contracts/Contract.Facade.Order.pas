unit Contract.Facade.Order;

interface

uses
  Contract.Entity.Order;

type

  IOrderFacade = interface
    ['{2A08E23F-CAA1-42C3-9936-86F829CDCF17}']
    procedure PersistOrderEntity(const AOrderEntity: IOrderEntity);
    function GetOrderCollection: TArray<IOrderEntity>;
    procedure UpdateOrder(const AOrderEntity: IOrderEntity);
    procedure RemoveOrderById(const AOrderId: UInt64);
  end;

implementation

end.

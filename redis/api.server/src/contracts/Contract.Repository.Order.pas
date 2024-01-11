unit Contract.Repository.Order;

interface

uses
  Contract.Entity.Order;

type
  IOrderRepository = interface
    ['{71190054-3F66-4F5B-952F-19B528B1D063}']
    function ExistsOrderById:Boolean;
    function GetOrderById(const piOrderId: UInt64):IOrderEntity;
    function GetOrderCollection:TArray<IOrderEntity>;
    procedure PersistOrderEntity(const pOrderEntity: IOrderEntity);
    procedure UpdateOrderById(const poOrderEntity: IOrderEntity);
    procedure RemoveOrderById(const piOrderId: UInt64);
  end;

implementation

end.

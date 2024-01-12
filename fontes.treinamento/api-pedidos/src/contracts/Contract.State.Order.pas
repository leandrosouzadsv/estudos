unit Contract.State.Order;

interface

uses
  Contract.Entity.Order;

type

  IOrderState = interface
    function ContainsOrder(const AKey: UInt64): Boolean;
    function GetOrder(const AKey: UInt64): IOrderEntity;
    function GetOrderCollection: TArray<IOrderEntity>;
    procedure AddOrder(const AOrder: IOrderEntity);
    procedure UpdateOrder(const AOrder: IOrderEntity);
    procedure RemoveOrder(const AKey: UInt64);
  end;

implementation

end.

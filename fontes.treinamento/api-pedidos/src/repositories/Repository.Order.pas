unit Repository.Order;

interface

uses
  Contract.Repository.Order,
  Contract.Entity.Order,
  Contract.State.Order;

type

  TOrderRepository = class(TInterfacedObject, IOrderRepository)
  strict private
    { strict private declarations }
    constructor Create(const AOrderState: IOrderState);
  private
    { private declarations }
    FOrderState: IOrderState;
  protected
    { protected declarations }
  public
    { public declarations }
    function ExistsOrderById(const AOrderId: UInt64): Boolean;
    procedure PersistOrderEntity(const AOrderEntity: IOrderEntity);
    function GetOrderById(const AOrderId: UInt64): IOrderEntity;
    function GetOrderCollection: TArray<IOrderEntity>;
    procedure UpdateOrder(const AOrderEntity: IOrderEntity);
    procedure RemoveOrderById(const AOrderId: UInt64);
    class function New(const AOrderState: IOrderState): IOrderRepository;
  end;

implementation

{ TOrderRepository }

constructor TOrderRepository.Create(const AOrderState: IOrderState);
begin
  FOrderState := AOrderState;
end;

function TOrderRepository.ExistsOrderById(const AOrderId: UInt64): Boolean;
begin
  Result := FOrderState.ContainsOrder(AOrderId);
end;

function TOrderRepository.GetOrderById(const AOrderId: UInt64): IOrderEntity;
begin
  Result := FOrderState.GetOrder(AOrderId);
end;

function TOrderRepository.GetOrderCollection: TArray<IOrderEntity>;
begin
  Result := FOrderState.GetOrderCollection;
end;

class function TOrderRepository.New(const AOrderState: IOrderState): IOrderRepository;
begin
  Result := Self.Create(AOrderState);
end;

procedure TOrderRepository.PersistOrderEntity(const AOrderEntity: IOrderEntity);
begin
  FOrderState.AddOrder(AOrderEntity);
end;

procedure TOrderRepository.RemoveOrderById(const AOrderId: UInt64);
begin
  FOrderState.RemoveOrder(AOrderId);
end;

procedure TOrderRepository.UpdateOrder(const AOrderEntity: IOrderEntity);
begin
  FOrderState.UpdateOrder(AOrderEntity);
end;

end.

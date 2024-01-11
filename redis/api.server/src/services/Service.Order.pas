unit Service.Order;

interface

uses
  Contract.Service.Order,
  Contract.Entity.Order,
  Contract.Repository.Order;

type
  TOrderService = class(TInterfacedObject, IOrderService)
  strict private
      constructor Create(const poOrderRepository: IOrderRepository);
  private
    FOrderRepository: IOrderRepository;
  public
    function GetOrderCollection:TArray<IOrderEntity>;

    procedure PersistOrderEntity(const poOrderEntity: IOrderEntity);
    procedure UpdateOrderById(const poOrderEntity: IOrderEntity);
    procedure RemoveOrderById(const piOrderId: UInt64);

    class function New(const poOrderRepository: IOrderRepository):IOrderService;
  end;

implementation

{ TOrderService }

constructor TOrderService.Create(const poOrderRepository: IOrderRepository);
begin
  FOrderRepository := poOrderRepository;
end;

function TOrderService.GetOrderCollection: TArray<IOrderEntity>;
begin
  Result := FOrderRepository.GetOrderCollection;
end;

class function TOrderService.New(const poOrderRepository: IOrderRepository): IOrderService;
begin
  Result := Self.Create(poOrderRepository);
end;

procedure TOrderService.PersistOrderEntity(const poOrderEntity: IOrderEntity);
begin
  FOrderRepository.PersistOrderEntity(poOrderEntity);
end;

procedure TOrderService.RemoveOrderById(const piOrderId: UInt64);
begin
  FOrderRepository.RemoveOrderById(piOrderId);
end;

procedure TOrderService.UpdateOrderById(const poOrderEntity: IOrderEntity);
begin
  FOrderRepository.UpdateOrderById(poOrderEntity);
end;

end.

unit Service.Order;

interface

uses
  Contract.Service.Order,
  Contract.Entity.Order,
  Contract.Repository.Order;

type

  TOrderService = class(TInterfacedObject, IOrderService)
  strict private
    { strict private declarations }
    constructor Create(const AOrderRepository: IOrderRepository);
  private
    { private declarations }
    FOrderRepository: IOrderRepository;
  protected
    { protected declarations }
  public
    { public declarations }
    procedure PersistOrderEntity(const AOrderEntity: IOrderEntity);
    function GetOrderCollection: TArray<IOrderEntity>;
    procedure UpdateOrder(const AOrderEntity: IOrderEntity);
    procedure RemoveOrderById(const AOrderId: UInt64);
    class function New(const AOrderRepository: IOrderRepository): IOrderService;
  end;

implementation

{ TOrderService }

constructor TOrderService.Create(const AOrderRepository: IOrderRepository);
begin
  FOrderRepository := AOrderRepository;
end;

function TOrderService.GetOrderCollection: TArray<IOrderEntity>;
begin
  Result := FOrderRepository.GetOrderCollection;
end;

class function TOrderService.New(const AOrderRepository: IOrderRepository): IOrderService;
begin
  Result := Self.Create(AOrderRepository);
end;

procedure TOrderService.PersistOrderEntity(const AOrderEntity: IOrderEntity);
begin
  FOrderRepository.PersistOrderEntity(AOrderEntity);
end;

procedure TOrderService.RemoveOrderById(const AOrderId: UInt64);
begin
  FOrderRepository.RemoveOrderById(AOrderId);
end;

procedure TOrderService.UpdateOrder(const AOrderEntity: IOrderEntity);
begin
  FOrderRepository.UpdateOrder(AOrderEntity);
end;

end.

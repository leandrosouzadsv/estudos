unit Facade.Order;

interface

uses
  Contract.Facade.Order,
  Contract.Entity.Order,
  Contract.Service.Order,
  Contract.Repository.Order,
  Contract.State.Order;

type

  TOrderFacade = class(TInterfacedObject, IOrderFacade)
  strict private
    { strict private declarations }
    constructor Create;
  private
    { private declarations }
    FOrderService: IOrderService;
    FOrderRepository: IOrderRepository;
    FOrderState: IOrderState;
  protected
    { protected declarations }
  public
    { public declarations }
    procedure PersistOrderEntity(const AOrderEntity: IOrderEntity);
    function GetOrderCollection: TArray<IOrderEntity>;
    procedure UpdateOrder(const AOrderEntity: IOrderEntity);
    procedure RemoveOrderById(const AOrderId: UInt64);
    class function New: IOrderFacade;
  end;

implementation

uses
  Service.Order,
  Repository.Order,
  State.Order;

{ TOrderFacade }

constructor TOrderFacade.Create;
begin
  FOrderState := TOrderState.New;
  FOrderRepository := TOrderRepository.New(FOrderState);
  FOrderService := TOrderService.New(FOrderRepository);
end;

function TOrderFacade.GetOrderCollection: TArray<IOrderEntity>;
begin
  Result := FOrderService.GetOrderCollection;
end;

class function TOrderFacade.New: IOrderFacade;
begin
  Result := Self.Create;
end;

procedure TOrderFacade.PersistOrderEntity(const AOrderEntity: IOrderEntity);
begin
  FOrderService.PersistOrderEntity(AOrderEntity);
end;

procedure TOrderFacade.RemoveOrderById(const AOrderId: UInt64);
begin
  FOrderService.RemoveOrderById(AOrderId);
end;

procedure TOrderFacade.UpdateOrder(const AOrderEntity: IOrderEntity);
begin
  FOrderService.UpdateOrder(AOrderEntity);
end;

end.

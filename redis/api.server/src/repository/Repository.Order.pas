unit Repository.Order;

interface

uses
  Contract.Repository.Order,
  Contract.Entity.Order;

type
  TOrderRepository = class(TInterfacedObject, IOrderRepository)
  strict private
    constructor Create;
  public
    function ExistsOrderById:Boolean;
    function GetOrderById(const piOrderId: UInt64):IOrderEntity;
    function GetOrderCollection:TArray<IOrderEntity>;
    procedure PersistOrderEntity(const pOrderEntity: IOrderEntity);
    procedure UpdateOrderById(const poOrderEntity: IOrderEntity);
    procedure RemoveOrderById(const piOrderId: UInt64);

    class function New: IOrderRepository;
  end;

implementation

{ TOrderRepository }

constructor TOrderRepository.Create;
begin

end;

function TOrderRepository.ExistsOrderById: Boolean;
begin

end;

function TOrderRepository.GetOrderById(const piOrderId: UInt64): IOrderEntity;
begin

end;

function TOrderRepository.GetOrderCollection: TArray<IOrderEntity>;
begin

end;

class function TOrderRepository.New: IOrderRepository;
begin
  Result := Self.Create;
end;

procedure TOrderRepository.PersistOrderEntity(const pOrderEntity: IOrderEntity);
begin

end;

procedure TOrderRepository.RemoveOrderById(const piOrderId: UInt64);
begin

end;

procedure TOrderRepository.UpdateOrderById(const poOrderEntity: IOrderEntity);
begin

end;

end.

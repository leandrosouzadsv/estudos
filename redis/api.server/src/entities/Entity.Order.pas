unit Entity.Order;

interface

uses
  Contract.Entity.Order,
  Enum.OrderStatus,
  Entity.Base;

type
  TOrderEntity = class(TBaseEntity, IOrderEntity)
  private
    FOrderStatus: TOrderStatus;
  public
    class function New(const piId:UInt64): IOrderEntity;
    function GetStatus: TOrderStatus;
    Procedure SetStatus(const peOrderStatus:TOrderStatus);
  end;


implementation

{ TOrderEntity }

function TOrderEntity.GetStatus: TOrderStatus;
begin
  Result := FOrderStatus;
end;

class function TOrderEntity.New(const piId: UInt64): IOrderEntity;
begin
  Self.Create(piId);
end;

procedure TOrderEntity.SetStatus(const peOrderStatus: TOrderStatus);
begin
  FOrderStatus := peOrderStatus;
end;

end.

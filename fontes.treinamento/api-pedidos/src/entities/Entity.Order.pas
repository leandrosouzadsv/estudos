unit Entity.Order;

interface

uses
  Contract.Entity.Order,
  Enum.OrderStatus,
  Entity.Base;

type

  TOrderEntity = class(TBaseEntity, IOrderEntity)
  strict private
    { strict private declarations }
  private
    { private declarations }
    FStatus: TOrderStatus;
  protected
    { protected declarations }
  public
    { public declarations }
    function GetStatus: TOrderStatus;
    procedure SetStatus(const AStatus: TOrderStatus);
    class function New: IOrderEntity; overload;
    class function New(const AId: UInt64): IOrderEntity; overload;
  end;

implementation

{ TOrderEntity }

function TOrderEntity.GetStatus: TOrderStatus;
begin
  Result := FStatus;
end;

class function TOrderEntity.New(const AId: UInt64): IOrderEntity;
begin
  Result := Self.CreateWithId(AId);
end;

class function TOrderEntity.New: IOrderEntity;
begin
  Result := Self.Create;
end;

procedure TOrderEntity.SetStatus(const AStatus: TOrderStatus);
begin
  FStatus := AStatus;
end;

end.

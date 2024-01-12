unit State.Order;

interface

uses
  System.Generics.Collections,
  Contract.State.Order,
  Contract.Entity.Order;

type

  TOrderState = class(TInterfacedObject, IOrderState)
  strict private
    { strict private declarations }
    constructor Create;
  private
    { private declarations }
    FOrderCollection: TDictionary<UInt64, IOrderEntity>;
  protected
    { protected declarations }
  public
    { public declarations }
    destructor Destroy; override;
    function ContainsOrder(const AKey: UInt64): Boolean;
    function GetOrder(const AKey: UInt64): IOrderEntity;
    function GetOrderCollection: TArray<IOrderEntity>;
    procedure AddOrder(const AOrder: IOrderEntity);
    procedure UpdateOrder(const AOrder: IOrderEntity);
    procedure RemoveOrder(const AKey: UInt64);
    class function New: IOrderState;
  end;

implementation

uses
  System.SysUtils;

{ TOrderState }

procedure TOrderState.AddOrder(const AOrder: IOrderEntity);
begin
  FOrderCollection.Add(AOrder.GetId, AOrder);
end;

function TOrderState.ContainsOrder(const AKey: UInt64): Boolean;
begin
  Result := FOrderCollection.ContainsKey(AKey);
end;

constructor TOrderState.Create;
begin
  FOrderCollection := TDictionary<UInt64, IOrderEntity>.Create;
end;

destructor TOrderState.Destroy;
begin
  FOrderCollection.Free;
  inherited;
end;

function TOrderState.GetOrder(const AKey: UInt64): IOrderEntity;
begin
  Result := FOrderCollection.Items[AKey];
end;

function TOrderState.GetOrderCollection: TArray<IOrderEntity>;
begin
  Result := FOrderCollection.Values.ToArray;
end;

class function TOrderState.New: IOrderState;
begin
  Result := Self.Create;
end;

procedure TOrderState.RemoveOrder(const AKey: UInt64);
begin
  FOrderCollection.Remove(AKey);
end;

procedure TOrderState.UpdateOrder(const AOrder: IOrderEntity);
begin
  if not FOrderCollection.ContainsKey(AOrder.GetId) then
    raise Exception.Create('Order not found');
  FOrderCollection.AddOrSetValue(AOrder.GetId, AOrder);
end;

end.

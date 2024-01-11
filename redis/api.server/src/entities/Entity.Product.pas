unit Entity.Product;

interface

uses
  Contract.Entity.Product, Contract.Entity.Base, Entity.Base;

type
  TProductEntity = class(TBaseEntity, IProductEntity)
  strict private

  private
    FName: string;
  public
    class function New(const piId:UInt64): IProductEntity;
    function GetName: string;
    procedure SetName(const psName: string);
  end;

implementation

{ TProductEntity }

function TProductEntity.GetName: string;
begin
  Result := FName;
end;

class function TProductEntity.New(const piId: UInt64): IProductEntity;
begin
  result := Self.Create(piId);
end;

procedure TProductEntity.SetName(const psName: string);
begin
  FName := psName;
end;

end.

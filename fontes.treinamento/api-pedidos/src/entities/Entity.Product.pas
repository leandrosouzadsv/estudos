unit Entity.Product;

interface

uses
  Contract.Entity.Product,
  Entity.Base;

type

  TProductEntity = class(TBaseEntity, IProductEntity)
  strict private
    { strict private declarations }
  private
    { private declarations }
    FName: string;
  protected
    { protected declarations }
  public
    { public declarations }
    function GetName: string;
    procedure SetName(const AName: string);
    class function New: IProductEntity; overload;
    class function New(const AId: UInt64): IProductEntity; overload;
  end;

implementation

{ TProductEntity }

function TProductEntity.GetName: string;
begin
  Result := FName;
end;

class function TProductEntity.New(const AId: UInt64): IProductEntity;
begin
  Result := Self.CreateWithId(AId);
end;

class function TProductEntity.New: IProductEntity;
begin
  Result := Self.Create;
end;

procedure TProductEntity.SetName(const AName: string);
begin
  FName := AName;
end;

end.

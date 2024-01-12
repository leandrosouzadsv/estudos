unit Entity.Base;

interface

uses
  Contract.Entity.Base;

type

  TBaseEntity = class(TInterfacedObject, IBaseEntity)
  strict private
    { strict private declarations }
  private
    { private declarations }
    FId: UInt64;
  protected
    { protected declarations }
  public
    { public declarations }
    constructor Create;
    constructor CreateWithId(const AId: UInt64);
    function GetId: UInt64;
  end;

implementation

uses
  SnowFlake;

{ TBaseEntity }

constructor TBaseEntity.Create;
begin
  FId := TSnowflakeGeneratorBuilder.New.Build.GenerateID(0);
end;

constructor TBaseEntity.CreateWithId(const AId: UInt64);
begin
  FId := AId;
end;

function TBaseEntity.GetId: UInt64;
begin
  Result := FId;
end;

end.

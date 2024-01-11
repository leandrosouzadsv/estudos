unit Entity.Base;

interface

uses
  Contract.Entity.Base;

type
  TBaseEntity = class(TInterfacedObject, IEntityBase)
  private
    FId: UInt64;
  public
    constructor Create(const piId:UInt64);
    function GetId: UInt64;
  end;

implementation

uses
  SnowFlake;

{ TEntityBase }

constructor TBaseEntity.Create(const piId: UInt64);
begin
  FId := piId;

  if FId = 0 then
    Fid := TSnowflakeGeneratorBuilder.New.Build.GenerateID(0);
end;

function TBaseEntity.GetId: UInt64;
begin
  Result := FId;
end;

end.

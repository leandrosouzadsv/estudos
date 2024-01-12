unit Singleton.Facade.Order;

interface

uses
  Contract.Facade.Order;

type

  TOrderFacadeSingleton = class
  strict private
    { strict private declarations }
  private
    { private declarations }
    class var
      FOrderFacade: IOrderFacade;
  protected
    { protected declarations }
  public
    { public declarations }
    class function New: IOrderFacade;
  end;

implementation

uses
  Facade.Order;

{ TOrderFacadeSingleton }

class function TOrderFacadeSingleton.New: IOrderFacade;
begin
  if FOrderFacade = nil then
    FOrderFacade := TOrderFacade.New;
  Result := FOrderFacade;
end;

end.

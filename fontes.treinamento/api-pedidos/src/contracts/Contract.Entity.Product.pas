unit Contract.Entity.Product;

interface

uses
  Contract.Entity.Base;

type

  IProductEntity = interface(IBaseEntity)
    ['{824FB3A5-E513-4E0B-A810-598FDE787277}']
    function GetName: string;
    procedure SetName(const AName: string);
  end;

implementation

end.

unit Contract.Entity.Product;

interface

uses
  Contract.Entity.Base;

type
  IProductEntity = interface(IEntityBase)
    ['{6DADC241-2B5F-4CA6-B878-77FB838186C6}']
    function GetId: UInt64;
    function GetName: string;

    procedure SetName(const psName:String);
  end;


implementation

end.

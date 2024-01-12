unit Horse.SSE.Contract.Message;

interface

type

  ISSEMessage = interface
    ['{EA08FF71-00B8-4B8F-BCEC-A98737184D14}']
    function GetId: string;
    function GetEvent: string;
    function GetData: string;
  end;

implementation

end.

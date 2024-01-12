unit Contract.HTTPEventData;

interface

type

  IHTTPEventData = interface
    function GetId: string;
    function GetEvent: string;
    function GetData: string;
  end;

implementation

end.

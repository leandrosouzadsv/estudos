unit Contract.Horse.ServerExceptionConverter;

interface

uses
  System.SysUtils;

type

  IHorseServerExceptionConverter = interface
    ['{C67BF1DD-13DA-49BA-AA2E-FB2B19A14188}']
    function CanConvert(AException: Exception): Boolean;
    function GetMessage(AException: Exception): string;
    function GetErrorType(AException: Exception): string;
    function GetHint(AException: Exception): string;
    function GetStatusCode(AException: Exception): Integer;
  end;

implementation

end.

unit Horse.ExceptionConverter.InvalidJson;

interface

uses
  Contract.Horse.ServerExceptionConverter,
  System.SysUtils;

type

  THorseServerExceptionConverterInvalidJson = class(TInterfacedObject, IHorseServerExceptionConverter)
  strict private
    { strict private declarations }
    constructor Create;
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    function CanConvert(AException: Exception): Boolean;
    function GetMessage(AException: Exception): string;
    function GetErrorType(AException: Exception): string;
    function GetHint(AException: Exception): string;
    function GetStatusCode(AException: Exception): Integer;
    class function New: IHorseServerExceptionConverter;
  end;

implementation

uses

  Horse.ServerException;

{ THorseServerExceptionConverterInvalidJson }

function THorseServerExceptionConverterInvalidJson.CanConvert(AException: Exception): Boolean;
begin
  Result := AException.Message = 'Invalid json';
end;

constructor THorseServerExceptionConverterInvalidJson.Create;
begin

end;

function THorseServerExceptionConverterInvalidJson.GetErrorType(AException: Exception): string;
begin
  Result := 'invalid_json';
end;

function THorseServerExceptionConverterInvalidJson.GetHint(AException: Exception): string;
begin
  Result := '';
end;

function THorseServerExceptionConverterInvalidJson.GetMessage(AException: Exception): string;
begin
  Result := 'O JSON informado é invalido';
end;

function THorseServerExceptionConverterInvalidJson.GetStatusCode(AException: Exception): Integer;
begin
  Result := 400;
end;

class function THorseServerExceptionConverterInvalidJson.New: IHorseServerExceptionConverter;
begin
  Result := Self.Create;
end;

initialization

 THorseServerException.RegisterConveter(THorseServerExceptionConverterInvalidJson.New);

end.

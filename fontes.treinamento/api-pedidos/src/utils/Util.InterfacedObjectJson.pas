unit Util.InterfacedObjectJson;

interface

uses
  System.JSON;

type

  TInterfacedObjectJsonUtil = class(TObject)
  private
    { private declarations }
  protected
    { protected declarations }
  public
    { public declarations }
    class function InterfacedObjectToJsonObject<T: class, constructor; I: IInterface>(const AInterfacedObject: I): TJsonObject;
    class function JsonObjectToInterfacedObject<T: class, constructor; I: IInterface>(const IID: TGUID; const AJSONObject: TJsonObject): I;
    class function InterfacedObjectArrayToJsonArray<T: class, constructor; I: IInterface>(const AInterfacedObjectArray: TArray<I>): TJsonArray;
    class function JsonArrayToInterfacedObjectArray<T: class, constructor; I: IInterface>(const IID: TGUID; const AJSONArray: TJsonArray): TArray<I>;
  end;

implementation

uses
  System.SysUtils,
  System.Generics.Collections,
  REST.JSON;

{ TInterfacedObjectJsonUtil }

class function TInterfacedObjectJsonUtil.InterfacedObjectArrayToJsonArray<T, I>(const AInterfacedObjectArray: TArray<I>): TJsonArray;
var
  LInteractor: Integer;
begin
  Result := TJsonArray.Create;
  for LInteractor := Low(AInterfacedObjectArray) to High(AInterfacedObjectArray) do
    Result.Add(InterfacedObjectToJsonObject<T, I>(AInterfacedObjectArray[LInteractor]));
end;

class function TInterfacedObjectJsonUtil.InterfacedObjectToJsonObject<T, I>(const AInterfacedObject: I): TJsonObject;
begin
  Result := TJson.ObjectToJsonObject(AInterfacedObject as T);
end;

class function TInterfacedObjectJsonUtil.JsonArrayToInterfacedObjectArray<T, I>(const IID: TGUID; const AJSONArray: TJsonArray): TArray<I>;
var
  LInteractor: Integer;
begin
  SetLength(Result, AJSONArray.Count);
  for LInteractor := 0 to Pred(AJSONArray.Count) do
    Result[LInteractor] := JsonObjectToInterfacedObject<T, I>(IID, AJSONArray.Items[LInteractor] as TJsonObject);
end;

class function TInterfacedObjectJsonUtil.JsonObjectToInterfacedObject<T, I>(const IID: TGUID; const AJSONObject: TJsonObject): I;
var
  LObject: T;
  LOutputInterface: I;
begin
  LObject := TJson.JsonToObject<T>(AJSONObject);
  if Supports(LObject, IID, LOutputInterface) then
    Result := LOutputInterface;
end;

end.

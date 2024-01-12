unit Contract.HTTPClientEvent;

interface

uses
  Struct.Pair,
  Callback.ReceiveEventData;

type

  IHTTPClientEvent = interface
    ['{25624326-D5DF-4EA0-A3C2-72C297DD156C}']
    procedure Listen(const AUrl: string; const AHeaders: TPairArray);
    procedure SetOnReceiveEventData(const AOnReceiveEventDataCallback: TOnReceiveEventDataCallback);
  end;

implementation

end.

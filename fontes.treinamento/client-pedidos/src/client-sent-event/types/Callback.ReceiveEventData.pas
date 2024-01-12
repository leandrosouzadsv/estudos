unit Callback.ReceiveEventData;

interface

uses
  Contract.HTTPEventData;

type

  TOnReceiveEventDataCallback = reference to procedure(const AHTTPEventData: IHTTPEventData);

implementation

end.

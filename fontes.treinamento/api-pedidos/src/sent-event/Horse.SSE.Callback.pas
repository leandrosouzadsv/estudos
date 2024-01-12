unit Horse.SSE.Callback;

interface

uses
  Web.HTTPApp,
  Horse.SSE.Contract.Client;

type

  TClientConnectedCallback = reference to procedure(const ARoomName: string; const AClient: ISSEClient);
  TClientDisconnectedCallback = reference to procedure(const ARoomName: string; const ASSEId: string);

implementation

end.

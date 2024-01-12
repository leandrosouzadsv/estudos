unit Horse.SSE.Contract.Room;

interface

uses
  System.SysUtils,
  System.Generics.Collections,
  Horse.SSE.Contract.Message,
  Horse.SSE.Callback,
  Web.HTTPApp,
  Horse.SSE.Contract.Client;

type

  ISSERoom = interface
    ['{D920D11F-FE26-4A48-8DDA-25188AD95AD2}']
    function GetRoomName: string;
    procedure SendMessage(const AMessage: ISSEMessage);
    procedure InitializeSSE(const ARequest: TWebRequest; const AResponse: TWebResponse);
    function GetClientCollection: TDictionary<string, ISSEClient>;
    procedure SetOnClientConnected(const AOnClientConnectedCallback: TClientConnectedCallback);
    procedure SetOnClientDisconnected(const AOnClientDisconnectedCallback: TClientDisconnectedCallback);
  end;

implementation

end.

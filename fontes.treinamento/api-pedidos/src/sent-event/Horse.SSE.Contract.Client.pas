unit Horse.SSE.Contract.Client;

interface

uses
  Horse.SSE.Contract.Message,
  Web.HTTPApp;

type

  ISSEClient = interface
    ['{96459CB4-4906-4ACA-91C0-59CF940D048E}']
    function GetSSEId: string;
    function GetRoom: string;
    procedure InitializeSSE(const ARequest: TWebRequest; const AResponse: TWebResponse);
    procedure UnInitializeSSE;
    procedure SendMessage(const AMessage: ISSEMessage);
  end;

implementation

end.

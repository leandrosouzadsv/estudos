program client_pedidos;

uses
  System.StartUpCopy,
  FMX.Forms,
  View.Main in 'src\views\View.Main.pas' {Form1},
  Client.NetHTTP.HTTPClientEvent in 'src\client-sent-event\clients\Client.NetHTTP.HTTPClientEvent.pas',
  Contract.HTTPClientEvent in 'src\client-sent-event\contracts\Contract.HTTPClientEvent.pas',
  Contract.HTTPEventData in 'src\client-sent-event\contracts\Contract.HTTPEventData.pas',
  Event.HTTPEventData in 'src\client-sent-event\events\Event.HTTPEventData.pas',
  Parser.ContentString in 'src\client-sent-event\parsers\Parser.ContentString.pas',
  Callback.ReceiveEventData in 'src\client-sent-event\types\Callback.ReceiveEventData.pas',
  Struct.Pair in 'src\client-sent-event\types\Struct.Pair.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TForm1, Form1);
  Application.Run;
end.

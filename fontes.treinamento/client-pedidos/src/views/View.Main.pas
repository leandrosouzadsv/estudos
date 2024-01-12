unit View.Main;

interface

uses
  System.SysUtils,
  System.Types,
  System.UITypes,
  System.Classes,
  System.Variants,
  FMX.Types,
  FMX.Controls,
  FMX.Forms,
  FMX.Graphics,
  FMX.Dialogs,
  FMX.StdCtrls,
  FMX.Objects,
  FMX.Controls.Presentation,
  System.Net.URLClient,
  System.Net.HttpClient,
  System.Net.HttpClientComponent,
  FMX.Edit,
  Contract.HTTPClientEvent,
  System.SyncObjs,
  Contract.HTTPEventData;

type
  TForm1 = class(TForm)
    Button1: TButton;
    TextStatusPedido: TText;
    AniIndicatorStatusPedido: TAniIndicator;
    NetHTTPClient: TNetHTTPClient;
    EditOrderId: TEdit;
    Button2: TButton;
    procedure Button2Click(Sender: TObject);
    procedure FormCreate(Sender: TObject);
  private
    { Private declarations }
    FHTTPClientEvent: IHTTPClientEvent;
    FSimpleEvent: TSimpleEvent;
  public
    { Public declarations }
    procedure DoOnReceiveEventData(const AHTTPEventData: IHTTPEventData);
  end;

var
  Form1: TForm1;

implementation

uses
  System.JSON,
  Client.NetHTTP.HTTPClientEvent;

{$R *.fmx}


procedure TForm1.Button2Click(Sender: TObject);
begin
  AniIndicatorStatusPedido.Enabled := True;
  TControl(Sender).Enabled := False;
  TThread.CreateAnonymousThread(
    procedure
    var
      LWaitResult: TWaitResult;
    begin
      while True do
      begin
        try
          FHTTPClientEvent.Listen('http://127.0.0.1:9000/order/' + EditOrderId.Text + '/event-listen', []);
        except
        end;
        LWaitResult := FSimpleEvent.WaitFor(5000);
        if LWaitResult <> TWaitResult.wrTimeout then
          Break;
        FSimpleEvent.ResetEvent;
      end;
    end).Start;
end;

procedure TForm1.DoOnReceiveEventData(const AHTTPEventData: IHTTPEventData);
var
  LJSONEventData: TJSONObject;
begin
  if AHTTPEventData.GetEvent = 'order_status_update' then
  begin
    LJSONEventData := TJSONObject.ParseJSONValue(AHTTPEventData.GetData) as TJSONObject;
    try
      if LJSONEventData <> nil then
      begin
        TThread.Synchronize(nil,
          procedure
          begin
            TextStatusPedido.Text := LJSONEventData.GetValue<string>('status');
          end);
      end;
    finally
      LJSONEventData.Free;
    end;
  end;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  FSimpleEvent := TSimpleEvent.Create;
  FHTTPClientEvent := TNetHTTPClientEvent.New;
  FHTTPClientEvent.SetOnReceiveEventData(DoOnReceiveEventData);
end;

end.

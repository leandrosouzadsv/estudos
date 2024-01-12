unit Client.NetHTTP.HTTPClientEvent;

interface

uses
  System.SysUtils,
  System.SyncObjs,
  System.Net.HttpClient,
  System.Net.HttpClientComponent,
  Struct.Pair,
  Contract.HTTPClientEvent,
  Contract.HTTPEventData,
  Callback.ReceiveEventData;

type

  TNetHTTPClientEvent = class(TInterfacedObject, IHTTPClientEvent)
  strict private
    { strict private declarations }
    constructor Create;
  private
    { private declarations }
    FTerminated: Boolean;
    FSimpleEvent: TSimpleEvent;
    FNetHTTPClient: TNetHTTPClient;
    FHTTPResponse: IHTTPResponse;
    FOnReceiveEventDataCallback: TOnReceiveEventDataCallback;
  protected
    { protected declarations }
    procedure NetHTTPClientReceiveData(const Sender: TObject; AContentLength, AReadCount: Int64; var AAbort: Boolean);
    procedure DoOnReceiveEventData(const AHTTPEventData: IHTTPEventData);
    procedure NetHTTPClientRequestException(const Sender: TObject; const AError: Exception);
    procedure NetHTTPClientRequestError(const Sender: TObject; const AError: string);
    procedure NetHTTPClientRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
  public
    { public declarations }
    destructor Destroy; override;
    procedure Listen(const AUrl: string; const AHeaders: TPairArray);
    procedure SetOnReceiveEventData(const AOnReceiveEventDataCallback: TOnReceiveEventDataCallback);
    class function New: IHTTPClientEvent;
  end;

implementation

uses
  System.Classes,
  System.Net.URLClient,
  Parser.ContentString;

{ TNetHTTPClientEvent }

constructor TNetHTTPClientEvent.Create;
begin
  FTerminated := False;

  FNetHTTPClient := TNetHTTPClient.Create(nil);
  FNetHTTPClient.Asynchronous := True;
//  FNetHTTPClient.SynchronizeEvents := False;
  FNetHTTPClient.ConnectionTimeout := 0;
//  FNetHTTPClient.SendTimeout := 60000;
  FNetHTTPClient.ResponseTimeout := 0;
  FNetHTTPClient.OnReceiveData := NetHTTPClientReceiveData;
//  FNetHTTPClient.OnRequestException := NetHTTPClientRequestException;
  FNetHTTPClient.OnRequestError := NetHTTPClientRequestError;
  FNetHTTPClient.OnRequestCompleted := NetHTTPClientRequestCompleted;

  FSimpleEvent := TSimpleEvent.Create;
end;

destructor TNetHTTPClientEvent.Destroy;
begin
  FTerminated := True;
  FSimpleEvent.SetEvent;
  FNetHTTPClient.Free;
  inherited;
end;

procedure TNetHTTPClientEvent.DoOnReceiveEventData(const AHTTPEventData: IHTTPEventData);
begin
  if Assigned(FOnReceiveEventDataCallback) then
    FOnReceiveEventDataCallback(AHTTPEventData);
end;

procedure TNetHTTPClientEvent.Listen(const AUrl: string; const AHeaders: TPairArray);
var
  LHeaders: TNameValueArray;
  I: Integer;
begin
  FTerminated := False;
  LHeaders := [
    TNameValuePair.Create('Accept', 'text/event-stream')];
  for I := Low(AHeaders) to High(AHeaders) do
    LHeaders := LHeaders + [
      TNameValuePair.Create(AHeaders[I].Name, AHeaders[I].Value)];
  FHTTPResponse := FNetHTTPClient.Get(AUrl, nil, LHeaders);
  while not FTerminated do
  begin
    FSimpleEvent.WaitFor;
    FSimpleEvent.ResetEvent;
    if FHTTPResponse.StatusCode >= 400 then
      raise Exception.Create(FHTTPResponse.StatusText);
  end;
end;

procedure TNetHTTPClientEvent.NetHTTPClientReceiveData(const Sender: TObject; AContentLength, AReadCount: Int64; var AAbort: Boolean);
var
  LHTTPEvent: IHTTPEventData;
begin
  if (FHTTPResponse = nil) or (FTerminated) then
    Exit;
  FSimpleEvent.SetEvent;
  if AReadCount > 0 then
  begin
    if FHTTPResponse.ContentAsString(nil).EndsWith(sLineBreak + sLineBreak) then
    begin
      LHTTPEvent := TContentStringParser.Parse(FHTTPResponse.ContentAsString(nil));
      TMemoryStream(FHTTPResponse.ContentStream).Clear;
      DoOnReceiveEventData(LHTTPEvent);
    end;
  end;
end;

procedure TNetHTTPClientEvent.NetHTTPClientRequestCompleted(const Sender: TObject; const AResponse: IHTTPResponse);
begin
  FTerminated := True;
  FSimpleEvent.SetEvent;
end;

procedure TNetHTTPClientEvent.NetHTTPClientRequestError(const Sender: TObject; const AError: string);
begin
  FSimpleEvent.SetEvent;
end;

procedure TNetHTTPClientEvent.NetHTTPClientRequestException(const Sender: TObject; const AError: Exception);
begin
  FSimpleEvent.SetEvent;
end;

class function TNetHTTPClientEvent.New: IHTTPClientEvent;
begin
  Result := Self.Create;
end;

procedure TNetHTTPClientEvent.SetOnReceiveEventData(const AOnReceiveEventDataCallback: TOnReceiveEventDataCallback);
begin
  FOnReceiveEventDataCallback := AOnReceiveEventDataCallback;
end;

end.

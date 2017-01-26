/// <summary>
///   Unit contains the routines for the inter-process communication.
/// </summary>
unit uFunctions.IPC;

interface

type
  /// <summary>
  ///   The interface for the inter-process data server. The server shares the
  ///   data buffer with one or more clients.
  /// </summary>
  /// <typeparam name="T">
  ///   The type parameter for the shared data buffer.
  /// </typeparam>
  /// <remarks>
  ///   In case if more than one instance of the server are running on the
  ///   computer they will still share the same data buffer. And the clients
  ///   will read the last data stored by the server which flushed the data to
  ///   the shared memory last.
  /// </remarks>
  IIPCAsyncDataServer<T: record> = interface
    /// <summary>
    ///   Getter for the <see cref="uFunctions.IPC|IIPCDataServer&lt;T&gt;.Data">
    ///   Data</see> property.
    /// </summary>
    function GetData: T;
    /// <summary>
    ///   Setter for the <see cref="uFunctions.IPC|IIPCDataServer&lt;T&gt;.Data">
    ///   Data</see> property.
    /// </summary>
    procedure SetData(const Value: T);

    /// <summary>
    ///   Allows to read and set the shared data.
    /// </summary>
    property Data: T read GetData write SetData;
  end;

  /// <summary>
  ///   Implements <see cref="uFunctions.IPC|IIPCDataServer&lt;T&gt;" />
  ///   interface.
  /// </summary>
  TIPCAsyncDataServer<T: record> = class(TInterfacedObject, IIPCAsyncDataServer<T>)
  private
    /// <summary>
    ///   The file mapping object handle.
    /// </summary>
    FFile: THandle;
    /// <summary>
    ///   The pointer to the mapped view of the file.
    /// </summary>
    FData: ^T;
    /// <summary>
    ///   Implements the <see cref="uFunctions.IPC|IIPCDataServer&lt;T&gt;.Data" />
    ///    property.
    /// </summary>
    function GetData: T;
    /// <summary>
    ///   Implements the <see cref="uFunctions.IPC|IIPCDataServer&lt;T&gt;.Data" />
    ///    property.
    /// </summary>
    procedure SetData(const Value: T);
  public
    /// <param name="AID">
    ///   The unique name which identifies the server and is used by the
    ///   clients to access it.
    /// </param>
    /// <remarks>
    ///   The ID used for the memory mapped file name.
    /// </remarks>
    constructor Create(const AID: String);
    destructor Destroy; override;
  end;

  /// <summary>
  ///   The interface for the inter-process data server client. The client can
  ///   read the server shared buffer.
  /// </summary>
  /// <typeparam name="T">
  ///   The type parameter for the shared data buffer.
  /// </typeparam>
  IIPCAsyncDataClient<T: record> = interface
    /// <summary>
    ///   Reads the server shared data.
    /// </summary>
    /// <param name="AData">
    ///   The variable receives the data buffer from the server application.
    /// </param>
    /// <returns>
    ///   True if the read was successful or False if the server was not
    ///   running or any other reading error occurred.
    /// </returns>
    function ReadData(var AData: T): Boolean;
  end;

  /// <summary>
  ///   Implements the <see cref="uFunctions.IPC|IIPCDataClient&lt;T&gt;" />
  ///   interface.
  /// </summary>
  TIPCAsyncDataClient<T: record> = class(TInterfacedObject, IIPCAsyncDataClient<T>)
  private
    /// <summary>
    ///   Stores the server ID.
    /// </summary>
    FID: String;

    /// <summary>
    ///   Implements the <see cref="uFunctions.IPC|IIPCDataClient&lt;T&gt;.ReadData(T)" />
    ///    method.
    /// </summary>
    /// <returns>
    ///   Returns True if the server data was successfully read.
    /// </returns>
    function ReadData(var AData: T): Boolean;
  public
    /// <param name="AID">
    ///   The unique name which identifies the server.
    /// </param>
    /// <remarks>
    ///   The ID used for the memory mapped file name.
    /// </remarks>
    constructor Create(const AID: String);
  end;

implementation

uses
  Winapi.Windows,
  System.SysUtils;

constructor TIPCAsyncDataServer<T>.Create(const AID: String);
begin
  FFile := CreateFileMapping(0, nil, PAGE_READWRITE, 0, SizeOf(T), PWideChar(AID));
  if FFile = 0 then
    RaiseLastOSError;

  FData := MapViewOfFile(FFile, FILE_MAP_ALL_ACCESS, 0, 0, SizeOf(T));
  if FData = nil then
    RaiseLastOSError;
end;

destructor TIPCAsyncDataServer<T>.Destroy;
begin
  if FData <> nil then
    UnmapViewOfFile(FData);

  if FFile <> 0 then
    CloseHandle(FFile);

  inherited;
end;

function TIPCAsyncDataServer<T>.GetData: T;
begin
  Result := FData^;
end;

procedure TIPCAsyncDataServer<T>.SetData(const Value: T);
begin
  FData^ := Value;
  FlushViewOfFile(FData, SizeOf(T));
end;

constructor TIPCAsyncDataClient<T>.Create(const AID: String);
begin
  FID := AID;
end;

function TIPCAsyncDataClient<T>.ReadData(var AData: T): Boolean;
var
  LData: ^T;
  LFile: THandle;
begin
  Result := True;
  AData := Default(T);

  LFile := OpenFileMapping(FILE_MAP_READ, True, PWideChar(FID));
  if LFile = 0 then
    Exit(False);

  try
    LData := MapViewOfFile(LFile, FILE_MAP_READ, 0, 0, SizeOf(T));
    if LData = nil then
      Exit(False);

    try
      AData := LData^;
    finally
      UnmapViewOfFile(LData);
    end;
  finally
    CloseHandle(LFile);
  end;
end;

end.

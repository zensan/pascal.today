unit uProcQueue;

interface

uses
  {$IFDEF MSWINDOWS}
  Vcl.Controls,
  Winapi.Messages,
  Winapi.Windows,
  {$ENDIF}
  System.Classes,
  System.SysUtils,
  System.Generics.Collections;

type
  /// <summary>
  ///   Class provides the functionality to queue procedure for later execution in the windows message queue.
  /// </summary>
  ProcQueue = class sealed
  {$IFDEF MSWINDOWS}
  private type
    TQueueProcOwner = class;

    /// <summary>
    ///   Record stores the queue entry.
    /// </summary>
    TQueueEntry = record
      /// <summary>
      ///   Reference to the procedure.
      /// </summary>
      Proc: TProc;
      /// <summary>
      ///   Reference
      /// </summary>
      Owner: TQueueProcOwner;
      constructor Create(const AProc: TProc; const AOwner: TComponent);
    end;

    /// <summary>
    ///   The component automatically removes the queue entry
    ///   once the owner gets destroyed.
    /// </summary>
    TQueueProcOwner = class(TComponent)
    private
      /// <summary>
      ///   This flag is set when the entry is removed
      ///   when calling the procedure to avoid redundant
      ///   check of the list items for removal.
      /// </summary>
      FDeletingFromQueue: Boolean;
    public
      /// <summary>
      ///   Releases the object without checking the list.
      /// </summary>
      procedure Release;
      destructor Destroy; override;
    end;
  private class threadvar
    /// <summary>
    ///   Holds the list of enqueued procedures.
    /// </summary>
    FList: TList<TQueueEntry>;
    /// <summary>
    ///   The invisible window which processes the messages and
    ///   calls the queue procedures.
    /// </summary>
    FQueueHWND: HWND;
  {$ENDIF}
  private
    {$IFDEF MSWINDOWS}
    /// <summary>
    ///   Custom window procedure to process the queue.
    /// </summary>
    class procedure WndProc(var AMessage: TMessage);
    {$ENDIF}
  public
    /// <summary>
    ///   Procedure to enqueue the procedure for later execution in message queue.
    /// </summary>
    class procedure Enqueue(const AProc: TProc{$IFDEF MSWINDOWS}; const AOwner: TComponent = nil{$ENDIF});
    {$IFDEF MSWINDOWS}
    class destructor Destroy;
    {$ENDIF}
  end;

implementation

{$IFNDEF MSWINDOWS}
uses
  System.Threading;
{$ENDIF}

{ ProcQueue }

{$IFDEF MSWINDOWS}
class destructor ProcQueue.Destroy;
begin
  { Release the list and handler }
  if FQueueHWND <> 0 then
    DeallocateHWnd(FQueueHWND);

  FList.Free;
end;
{$ENDIF}

class procedure ProcQueue.Enqueue(const AProc: TProc{$IFDEF MSWINDOWS}; const AOwner: TComponent{$ENDIF});
begin
  {$IFDEF MSWINDOWS}
  if FList = nil then
    begin
      { Lazy create the list ad handler }
      FList := TList<TQueueEntry>.Create;
      FQueueHWND := AllocateHWnd(WndProc);
    end;

  { Add entry to the queue }
  FList.Add(TQueueEntry.Create(AProc, AOwner));

  { Post the message to the handler }
  PostMessage(FQueueHWND, WM_USER, 0, 0);

  {$ELSE}

  TTask.Run(
    procedure
    begin
      TThread.Queue(nil,
        procedure
        begin
          AProc;
        end)
    end)
  {$ENDIF}
end;

{$IFDEF MSWINDOWS}
destructor ProcQueue.TQueueProcOwner.Destroy;
var
  i: Integer;
begin
  { If we need to skip the queue check }
  if FDeletingFromQueue then
    begin
      inherited;
      Exit;
    end;

  { Remove the corresponding queue entry }
  i := 0;
  while i < FList.Count do
    if FList[i].Owner = Self then
      begin
        FList.Delete(i);
        Break;
      end
    else
      Inc(i);

  inherited;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
procedure ProcQueue.TQueueProcOwner.Release;
begin
  { Check for nil }
  if Self = nil then
    Exit;

  { Set the flag to skip check }
  FDeletingFromQueue := True;

  { Free the instance }
  Free;
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
constructor ProcQueue.TQueueEntry.Create(const AProc: TProc; const AOwner: TComponent);
begin
  Proc := AProc;
  { Create the handler if owner assigned }
  if AOwner = nil then
    Owner := nil
  else
    Owner := TQueueProcOwner.Create(AOwner)
end;
{$ENDIF}

{$IFDEF MSWINDOWS}
class procedure ProcQueue.WndProc(var AMessage: TMessage);
var
  LEntry: TQueueEntry;
begin
  if AMessage.Msg <> WM_USER then
    begin
      DefWindowProc(FQueueHWND, AMessage.Msg, AMessage.WParam, AMessage.LParam);
      Exit;
    end;

  { If no events queued then exit }
  if FList.Count = 0 then
    Exit;

  { Get fist entry }
  LEntry := FList.First;

  { Delete the entry form the list }
  FList.Delete(0);

  { Release the handler }
  LEntry.Owner.Release;

  { Call the enqueued procedure }
  LEntry.Proc();
end;
{$ENDIF}

end.

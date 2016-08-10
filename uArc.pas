/// <summary>
///   Unit contains the smart pointer implementation which can be used to wrap
///   the non-interfaced object for automatic memory management (so that they
///   are released once they leave the scope).
/// </summary>
unit uArc;

interface

(*
  Once you create the object using the Arc<T> record you do not need to release it manually anymore.

  Example 1:
  var
    L: Arc<TStringList>;
  begin
    L := TStringList.Create;
    L.Value.LoadFromFile(...);
  end;

  Example 2:
  var
    L: Arc<TFileStream>;
  begin
    L := TFileStream.Create(TFileStream.Create('C:\Path\To\File.ext', fmOpenRead or fmShareDenyNone);
    L.Value.Read(...);
  end;
*)

type
  /// <summary>
  ///   Smart record which releases the object once it goes out of scope.
  /// </summary>
  Arc<T: class> = record
  strict private
    /// <summary>
    ///   Hold the value for the source object.
    /// </summary>
    FValue: T;
    /// <summary>
    ///   Holds the reference to interface of the object owner.
    /// </summary>
    FObjectOwner: IInterface;
    /// <summary>
    ///   Getter for the <c>Value</c> property.
    /// </summary>
    function GetThis: T;
  private type
    /// <summary>
    ///   Special object which is releasing the source instance when goes out
    ///   of scope.
    /// </summary>
    TArcHolder = class(TInterfacedObject)
    private
      /// <summary>
      ///   Source object reference.
      /// </summary>
      FObject: TObject;
    public
      constructor Create(AObject: TObject);
      destructor Destroy; override;
    end;
  public
    /// <summary>
    ///   Property to access the source object.
    /// </summary>
    property This: T read GetThis;

    /// <summary>
    ///   Function returns the unmanaged instance and removes the ownership in
    ///   current record.
    /// </summary>
    function Extract: T;

    /// <summary>
    ///   Implicit conversion from source type.
    /// </summary>
    class operator Implicit(AFrom: T): Arc<T>;
    /// <summary>
    ///   Implicit conversion from smart record type to source.
    /// </summary>
    class operator Implicit(AFrom: Arc<T>): T;
  end;

implementation

{ TArc<T> }

function Arc<T>.Extract: T;
begin
  Result := This;
  TArcHolder(FObjectOwner).FObject := nil;
  FObjectOwner := nil;
end;

function Arc<T>.GetThis: T;
begin
  Result := FValue;
end;

class operator Arc<T>.Implicit(AFrom: T): Arc<T>;
begin
  try
    Result.FValue := AFrom;
    Result.FObjectOwner := TArcHolder.Create(AFrom);
  except
    AFrom.Free;
    raise;
  end;
end;

class operator Arc<T>.Implicit(AFrom: Arc<T>): T;
begin
  Result := AFrom.This;
end;

{ TArc<T>.TFreeTheValue }

constructor Arc<T>.TArcHolder.Create(AObject: TObject);
begin
  FObject := AObject;
end;

destructor Arc<T>.TArcHolder.Destroy;
begin
  FObject.Free;
  inherited;
end;

end.

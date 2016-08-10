unit uArc;

interface

type
  Arc<T: class, constructor> = record
  strict private
    FValue: T;
    FArcHolder: IInterface;
    function GetValue: T;
  private type
    TArcHolder = class(TInterfacedObject)
    private
      FObject: TObject;
    public
      constructor Create(AObject: TObject);
      destructor Destroy; override;
    end;
  public
    constructor Create(AValue: T); overload;
    class function Create: Arc<T>; overload; static;

    property Value: T read GetValue;
    
    class operator Implicit(AFrom: T): Arc<T>;
    class operator Implicit(AFrom: Arc<T>): T;
  end;

implementation

{ TArc<T> }

constructor Arc<T>.Create(AValue: T);
begin
  try
    FValue := AValue;
    FArcHolder := TArcHolder.Create(AValue);
  except
    AValue.Free;
    raise;
  end;
end;

class function Arc<T>.Create: Arc<T>;
begin
  Result := Arc<T>.Create(T.Create);
end;

function Arc<T>.GetValue: T;
var
  F: Arc<T>;
begin
  if FArcHolder = nil then
    begin
      F := Arc<T>.Create(T.Create);
      FValue := F.FValue;
      FArcHolder := F.FArcHolder;
    end;

  Result := FValue;
end;

class operator Arc<T>.Implicit(AFrom: T): Arc<T>;
begin
  Result := Arc<T>.Create(AFrom);
end;

class operator Arc<T>.Implicit(AFrom: Arc<T>): T;
begin
  Result := AFrom.GetValue;
end;

{ TArc<T>.TArcHolder }

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

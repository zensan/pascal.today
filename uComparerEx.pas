unit uComparerEx;

interface

uses
  System.Generics.Defaults,
  System.Generics.Collections,
  System.SysUtils;

type
  /// <summary>
  ///   The extended comparer function which retrieves the typed value from the
  ///   collection element.
  /// </summary>
  /// <typeparam name="T1">
  ///   The type of the source collection element.
  /// </typeparam>
  /// <typeparam name="T2">
  ///   The result value in the target type used for current sort.
  /// </typeparam>
  TComparerExFunc<T1, T2> = reference to function (const Arg: T1): T2;

  /// <summary>
  ///   The record which stores the information about the single comparison in
  ///   the chain.
  /// </summary>
  /// <typeparam name="T">
  ///   The source type for the comparison.
  /// </typeparam>
  TComparerExNode<T> = record
    /// <summary>
    ///   The flag indicates if the ordering should be done descending.
    /// </summary>
    Descending: Boolean;
    /// <summary>
    ///   The comparison function.
    /// </summary>
    Comparison: TComparison<T>;

    /// <param name="ADescending">
    ///   The value for the <see cref="uFunctions.Compare|TComparerExNode&lt;T&gt;.Descending">
    ///   Descending</see> field.
    /// </param>
    /// <param name="AComparison">
    ///   The value for the <see cref="uFunctions.Compare|TComparerExNode&lt;T&gt;.Comparison">
    ///   Comparison</see> field.
    /// </param>
    constructor Create(ADescending: Boolean; const AComparison: TComparison<T>);
  end;

  ///   Interface for the advanced comparer interface which supports
  ///   "language"-type building of the nested comparisons in human-readable
  ///   form.
  /// </summary>
  /// <typeparam name="T">
  ///   The source collection element type.
  /// </typeparam>
  IComparerEx<T> = interface(IComparer<T>)
    /// <summary>
    ///   Function adds the level of sorting by integer value.
    /// </summary>
    /// <param name="AFunc">
    ///   The integer value retrieving function.
    /// </param>
    function OrderBy(const AFunc: TComparerExFunc<T, Integer>): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the level of sorting by Int64 value.
    /// </summary>
    /// <param name="AFunc">
    ///   The Int64 value retrieving function.
    /// </param>
    function OrderBy(const AFunc: TComparerExFunc<T, Int64>): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the level of sorting by double value.
    /// </summary>
    /// <param name="AFunc">
    ///   The double value retrieving function.
    /// </param>
    function OrderBy(const AFunc: TComparerExFunc<T, Double>): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the level of sorting by datetime value.
    /// </summary>
    /// <param name="AFunc">
    ///   The datetime value retrieving function.
    /// </param>
    function OrderBy(const AFunc: TComparerExFunc<T, TDateTime>): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the level of sorting by date value.
    /// </summary>
    /// <param name="AFunc">
    ///   The date value retrieving function.
    /// </param>
    function OrderBy(const AFunc: TComparerExFunc<T, TDate>): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the level of sorting by string value.
    /// </summary>
    /// <param name="AFunc">
    ///   The string value retrieving function.
    /// </param>
    /// <param name="ACaseSensitive">
    ///   The flag to indicate if the sort is case sensitive or not.
    /// </param>
    function OrderBy(const AFunc: TComparerExFunc<T, String>; ACaseSensitive: Boolean = False): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the standard comparison function to the sorting levels.
    /// </summary>
    /// <param name="AFunc">
    ///   The comparison function to add.
    /// </param>
    function OrderBy(const AFunc: TComparison<T>): IComparerEx<T>; overload;

    /// <summary>
    ///   Function adds the level of sorting by integer value descending.
    /// </summary>
    /// <param name="AFunc">
    ///   The integer value retrieving function.
    /// </param>
    function OrderByDesc(const AFunc: TComparerExFunc<T, Integer>): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the level of sorting by Int64 value descending.
    /// </summary>
    /// <param name="AFunc">
    ///   The Int64 value retrieving function.
    /// </param>
    function OrderByDesc(const AFunc: TComparerExFunc<T, Int64>): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the level of sorting by double value descending.
    /// </summary>
    /// <param name="AFunc">
    ///   The double value retrieving function.
    /// </param>
    function OrderByDesc(const AFunc: TComparerExFunc<T, Double>): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the level of sorting by datetime value descending.
    /// </summary>
    /// <param name="AFunc">
    ///   The datetime value retrieving function.
    /// </param>
    function OrderByDesc(const AFunc: TComparerExFunc<T, TDateTime>): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the level of sorting by date value descending.
    /// </summary>
    /// <param name="AFunc">
    ///   The date value retrieving function.
    /// </param>
    function OrderByDesc(const AFunc: TComparerExFunc<T, TDate>): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the level of sorting by string value descending.
    /// </summary>
    /// <param name="AFunc">
    ///   The string value retrieving function.
    /// </param>
    /// <param name="ACaseSensitive">
    ///   The flag to indicate if the sort is case sensitive or not.
    /// </param>
    function OrderByDesc(const AFunc: TComparerExFunc<T, String>; ACaseSensitive: Boolean = False): IComparerEx<T>; overload;
    /// <summary>
    ///   Function adds the standard descending comparison function to the sorting levels.
    /// </summary>
    /// <param name="AFunc">
    ///   The comparison function to add.
    /// </param>
    function OrderByDesc(const AFunc: TComparison<T>): IComparerEx<T>; overload;

    /// <summary>
    ///   Function changes last comparison to ascending order.
    /// </summary>
    function Ascending: IComparerEx<T>;
    /// <summary>
    ///   Function changes last comparison to descending order.
    /// </summary>
    function Descending: IComparerEx<T>;
  end;

  /// <summary>
  ///   The implementation of the extended comparer.
  /// </summary>
  /// <typeparam name="T">
  ///   The source collection element type.
  /// </typeparam>
  TComparerEx<T> = class(TInterfacedObject, IComparerEx<T>)
  private
    /// <summary>
    ///   Keeps the references to the comparison functions.
    /// </summary>
    FComparisons: TArray<TComparerExNode<T>>;

    /// <summary>
    ///   Function adds new level of the sorting.
    /// </summary>
    /// <param name="AComparison">
    ///   The comparison level to add.
    /// </param>
    procedure AddComparison(const AComparison: TComparerExNode<T>);

    /// <summary>
    ///   Function adds a new sorting level for a specific data type.
    /// </summary>
    /// <typeparam name="TResult">
    ///   The specific data type to sort on.
    /// </typeparam>
    /// <param name="AFunc">
    ///   The data type value retrieving function.
    /// </param>
    /// <param name="ADescending">
    ///   The ordering direction flag.
    /// </param>
    function OrderByDefault<TResult>(AFunc: TComparerExFunc<T, TResult>; ADescending: Boolean = False): IComparerEx<T>;
    /// <summary>
    ///   Function adds a new sorting level with the custom sorting routine.
    /// </summary>
    /// <param name="AFunc">
    ///   The comparison function.
    /// </param>
    /// <param name="ADescending">
    ///   The ordering direction flag.
    /// </param>
    function OrderByCustom(AFunc: TComparison<T>; ADescending: Boolean = False): IComparerEx<T>;

    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderBy" />
    ///    method.
    /// </summary>
    function OrderBy(const AFunc: TComparerExFunc<T, Integer>): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderBy" />
    ///    method.
    /// </summary>
    function OrderBy(const AFunc: TComparerExFunc<T, Int64>): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderBy" />
    ///    method.
    /// </summary>
    function OrderBy(const AFunc: TComparerExFunc<T, Double>): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderBy" />
    ///    method.
    /// </summary>
    function OrderBy(const AFunc: TComparerExFunc<T, TDateTime>): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderBy" />
    ///    method.
    /// </summary>
    function OrderBy(const AFunc: TComparerExFunc<T, TDate>): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderBy" />
    ///    method.
    /// </summary>
    function OrderBy(const AFunc: TComparerExFunc<T, String>; ACaseSensitive: Boolean = False): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderBy" />
    ///    method.
    /// </summary>
    function OrderBy(const AFunc: TComparison<T>): IComparerEx<T>; overload;

    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderBy" />
    ///    method.
    /// </summary>
    function OrderByDesc(const AFunc: TComparerExFunc<T, Integer>): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderByDesc" />
    ///    method.
    /// </summary>
    function OrderByDesc(const AFunc: TComparerExFunc<T, Int64>): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderByDesc" />
    ///    method.
    /// </summary>
    function OrderByDesc(const AFunc: TComparerExFunc<T, Double>): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderByDesc" />
    ///    method.
    /// </summary>
    function OrderByDesc(const AFunc: TComparerExFunc<T, TDateTime>): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderByDesc" />
    ///    method.
    /// </summary>
    function OrderByDesc(const AFunc: TComparerExFunc<T, TDate>): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderByDesc" />
    ///    method.
    /// </summary>
    function OrderByDesc(const AFunc: TComparerExFunc<T, String>; ACaseSensitive: Boolean = False): IComparerEx<T>; overload;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.OrderByDesc" />
    ///    method.
    /// </summary>
    function OrderByDesc(const AFunc: TComparison<T>): IComparerEx<T>; overload;

    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.Ascending" />
    ///    method.
    /// </summary>
    function Ascending: IComparerEx<T>;
    /// <summary>
    ///   Implements <see cref="uFunctions.Compare|IComparerEx&lt;T&gt;.Descending" />
    ///    method.
    /// </summary>
    function Descending: IComparerEx<T>;

    /// <summary>
    ///   Implements the <c>IComparer&lt;T&gt;.Compare</c> method.
    /// </summary>
    function Compare(const ALeft, ARight: T): Integer;

    constructor Create(const ASource: TArray<TComparerExNode<T>>); overload;
  public
    /// <summary>
    ///   The constructor of the comparer.
    /// </summary>
    class function Create: IComparerEx<T>; overload;
  end;

implementation

procedure TComparerEx<T>.AddComparison(const AComparison: TComparerExNode<T>);
begin
  SetLength(FComparisons, Length(FComparisons) + 1);
  FComparisons[Length(FComparisons) - 1] := AComparison;
end;

function TComparerEx<T>.Ascending: IComparerEx<T>;
var
  LComparisons: TArray<TComparerExNode<T>>;
begin
  LComparisons := Copy(FComparisons);
  if LComparisons <> nil then
    LComparisons[Length(LComparisons) - 1].Descending := False;
  Result := TComparerEx<T>.Create(LComparisons);
end;

function TComparerEx<T>.Compare(const ALeft, ARight: T): Integer;
var
  i: Integer;
begin
  { Call the comparers. Do not use FOR IN statement as
    this leads to constructing of the enumerator object and
    drammatically affects the performance }
  for i := 0 to Length(FComparisons) - 1 do
    begin
      { Call the comparison }
      Result := FComparisons[i].Comparison(ALeft, ARight);

      { If the result is not "equal" }
      if Result <> 0 then
        begin
          { Invert result if descending flag is set }
          if FComparisons[i].Descending then
            Result := -Result;

          { Exit as we already determined the comparison result }
          Exit;
        end;
    end;

  { Values are equal by default }
  Result := 0;
end;

constructor TComparerEx<T>.Create(const ASource: TArray<TComparerExNode<T>>);
begin
  FComparisons := Copy(ASource);
end;

class function TComparerEx<T>.Create: IComparerEx<T>;
begin
  Result := Create(nil);
end;

function TComparerEx<T>.Descending: IComparerEx<T>;
var
  LComparisons: TArray<TComparerExNode<T>>;
begin
  LComparisons := Copy(FComparisons);
  if LComparisons <> nil then
    LComparisons[Length(LComparisons) - 1].Descending := True;
  Result := TComparerEx<T>.Create(LComparisons);
end;

function TComparerEx<T>.OrderBy(const AFunc: TComparerExFunc<T, Integer>): IComparerEx<T>;
begin
  Result := OrderByDefault<Integer>(AFunc);
end;

function TComparerEx<T>.OrderBy(const AFunc: TComparerExFunc<T, Double>): IComparerEx<T>;
begin
  Result := OrderByDefault<Double>(AFunc);
end;

function TComparerEx<T>.OrderBy(const AFunc: TComparerExFunc<T, Int64>): IComparerEx<T>;
begin
  Result := OrderByDefault<Int64>(AFunc);
end;

function TComparerEx<T>.OrderBy(const AFunc: TComparerExFunc<T, String>; ACaseSensitive: Boolean = False): IComparerEx<T>;
begin
  if ACaseSensitive then
    { Use standard comparer }
    Result := OrderByDefault<String>(AFunc)
  else
    Result := OrderByCustom(
      function (const L, R: T): Integer
      begin
        Result := CompareText(AFunc(L), AFunc(R));
      end);
end;

function TComparerEx<T>.OrderBy(const AFunc: TComparison<T>): IComparerEx<T>;
begin
  Result := OrderByCustom(AFunc);
end;

function TComparerEx<T>.OrderBy(const AFunc: TComparerExFunc<T, TDate>): IComparerEx<T>;
begin
  Result := OrderByCustom(
    function (const L, R: T): Integer
    begin
      Result := Trunc(AFunc(L)) - Trunc(AFunc(R));
    end);
end;

function TComparerEx<T>.OrderBy(const AFunc: TComparerExFunc<T, TDateTime>): IComparerEx<T>;
begin
  Result := OrderByDefault<TDateTime>(AFunc);
end;

function TComparerEx<T>.OrderByDefault<TResult>(AFunc: TComparerExFunc<T, TResult>; ADescending: Boolean): IComparerEx<T>;
var
  LCmp: IComparer<TResult>;
begin
  { Create default comparer }
  LCmp := TComparer<TResult>.Default;

  Result := OrderByCustom(
    function (const L, R: T): Integer
    begin
      Result := LCmp.Compare(AFunc(L), AFunc(R));
    end);
end;

function TComparerEx<T>.OrderByCustom(AFunc: TComparison<T>; ADescending: Boolean): IComparerEx<T>;
var
  LResult: TComparerEx<T>;
begin
  LResult := TComparerEx<T>.Create(FComparisons);
  try
    { Add the comparison for a specific data type }
    LResult.AddComparison(TComparerExNode<T>.Create(ADescending, AFunc));

    { Return new instance }
    Result := LResult;
  except
    LResult.Free;
    raise;
  end
end;

function TComparerEx<T>.OrderByDesc(const AFunc: TComparerExFunc<T, Double>): IComparerEx<T>;
begin
  Result := OrderByDefault<Double>(AFunc, True);
end;

function TComparerEx<T>.OrderByDesc(const AFunc: TComparerExFunc<T, Int64>): IComparerEx<T>;
begin
  Result := OrderByDefault<Int64>(AFunc, True);
end;

function TComparerEx<T>.OrderByDesc(const AFunc: TComparerExFunc<T, Integer>): IComparerEx<T>;
begin
  Result := OrderByDefault<Integer>(AFunc, True);
end;

function TComparerEx<T>.OrderByDesc(const AFunc: TComparerExFunc<T, TDateTime>): IComparerEx<T>;
begin
  Result := OrderByDefault<TDateTime>(AFunc, True);
end;

function TComparerEx<T>.OrderByDesc(const AFunc: TComparison<T>): IComparerEx<T>;
begin
  Result := OrderByCustom(AFunc, True);
end;

function TComparerEx<T>.OrderByDesc(const AFunc: TComparerExFunc<T, String>; ACaseSensitive: Boolean): IComparerEx<T>;
begin
  if ACaseSensitive then
    { Use standard comparer }
    Result := OrderByDefault<String>(AFunc, True)
  else
    Result := OrderByCustom(
      function (const L, R: T): Integer
      begin
        Result := CompareText(AFunc(L), AFunc(R));
      end, True);
end;

function TComparerEx<T>.OrderByDesc(const AFunc: TComparerExFunc<T, TDate>): IComparerEx<T>;
begin
  Result := OrderByCustom(
    function (const L, R: T): Integer
    begin
      Result := Trunc(AFunc(L)) - Trunc(AFunc(R));
    end, True);
end;

constructor TComparerExNode<T>.Create(ADescending: Boolean; const AComparison: TComparison<T>);
begin
  Descending := ADescending;
  Comparison := AComparison;
end;

end.
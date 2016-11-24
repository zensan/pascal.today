unit uInterfaces.NotImplemented;

interface

uses
  System.Rtti,
  Spring,
  Spring.Collections;

type
  /// <summary>
  ///   Class allows to list the interfaces which are not implemented by any class in your module.
  /// </summary>
  InterfacesNotImplemented = class
  private class var
    /// <summary>
    ///   Reference to the RTTI context.
    /// </summary>
    FCtx: TRttiContext;
  public
    /// <summary>
    ///   Function returns the list of unimplemented interfaces.
    /// </summary>
    /// <param name="AFilter">
    ///   A filter predicate for types to process.
    /// </param>
    class function List(AFilter: TPredicate<TRttiType> = nil): IList<TRttiInterfaceType>;

    class constructor Create;
    class destructor Destroy;
  end;

implementation

uses
  System.TypInfo;

{ InterfacesNotImplemented }

class constructor InterfacesNotImplemented.Create;
begin
  FCtx := TRttiContext.Create;
end;

class destructor InterfacesNotImplemented.Destroy;
begin
  FCtx.Free;
end;

class function InterfacesNotImplemented.List(AFilter: TPredicate<TRttiType> = nil): IList<TRttiInterfaceType>;
var
  LType, LIntf: TRttiType;
  LTypes: IMultiMap<TTypeKind, TRttiType>;
  LNoImpl: IList<TRttiInterfaceType>;
begin
  { Create the result instance }
  Result := TCollections.CreateList<TRttiInterfaceType>;

  { Get all the types }
  LTypes := TCollections.CreateMultiMap<TTypeKind, TRttiType>;

  { Build the multimap }
  for LType in FCtx.GetTypes do
    begin
      { Handle user filter }
      if Assigned(AFilter) and not AFilter(LType) then
        Continue;

      { Add only classes and interfaces }
      case LType.TypeKind of
        tkClass:
          LTypes.Add(LType.TypeKind, LType);
        tkInterface:
          { Skip interfaces which does not have GUID }
          if ifHasGuid in TRttiInterfaceType(LType).IntfFlags then
            LTypes.Add(LType.TypeKind, LType);
      end;
    end;

  { Create the list for the interfaces which are not implemented }
  LNoImpl := TCollections.CreateList<TRttiInterfaceType>;

  { For all types }
  if LTypes.ContainsKey(tkInterface) then
    for LIntf in LTypes[tkInterface] do
      if not LTypes.ContainsKey(tkClass) or not LTypes[tkClass].Any(
        function (const AType: TRttiType): Boolean
        var
          LImpl: TRttiInterfaceType;
        begin
          { Check if the class implements the interface }
          for LImpl in TRttiInstanceType(AType).GetImplementedInterfaces do
            if LImpl.QualifiedName = LIntf.QualifiedName then
              Exit(True);

          Result := False;
        end) then
        Result.Add(TRttiInterfaceType(LIntf));
end;

end.

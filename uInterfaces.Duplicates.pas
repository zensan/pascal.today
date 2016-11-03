unit uInterfaces.Duplicates;

interface

uses
  System.Rtti,
  Spring,
  Spring.Collections;

type
  /// <summary>
  ///   Class allows to list the interfaces which are not implemented by any class in your module.
  /// </summary>
  InterfacesWithDuplicateGUID = class
  private class var
    /// <summary>
    ///   Reference to the RTTI context.
    /// </summary>
    FCtx: TRttiContext;
  public
    /// <summary>
    ///   Function returns the list of interfaces with duplicate GUID.
    /// </summary>
    /// <param name="AFilter">
    ///   A filter predicate for types to process.
    /// </param>
    class function Map(AFilter: TPredicate<TRttiInterfaceType> = nil): IMultiMap<TGUID, TRttiInterfaceType>;

    class constructor Create;
    class destructor Destroy;
  end;

implementation

uses
  System.TypInfo;

{ InterfacesNotImplemented }

class constructor InterfacesWithDuplicateGUID.Create;
begin
  FCtx := TRttiContext.Create;
end;

class destructor InterfacesWithDuplicateGUID.Destroy;
begin
  FCtx.Free;
end;

class function InterfacesWithDuplicateGUID.Map(AFilter: TPredicate<TRttiInterfaceType> = nil): IMultiMap<TGUID, TRttiInterfaceType>;
var
  LType: TRttiType;
  LIntf: TRttiInterfaceType;
  LTypes: IList<TRttiInterfaceType>;
begin
  { Create the result instance }
  Result := TCollections.CreateMultiMap<TGUID, TRttiInterfaceType>;

  { Get all the types }
  LTypes := TCollections.CreateList<TRttiInterfaceType>;

  { Build the multimap }
  for LType in FCtx.GetTypes do
    { Add only classes and interfaces }
    if LType.TypeKind = tkInterface then
      { Skip interfaces which does not have GUID }
      if TRttiInterfaceType(LType).GUID <> TGUID.Empty then
        begin
          { Handle user filter }
          if Assigned(AFilter) then
            if not AFilter(TRttiInterfaceType(LType)) then
              Continue;

          LTypes.Add(TRttiInterfaceType(LType));
        end;

  { For all interaces }
  for LIntf in LTypes do
    if LTypes.Any(
      function (const AType: TRttiInterfaceType): Boolean
      begin
        Result := (AType.GUID = LIntf.GUID) and (LIntf.QualifiedName <> AType.QualifiedName);
      end) then
      Result.Add(LIntf.GUID, LIntf);
end;

end.

program TestProject;

{$APPTYPE CONSOLE}

{$HINTS OFF}

uses
  System.SysUtils,
  System.Rtti,
  uTest in 'uTest.pas',
  uInterfaces.Duplicates in '..\..\uInterfaces.Duplicates.pas';

var
  I: TRttiInterfaceType;
  { Just need to use the intfs so that they are compiled into }
  x1: TArray<ITest1>;
  x2: TArray<ITest2>;
begin
  for I in InterfacesWithDuplicateGUID.Map(
    function (const I: TRttiInterfaceType): Boolean
    begin
      Result := I.QualifiedName.StartsWith('u', True);
    end).Values do
    begin
      Writeln(I.QualifiedName);
      Writeln('  ', I.GUID.ToString);
    end;

  Readln;
end.

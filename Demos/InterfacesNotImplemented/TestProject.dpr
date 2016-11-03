program TestProject;

{$APPTYPE CONSOLE}

{$HINTS OFF}

uses
  System.SysUtils,
  System.Rtti,
  uTest in 'uTest.pas',
  uInterfaces.NotImplemented in '..\..\uInterfaces.NotImplemented.pas';

var
  I: TRttiInterfaceType;
  { Just need to use the intfs so that they are compiled into }
  x1: TArray<ITest1>;
  x2: TArray<ITest2>;
begin
  for I in InterfacesNotImplemented.List(
    function (const T: TRttiType): Boolean
    begin
      Result := T.QualifiedName.StartsWith('u', True);
    end) do
    begin
      Writeln(I.QualifiedName);
      Writeln('  ', I.GUID.ToString);
    end;

  Readln;
end.

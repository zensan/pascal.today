program ParameterTypes;

{$APPTYPE CONSOLE}

type
  ITest = interface
    ['{D200C91B-3D4D-45AB-A1E0-A803C6A03292}']
  end;

  TTest = class(TInterfacedObject, ITest)
  private
    function _AddRef: Integer; stdcall;
    function _Release: Integer; stdcall;
  end;

function TTest._AddRef: Integer;
begin
  Writeln(FRefCount + 1);
  Result := inherited;
end;

function TTest._Release: Integer;
begin
  Writeln(FRefCount - 1);
  Result := inherited;
end;

procedure TestStandard(X: ITest);
begin
  Writeln('Inside standard');
end;

procedure TestVar(var X: ITest);
begin
  Writeln('Inside var');
end;

procedure TestConst(const X: ITest);
begin
  Writeln('Inside const');
end;

procedure TestConstRef(const [Ref] X: ITest);
begin
  Writeln('Inside const');
end;

procedure TestOut(out X: ITest);
begin
  Writeln('Inside out');
end;

var
  X: ITest;

begin
  Writeln(StringOfChar('-', 40));
  Writeln('Creating and calling with standard parameter type:');
  X := TTest.Create;
  TestStandard(X);
  X := nil;
  Writeln(StringOfChar('-', 40));

  Writeln('Creating and calling with var parameter type:');
  X := TTest.Create;
  TestVar(X);
  X := nil;
  Writeln(StringOfChar('-', 40));

  Writeln('Creating and calling with const parameter type:');
  X := TTest.Create;
  TestConst(X);
  X := nil;
  Writeln(StringOfChar('-', 40));

  Writeln('Creating and calling with const [Ref] parameter type:');
  X := TTest.Create;
  TestConstRef(X);
  X := nil;
  Writeln(StringOfChar('-', 40));

  Writeln('Creating and calling with out parameter type:');
  X := TTest.Create;
  TestOut(X);
  X := nil;
  Writeln(StringOfChar('-', 40));

  Readln;
end.

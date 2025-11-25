program ternary;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  System.Math,
  System.Classes;

procedure WriteSeparator(const Title: string);
begin
  Writeln;
  Writeln('=' + StringOfChar('=', 70));
  Writeln('  ', Title);
  Writeln('=' + StringOfChar('=', 70));
end;

procedure Demo1_BasicUsage;
begin
  WriteSeparator('Demo 1: Basic Usage - Simple Assignment');
  Writeln('Comparing traditional if statement vs ternary operator');
  Writeln;

  var Value := 75;
  Writeln('Value = ', Value);

  var Result: Integer;

  // Traditional if statement
  if Value < 100 then
    Result := 22
  else
    Result := 45;

  Writeln('Traditional if: Result = ', Result);

  // Ternary conditional operator
  Result := if Value < 100 then 22 else 45;

  Writeln('Ternary operator: Result = ', Result);
  Writeln;
  Writeln('Note: Same behaviour but code less verbose');
end;

procedure Demo2_StringExpressions;
begin
  WriteSeparator('Demo 2: String Expressions - Used in Function Calls');
  Writeln('Ternary operator can be used directly in expressions');
  Writeln;

  var Left := 75;
  // Ternary conditional operator
  var Message := if Left < 100 then 'Small' else 'Big';

  Writeln('Left = ', Left, ', Message = "', Message, '"');

  Left := 150;
  // Ternary conditional operator
  Message := if Left < 100 then 'Small' else 'Big';

  Writeln('Left = ', Left, ', Message = "', Message, '"');

  Writeln;
  Writeln('Note: This can be used directly in function calls:');
  Writeln('  ShowMessage(if Left < 100 then ''Small'' else ''Big'')');
end;

procedure Demo3_OperatorPrecedence;
begin
  WriteSeparator('Demo 3: Operator Precedence - Parentheses Matter');
  Writeln('Demonstrating how operator precedence affects ternary expressions');
  Writeln;

  var Left := 75;

  // Without parentheses + has higher priority
  var Result := if Left < 100 then 'Small' else 'Large' + ' Size';

  Writeln('Without parentheses: "', Result, '"');
  Writeln('  (The + operator has higher priority)');

  // With parentheses - ternary evaluated first
  Result := (if Left < 100 then 'Small' else 'Large') + ' Size';

  Writeln('With parentheses: "', Result, '"');
  Writeln('  (Ternary evaluated first, then concatenation)');
end;

procedure Demo4_ShortCircuitEvaluation;
var
  CallCount: Integer;

  function ExpensiveFunction: Integer;
  begin
    Inc(CallCount);
    Result := 999;
    Writeln('  ExpensiveFunction executed!');
  end;

begin
  WriteSeparator('Demo 4: Short-Circuit Evaluation - Key Difference from ifThen');
  Writeln('Ternary operator only evaluates the selected branch');
  Writeln('ifThen evaluates BOTH branches before selecting');
  Writeln;

  var Value := 50;
  CallCount := 0;
  Writeln('Value = ', Value, ' (less than 100)');
  Writeln('Using ternary operator:');

  // Ternary conditional operator
  var Result := if Value < 100 then 22 else ExpensiveFunction;

  Writeln('Result = ', Result, ', ExpensiveFunction called ', CallCount, ' time(s)');
  Writeln;

  Writeln('Using ifThen (from System.Math):');
  CallCount := 0;

  // Old ifThen helper
  Result := ifThen(Value < 100, 22, ExpensiveFunction);

  Writeln('Result = ', Result, ', ExpensiveFunction called ', CallCount, ' time(s)');
  Writeln('  Notice: ifThen called ExpensiveFunction even though condition was truthy');
  Writeln;

  Writeln('Key Takeaway:');
  Writeln('  - Ternary operator: Only evaluates the selected branch (short-circuit)');
  Writeln('  - ifThen: Always evaluates BOTH branches before selecting');
end;

procedure Demo5_AnyTypeReturn;
type
  TIntFunc = reference to function: Integer;
  TPoint = record
    X, Y: Integer;
  end;
begin
  WriteSeparator('Demo 5: Returning Any Type');
  Writeln('Ternary operator can return ANY Delphi type: objects, records,');
  Writeln('anonymous methods, interfaces, and more!');
  Writeln;
  Writeln('ifThen limitation: Only works with strings and numbers');
  Writeln;

  // Example 1: Anonymous Methods
  Writeln('Example 1: Anonymous Methods');
  var FastFunc: TIntFunc := function: Integer
  begin
    Result := 10;
  end;

  var SlowFunc: TIntFunc := function: Integer
  begin
    Result := 1000;
  end;

  var UseFast := True;
  var SelectedFunc := if UseFast then FastFunc else SlowFunc;
  Writeln('  Selected function result: ', SelectedFunc());
  Writeln;

  // Example 2: Records
  Writeln('Example 2: Records');
  var Point1: TPoint;
  Point1.X := 10; Point1.Y := 20;
  var Point2: TPoint;
  Point2.X := 100; Point2.Y := 200;
  var UseFirst := True;
  var SelectedPoint := if UseFirst then Point1 else Point2;

  Writeln('  Selected point: (', SelectedPoint.X, ', ', SelectedPoint.Y, ')');
  Writeln;

  // Example 3: Objects
  Writeln('Example 3: Objects');
  var List1 := TStringList.Create;
  var List2 := TStringList.Create;
  try
    List1.Add('First List');
    List2.Add('Second List');
    List2.Add('Item B');

    UseFirst := True;
    var SelectedList := if UseFirst then List1 else List2;

    Writeln('  Selected list has ', SelectedList.Count, ' item(s)');
    Writeln('  First item: "', SelectedList[0], '"');

    UseFirst := False;
    SelectedList := if UseFirst then List1 else List2;

    Writeln('  Selected list has ', SelectedList.Count, ' item(s)');
    Writeln('  First item: "', SelectedList[0], '"');
  finally
    List1.Free;
    List2.Free;
  end;
  Writeln;

  Writeln('Key Takeaway:');
  Writeln('  - Ternary operator: Works with ANY compatible type');
  Writeln('  - ifThen: Limited to strings and numeric types only');
  Writeln('  - This unlocks powerful patterns: strategy selection,');
  Writeln('    factory methods, conditional object creation, etc.');
end;

procedure Demo6_TypeCompatibility;
begin
  WriteSeparator('Demo 6: Type Compatibility Rules');
  Writeln('Both branches must be compatible types');
  Writeln;

  var Value := 50;

  // Compatible: both strings
  var Result := if Value < 100 then 'Small' else 'Large';

  Writeln('Compatible types (both strings): "', Result, '"');

  Writeln;
  Writeln('Incompatible example (would cause compiler error):');
  Writeln('  Result := if Value < 100 then ''Small'' else 123;');
  Writeln('  Error: E2010 Incompatible types: ''string'' and ''Integer''');
end;

procedure Demo7_NestedTernary;

  function GetGrade(Score: Integer): string;
  begin
    Result := if Score >= 90 then 'A'
              else if Score >= 80 then 'B'
              else if Score >= 70 then 'C'
              else if Score >= 60 then 'D'
              else 'F';
  end;

begin
  WriteSeparator('Demo 7: Nested Ternary Operators');
  Writeln('Ternary operators can be nested for multiple conditions');
  Writeln;

  var Score := 95;
  var Grade := GetGrade(Score);
  Writeln('Score = ', Score, ', Grade = "', Grade, '"');

  Score := 75;
  Grade := GetGrade(Score);
  Writeln('Score = ', Score, ', Grade = "', Grade, '"');

  Score := 45;
  Grade := GetGrade(Score);
  Writeln('Score = ', Score, ', Grade = "', Grade, '"');
end;

procedure Demo8_RealWorldExample;
begin
  WriteSeparator('Demo 8: Real-World Example - Price Calculation');
  Writeln('Using ternary operator in a practical calculation');
  Writeln;

  var UserAge := 25;
  var Price := 100.0;

  var Discount := if UserAge < 18 then 0.10        // 10% student discount
                  else if UserAge >= 65 then 0.15  // 15% senior discount
                  else 0.0;                        // No discount

  var FinalPrice := Price * (1.0 - Discount);

  Writeln('User Age: ', UserAge);
  Writeln('Base Price: $', FormatFloat('0.00', Price));
  Writeln('Discount: ', FormatFloat('0.0%', Discount * 100));
  Writeln('Final Price: $', FormatFloat('0.00', FinalPrice));
  Writeln;

  UserAge := 70;
  Discount := if UserAge < 18 then 0.10
              else if UserAge >= 65 then 0.15
              else 0.0;
  FinalPrice := Price * (1.0 - Discount);

  Writeln('User Age: ', UserAge);
  Writeln('Base Price: $', FormatFloat('0.00', Price));
  Writeln('Discount: ', FormatFloat('0.0%', Discount * 100));
  Writeln('Final Price: $', FormatFloat('0.00', FinalPrice));
end;

begin
  try
    Writeln('Delphi Ternary Operator (if-then-else expression) Demonstration');
    Writeln('================================================================');
    Writeln;
    Writeln('This demo showcases the new ternary operator introduced in Delphi.');
    Writeln('Key advantages over ifThen:');
    Writeln('  - Short-circuit evaluation (only evaluates selected branch)');
    Writeln('  - Can be used in any expression context');
    Writeln('  - Can return anonymous methods and other complex types');
    Writeln('  - More Pascal-like syntax');

    Demo1_BasicUsage;
    Demo2_StringExpressions;
    Demo3_OperatorPrecedence;
    Demo4_ShortCircuitEvaluation;
    Demo5_AnyTypeReturn;
    Demo6_TypeCompatibility;
    Demo7_NestedTernary;
    Demo8_RealWorldExample;

    WriteSeparator('Demo Complete');
    Writeln('Press Enter to exit...');
    Readln;
  except
    on E: Exception do
      Writeln(E.ClassName, ': ', E.Message);
  end;
end.

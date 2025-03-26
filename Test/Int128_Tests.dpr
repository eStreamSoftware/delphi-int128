program Int128_Tests;

uses
  TestInsight.DUnit,
  Int128d in '..\Int128d.pas',
  Int128d.TestCase in 'Int128d.TestCase.pas';

{$R *.RES}

begin
  RunRegisteredTests;
end.

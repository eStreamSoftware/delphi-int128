program Int128_Tests;
{
  Delphi DUnit Test Project
  -------------------------
  This project contains the DUnit test framework and the GUI/Console test runners.
  Add "CONSOLE_TESTRUNNER" to the conditional defines entry in the project options
  to use the console test runner.  Otherwise the GUI test runner will be used by
  default.
}
{$IFDEF CONSOLE_TESTRUNNER}
{$APPTYPE CONSOLE}
{$ENDIF}
uses
  DUnitTestRunner,
  int128impl in '..\int128impl.pas',
  int128Impl.TestCase in 'int128Impl.TestCase.pas';

{$R *.RES}
begin
  DUnitTestRunner.RunRegisteredTests;
end.

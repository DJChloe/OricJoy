program OricJoy;

uses
  Forms,
  Main in 'Main.pas' {f_main},
  UnitSystem in 'UnitSystem.pas',
  Vcl.Themes,
  Vcl.Styles,
  Unitkeyb in 'Unitkeyb.pas';

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Ruby Graphite');
  Application.CreateForm(Tf_main, f_main);
  Application.Run;
end.

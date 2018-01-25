program moontool;

uses
  gnugettext in 'gnugettext.pas',
  Forms,
  mtmain in 'mtmain.pas' {MainForm},
  mtabout in 'mtabout.pas' {AboutForm},
  mtConst,
  mtUtils,
  mtStrings,
  mtutcform in 'mtutcform.pas' {frmUTC},
  mtjewishform in 'mtjewishform.pas' {frmJewish},
  mtjulianform in 'mtjulianform.pas' {frmJulian},
  mtlocation in 'mtlocation.pas' {frmLocations},
  mtmoredataform in 'mtmoredataform.pas' {frmMoreData};

{$ifdef fpc}
  {$R *.res}
{$else}
  {$R moontool.r32}
{$endif}

begin
  // Add extra domain for runtime library translations
  AddDomainForResourceString('default');
  // Force program to use
  UseLanguage('en');

  Application.Initialize;
  Application.HelpFile := '';
  Application.CreateForm(TMainForm, MainForm);
  Application.CreateForm(TfrmUTC, frmUTC);
  Application.CreateForm(TfrmJewish, frmJewish);
  Application.CreateForm(TfrmJulian, frmJulian);
  Application.CreateForm(TfrmLocations, frmLocations);
  Application.CreateForm(TfrmMoreData, frmMoreData);
  Application.Run;
end.

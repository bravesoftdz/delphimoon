unit mtJewishForm;

interface

uses
{$ifdef fpc}
  LCLIntf, LCLType,
{$else}
  Windows, Messages, Consts,
{$endif}
  SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, moon;

type

  { TfrmJewish }

  TfrmJewish = class(TForm)
    grpGregorian: TGroupBox;
      lblYear: TLabel;
      lblMonth: TLabel;
      lblDay: TLabel;
      edtYear: TEdit;
      cbxMonth: TComboBox;
      edtDay: TEdit;
    grpJulian: TGroupBox;
      lblJulian: TLabel;
    grpJewish: TGroupBox;
      lblYearJewish: TLabel;
      lblMonthJewish: TLabel;
      lblDayJewish: TLabel;
      edtYearJewish: TEdit;
      cbxMonthJewish: TComboBox;
      edtDayJewish: TEdit;
    btnNow: TButton;
    btnOK: TButton;
    btnCancel: TButton;
    procedure btnNowClick(Sender: TObject);
    procedure ChristianChange(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure JewishChange(Sender: TObject);
  private
    FDate: TDateTime;
    FChanging: Integer;
    procedure SetDate(AValue: TDateTime);
    procedure UpdateLayout;
    procedure UpdateStrings;
    procedure UpdateValues;
  public
    property Date: TDateTime read FDate write SetDate;
  end;

var
  frmJewish: TfrmJewish;


implementation

uses
  mtStrings, mtConst, mtUtils;

{$ifdef fpc}
 {$R *.lfm}
{$else}
 {$R *.dfm}
{$endif}

procedure TfrmJewish.btnNowClick(Sender: TObject);
begin
  SetDate(Now());
end;

procedure TfrmJewish.ChristianChange(Sender: TObject);
var
  d, y: Integer;
begin
  if FChanging > 0 then
    exit;

  if TryStrToInt(edtYear.Text, y) and
     TryStrToInt(edtDay.Text, d) and
     TryEncodeDate(y, cbxMonth.ItemIndex+1, d, FDate) then
  begin
    UpdateValues;
    btnOK.Enabled := true;
  end else begin
    lblJulian.Caption := SInvalid;
    btnOK.Enabled := false;
  end;
end;

procedure TfrmJewish.FormCreate(Sender: TObject);
begin
  cbxMonth.DropdownCount := DROPDOWN_COUNT;
  cbxMonthJewish.DropdownCount := DROPDOWN_COUNT;
  HelpContext := HC_SET_JEWISH;
end;

procedure TfrmJewish.FormShow(Sender: TObject);
var
  L, T: Integer;
begin
  UpdateStrings;
  UpdateValues;
  L := Application.MainForm.Left + (Application.MainForm.Width - Width) div 2;
  T := Application.MainForm.Top + (Application.MainForm.Height - Height) div 2;
  SetBounds(L, T, Width, Height);
end;

procedure TfrmJewish.JewishChange(Sender: TObject);
var
  d, y: Integer;
  valid: Boolean;
begin
  if FChanging > 0 then
    exit;

  valid := false;
  if TryStrToInt(edtYearJewish.Text, y) and
     TryStrToInt(edtDayJewish.Text, d) then
  begin
    try
      FDate := EncodeDateJewish(y, cbxMonthJewish.itemindex+1, d);
      UpdateValues;
      valid := true;
    except
    end;
  end;
  btnOK.Enabled := valid;
  if not valid then lblJulian.Caption := SInvalid;
end;

procedure TfrmJewish.SetDate(AValue: TDateTime);
begin
  FDate := AValue;
  UpdateValues;
end;

procedure TfrmJewish.UpdateLayout;
begin
  CenterAboveControl(lblYear, edtYear);
  CenterAboveControl(lblMonth, cbxMonth);
  CenterAboveControl(lblDay, edtDay);

  CenterAboveControl(lblYearJewish, edtYearJewish);
  CenterAboveControl(lblMonthJewish, cbxMonthJewish);
  CenterAboveControl(lblDayJewish, edtDayJewish);
end;

procedure TfrmJewish.UpdateStrings;
var
  i: integer;
begin
  Caption := SJewishDate;
  grpJulian.Caption := SJulianDate;
  grpGregorian.Caption := SChristianDate;
  grpJewish.Caption := SJewishDate;
  btnNow.Caption := SNow;
  btnOK.Caption := SOKButton;
  btnCancel.Caption := SCancelButton;
  lblYear.Caption := SYear;
  lblMonth.Caption := SMonth;
  lblDay.Caption := SDay;
  lblYearJewish.Caption := SYear;
  lblMonthJewish.Caption := SMonth;
  lblDayJewish.Caption := SDay;

  cbxMonth.Items.Clear;
  for i:=1 to 12 do
    cbxMonth.Items.Add(LocalFormatSettings.LongMonthNames[i]);

  cbxMonthJewish.Items.Clear;
  for i:=1 to 13 do
    cbxMonthJewish.Items.Add(Jewish_Month_Name[i]);

  UpdateLayout;
end;

procedure TfrmJewish.UpdateValues;
var
  y, m, d: word;
begin
  inc(FChanging);
  try
    DecodeDateCorrect(FDate, y, m, d);
    edtYear.Text := IntToStr(y);
    cbxMonth.ItemIndex := m - 1;
    edtDay.Text := IntToStr(d);
    DecodeDateJewish(date, y, m, d);
    edtYearJewish.Text := IntToStr(y);
    cbxMonthJewish.ItemIndex := m - 1;
    edtDayJewish.Text := IntToStr(d);
    lblJulian.Caption := FloatToStrF(Julian_date(int(FDate)), ffFixed, 12, 5);
  finally
    dec(FChanging);
  end;
end;

end.


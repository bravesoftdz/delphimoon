unit mtUtils;

{$ifdef fpc}
 {$mode delphi}
{$endif}

interface

uses
  Classes, SysUtils, Moon;

function DateToString(ADateTime: TDateTime): string;
function UTCDateString(ADateTime: TDateTime): string;

function DegreeToString(ADeg: extended): string;
function RektaszensionToString(AValue: extended): string;

function TimeZoneBias: Integer;

procedure GetFormatSettingsFromLangCode(ALang: String; var AFormatSettings: TFormatSettings);
function GetOSLanguage: String;

function GetZodiacName(AZodiac: TZodiac): String;


implementation

uses
{$ifdef fpc}
  LazUTF8,
{$else}
  Windows,
{$endif}
  mtConst, mtStrings;

function DateToString(ADateTime: TDateTime): string;
begin
  ADateTime := FalsifyTDateTime(ADateTime);
  Result := FormatDateTime('hh:nn:ss d mmmm yyyy', ADateTime);
end;

function UTCDateString(ADateTime: TDateTime): string;
var
  dt: TDateTime;
begin
  dt := FalsifyTDateTime(ADateTime);
  Result := Format('%s UTC %s', [
    FormatDateTime('hh:nn', dt),
    FormatDateTime('d mmmm yyyy', dt)
  ]);
end;

function DegreeToString(ADeg: extended): string;
var
  d,m,s: integer;
begin
  if ADeg < 0 then
    Result := '-'
  else
    Result := '';
  ADeg := round(abs(ADeg)*3600);
  s := round(ADeg) mod 60;
  m := round((ADeg - s) / 60) mod 60;
  d := round((ADeg - s - m*60) / 3600);
  Result := Result + Format('%d%s %d'' %d"', [d, DEG_SYMBOL, m, s]);
end;

function RektaszensionToString(AValue: extended): string;
var
  h, m, s: integer;
begin
  if AValue < 0 then
    AValue := AValue + 360;
  AValue := round(abs(AValue) * 3600 / 15);
  s := round(AValue) mod 60;
  m := round((AValue - s)/60) mod 60;
  h := round((AValue - s - m*60) / 3600);
  Result := Format('%dh %dm %ds', [h, m, s]);
end;

function TimeZoneBias: Integer;
{$ifdef fpc}
begin
  Result := GetLocalTimeOffset;
end;
{$else}
var
  tz_info: TTimeZoneInformation;
begin
  case GetTimeZoneInformation(tz_info) of
    1: Result := tz_info.StandardBias+tz_info.Bias;
    2: Result := tz_info.DaylightBias+tz_info.Bias;
    else Result := 0;
  end;
end;
{$endif}

{platform-independent method to read the language of the user interface}
function GetOSLanguage: String;
{$ifdef fpc}
var
  l, fbl: string;
begin
  LazGetLanguageIDs(l, fbl);
  Result := fbl;
end;
{$else}
var
  Buffer: PChar;
  size : integer;
begin
  size := GetLocaleInfo (LOCALE_USER_DEFAULT, LOCALE_SISO639LANGNAME, nil, 0);
  GetMem(Buffer, size * SizeOf(char));
  try
    GetLocaleInfo (LOCALE_USER_DEFAULT, LOCALE_SISO639LANGNAME, Buffer, Size);
    Result := StrPas(Buffer);
  finally
    FreeMem(Buffer);
  end;
end;
{$endif}

{$ifdef fpc}
{$ifdef Windows}
{ This function determines the LCID from the language code.
  Works only for Windows. }
function GetLCIDFromLangCode(ALang: String): Integer;
var
  l: String;
begin
  l := lowercase(ALang);
  if l = 'ar' then Result := $0401 else    // Arabic
  if l = 'bg' then Result := $0403 else    // Bulgarian
  if l = 'ca' then Result := $0403 else    // Catalan
  if l = 'cs' then Result := $0405 else    // Czech
  if l = 'de' then Result := $0407 else    // German
  if l = 'en' then Result := $0409 else    // English  (US)
  if l = 'es' then Result := $040A else    // Spanisch
  if l = 'fi' then Result := $040B else    // Finnish
  if l = 'fr' then Result := $040C else    // French
  if l = 'he' then Result := $040D else    // Hebrew
  if l = 'hu' then Result := $040E else    // Hungarian
  if l = 'it' then Result := $0410 else    // Italian
  if l = 'jp' then Result := $0411 else    // Japanese
  if l = 'pl' then Result := $0415 else    // Polish
  if l = 'pt' then Result := $0816 else    // Portuguese (Portugal)
  if (l = 'pt_br') or (l = 'pt-br') then Result := $0416 else    // Portuguese (Brazil)
  if l = 'ru' then Result := $0419 else    // Russian
  if l = 'tr' then Result := $041F else    // Turkish
  if l = 'uk' then Result := $0422 else    // Ukrainian
  if l = 'lt' then Result := $0427 else    // Lithuanian
  if (l = 'zh_cn') or (l = 'zh-cn') then Result := $0804 else  // Chinese (China)
  if (l = 'zh_tw') or (l = 'zh-tw') then Result := $0404 else  // Chinese (Taiwan)
     // More language codes and LCIDs can be found at
     // http://www.science.co.il/Language/Locale-codes.asp
     raise Exception.CreateFmt('Language "%s" not supported. Please add to GetLCIDFromLangCode.',[ALang]);
end;
{$endif}
{$endif}

procedure GetFormatSettingsFromLangCode(ALang: String;
  var AFormatSettings: TFormatSettings);
begin
  {$ifdef windows}
  GetLocaleFormatSettings(GetLCIDFromLangCode(ALang),AFormatSettings);
  {$else}
  AFormatSettings := FormatSettings;
  {$endif}
end;


function GetZodiacName(AZodiac: TZodiac): String;
begin
  case AZodiac of
    z_aries       : Result := SAries;
    z_taurus      : Result := STaurus;
    z_gemini      : Result := SGemini;
    z_cancer      : Result := SCancer;
    z_leo         : Result := SLeo;
    z_virgo       : Result := SVirgo;
    z_libra       : Result := SLibra;
    z_scorpio     : Result := SScorpio;
    z_sagittarius : Result := SSagittarius;
    z_capricorn   : Result := SCapricorn;
    z_aquarius    : Result := SAquarius;
    z_pisces      : Result := SPisces;
  end;
end;

end.

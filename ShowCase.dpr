{$APPTYPE CONSOLE}

uses
   SysUtils,
   Windows,
   DateUtils,
   ExeHeaders in 'ExeHeaders.pas';

function HModuleToString(hModule: HMODULE): String;
begin
   Result := Result + 'HMODULE: ' + SysUtils.IntToStr(hModule) + sLineBreak;
end;

function FormatEpoch(Timestamp: LongWord): String;
var
   DateTime: TDateTime;
begin
   DateTime := UnixToDateTime(Timestamp);
   Result := FormatDateTime('yyyy.mm.dd hh:nn:ss', DateTime);
end;

function ImageExportDirectoryToString(ImageExportDirectory: PImageExportDirectory; hModule: HMODULE): String;
var
   DLLName: PString;
begin
   Result := Result + 'Export Flags: ' + SysUtils.IntToStr(ImageExportDirectory.Characteristics) + sLineBreak;
   Result := Result + 'Time/Date Stamp: ' + FormatEpoch(ImageExportDirectory.TimeDateStamp) + sLineBreak;
   Result := Result + 'Major version: ' + SysUtils.IntToStr(ImageExportDirectory.MajorVersion) + sLineBreak;
   Result := Result + 'Minor version: ' + SysUtils.IntToStr(ImageExportDirectory.MinorVersion) + sLineBreak;

   DLLName := PString(hmodule + ImageExportDirectory.Name);
   Result := Result + 'Name: ' + PAnsiChar(DLLName) + sLineBreak;

   Result := Result + 'Ordinal Base: ' + SysUtils.IntToStr(ImageExportDirectory.Base) + sLineBreak;
   Result := Result + 'Address Table Entries: ' + SysUtils.IntToStr(ImageExportDirectory.NumberOfFunctions) + sLineBreak;
   Result := Result + 'Number of Name Pointers: ' + SysUtils.IntToStr(ImageExportDirectory.NumberOfNames) + sLineBreak;
end;

function DLLExportNamesToString(DLLExportNames: DString): String;
var
   i: Integer;
begin
   for i := 0 to Length(DLLExportNames) - 1 do begin
      Result := Result + DLLExportNames[i] + sLineBreak;
   end;
end;

var
   hDWMAPI: Windows.HMODULE;
   ImageExportDirectory: PImageExportDirectory;
begin

   hDWMAPI := LoadLibrary('dwmapi.dll');
   ImageExportDirectory := GetPImageExportDirectory(hDWMAPI);

   Writeln(HModuleToString(hDWMAPI));
   Writeln(ImageExportDirectoryToString(ImageExportDirectory, hDWMAPI));

   Writeln(DLLExportNamesToString(GetDLLExportNames(hDWMAPI)));

   Readln;
end.
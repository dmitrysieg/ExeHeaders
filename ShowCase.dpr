{$APPTYPE CONSOLE}

uses
   SysUtils,
   Windows,
   DateUtils,
   ExeHeaders in 'ExeHeaders.pas';

function HModuleToString(hModule: HMODULE): String;
begin
   Result := Result + 'HMODULE: ' + SysUtils.IntToStr(hModule) + #10 + #13;
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
   Result := Result + 'Export Flags: ' + SysUtils.IntToStr(ImageExportDirectory.Characteristics) + #10 + #13;
   Result := Result + 'Time/Date Stamp: ' + FormatEpoch(ImageExportDirectory.TimeDateStamp) + #10 + #13;
   Result := Result + 'Major version: ' + SysUtils.IntToStr(ImageExportDirectory.MajorVersion) + #10 + #13;
   Result := Result + 'Minor version: ' + SysUtils.IntToStr(ImageExportDirectory.MinorVersion) + #10 + #13;

   DLLName := PString(hmodule + ImageExportDirectory.Name);
   Result := Result + 'Name: ' + PAnsiChar(DLLName) + #10 + #13;

   Result := Result + 'Ordinal Base: ' + SysUtils.IntToStr(ImageExportDirectory.Base) + #10 + #13;
   Result := Result + 'Address Table Entries: ' + SysUtils.IntToStr(ImageExportDirectory.NumberOfFunctions) + #10 + #13;
   Result := Result + 'Number of Name Pointers: ' + SysUtils.IntToStr(ImageExportDirectory.NumberOfNames) + #10 + #13;
end;

function DLLExportNamesToString(DLLExportNames: DString): String;
var
   i: Integer;
begin
   for i := 0 to Length(DLLExportNames) - 1 do begin
      Result := Result + DLLExportNames[i] + #10 + #13;
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
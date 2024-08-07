unit ExeHeaders;

{  ***

   Written by dmitrysieg in 2022.
   While working on Bube project, for research & debug purposes.

   Windows module already contains a part of functionality for working with .exe headers.

   See in Windows.pas:
      PImageDosHeader
      PImageFileHeader
      PImageExportDirectory
      and further...
   ***
}

{******************************************************************************}
interface
{******************************************************************************}

uses
   Windows;

type
   DString = array of String;

function GetDLLExportNames(hModule: HMODULE): DString;
function GetPImageExportDirectory(hModule: HMODULE): PImageExportDirectory;

{******************************************************************************}
implementation
{******************************************************************************}

{
   Get PImageExportDirectory from loaded module (e.g. DLL loaded by LoadLibrary).
   Return PImageExportDirectory structure.
}
function GetPImageExportDirectory(hModule: HMODULE): PImageExportDirectory;
var
   nt: PImageNTHeaders;
begin
   nt := PImageNTHeaders(hmodule + PImageDosHeader(hmodule)^._lfanew);
   GetPImageExportDirectory := PImageExportDirectory(hmodule + nt.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress);
end;

{
   Get DLL export names from loaded module (e.g. DLL loaded by LoadLibrary).
   Return array of DLL export names strings.
}
function GetDLLExportNames(hModule: HMODULE): DString;
var
   IED: PImageExportDirectory;
   i: Integer;
begin
   IED := GetPImageExportDirectory(hModule);

   SetLength(result, IED.NumberOfNames);
   for i := 0 to IED.NumberOfNames - 1 do begin
      Result[i] := PChar(
         hModule + DWORD(pointer(hModule + DWORD(IED.AddressOfNames) + i * 4)^)
      );
   end;
end;

end.
 
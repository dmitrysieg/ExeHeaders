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
   nt := PImageNTHeaders(pointer(hmodule + PImageDosHeader(pointer(hmodule))^._lfanew));
   GetPImageExportDirectory := PImageExportDirectory(pointer(hmodule + nt.OptionalHeader.DataDirectory[IMAGE_DIRECTORY_ENTRY_EXPORT].VirtualAddress));
end;

{
   Get DLL export names from loaded module (e.g. DLL loaded by LoadLibrary).
   Return array of DLL export names strings.
}
function GetDLLExportNames(hModule: HMODULE): DString;
var
   exp: PImageExportDirectory;
   addressOfNames: Pointer;
   numberOfNames, i: Integer;
begin
   exp := GetPImageExportDirectory(hModule);
   numberOfNames := exp.NumberOfNames;
   addressOfNames := exp.AddressOfNames;

   setLength(result, numberOfNames);
   for i := 0 to numberOfNames - 1 do begin
      result[i] := PChar(
         hmodule + dword(pointer(hmodule + dword(addressofnames) + i * 4)^)
      );
   end;
end;

end.
 
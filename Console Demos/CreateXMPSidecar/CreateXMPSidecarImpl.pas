{**************************************************************************************************}
{                                                                                                  }
{ CCR Exif                                                                                         }
{ https://github.com/Wolfcast/ccr-exif                                                             }
{ Copyright (c) 2009-2014 Chris Rolliston. All Rights Reserved.                                    }
{                                                                                                  }
{ This file is part of CCR Exif which is released under the terms of the Mozilla Public License,   }
{ v. 2.0. See file LICENSE.txt or go to https://mozilla.org/MPL/2.0/ for full license details.     }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ XMP sidecar file creator console demo.                                                           }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Version:       1.5.4                                                                             }
{ Last modified: 2024-01-13                                                                        }
{ Contributors:  Chris Rolliston                                                                   }
{                                                                                                  }
{**************************************************************************************************}

unit CreateXMPSidecarImpl;
{
  The code here would normally be in the DPR. It is in a separate PAS so that we can have separate
  DPROJ files for different Delphi versions - unfortunately, there is a one-to-one correspondence
  between a DPR (for code) and a DPROJ (for version-specific settings).
}
interface

{$WARN SYMBOL_PLATFORM OFF}

{$IFDEF MSWINDOWS}
{$R WindowsXP.res}
{$ENDIF}

implementation

uses
  {$IFDEF MSWINDOWS}Windows,{$ENDIF} Types, SysUtils, Classes, WideStrUtils,
  CCR.Exif, CCR.Exif.BaseUtils, CCR.Exif.Consts, CCR.Exif.XMPUtils;

procedure OutputInfo;
var
  Stream: TResourceStream;
  Text: string;
begin
  Stream := TResourceStream.Create(HInstance, 'HelpText', RT_RCDATA);
  try
    Text := UTF8ToString(Stream.Memory, Stream.Size)
  finally
    Stream.Free;
  end;
  WriteLn(Format(Text, [ChangeFileExt(ExtractFileName(GetExecutableName), ''),
    CCRExifVersion]));
end;

procedure DoIt(const JpegFile: string);
var
  ExifData: TExifData;
  DestFile: string;
  XML: UTF8String;
  OutputStream: TFileStream;
begin
  OutputStream := nil;
  ExifData := TExifData.Create;
  try
    //create XMP data from the existing Exif tags
    ExifData.LoadFromGraphic(JpegFile);
    ExifData.XMPWritePolicy := xwAlwaysUpdate;
    ExifData.Rewrite;
    //determine the output file name
    DestFile := ParamStr(2);
    if DestFile = '' then
      DestFile := ChangeFileExt(JpegFile, '.xmp')
    else if DestFile[1] = '*' then
      DestFile := ChangeFileExt(JpegFile, '') + Copy(DestFile, 2, MaxInt);
    OutputStream := TFileStream.Create(DestFile, fmCreate);
    //write a BOM if a text file extension is being used
    if SameText(ExtractFileExt(DestFile), '.txt') then
      OutputStream.WriteBuffer(sUTF8BOMString, SizeOf(sUTF8BOMString));
    //write the XML
    XML := ExifData.XMPPacket.RawXML;
    OutputStream.WriteBuffer(XML[1], Length(XML));
  finally
    ExifData.Free;
    OutputStream.Free;
  end;
  Writeln('Created ', DestFile);
end;

var
  RetVal: Integer;
  FileSpec, Path: string;
  SearchRec: TSearchRec;
begin
  try
    {$IFDEF MSWINDOWS}
    if ParamCount = 0 then
    begin
      MessageBox(0, 'This is a console application that requires command-line ' +
        'arguments - use CreateXMPSidecar /? for further information.',
        'XMP Sidecar Creator v' + CCRExifVersion, MB_ICONINFORMATION);
      Exit;
    end;
    {$ENDIF}
    FileSpec := ParamStr(1);
    if (FileSpec = '') or (AnsiChar(FileSpec[1]) in SwitchChars + ['?']) then
    begin
      OutputInfo;
      Exit;
    end;
    Path := ExtractFilePath(FileSpec);
    if Path = '' then
    begin
      Path := IncludeTrailingPathDelimiter(GetCurrentDir);
      FileSpec := Path + FileSpec;
    end;
    RetVal := FindFirst(FileSpec, faReadOnly or faArchive, SearchRec);
    if RetVal <> 0 then
    begin
      WriteLn('No file matched to "' + ParamStr(1) + '"');
      Exit;
    end;
    repeat
      try
        DoIt(Path + SearchRec.Name);
      except
        on E:Exception do
        begin
          Writeln('Problem processing ', Path + SearchRec.Name, ' (', E.Classname, '):');
          Writeln(E.Message);
          Writeln('');
        end
        else
          raise;
      end;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  except
    on E: Exception do WriteLn(E.ClassName, ': ', E.Message);
  end;
  {$IFDEF MSWINDOWS}
  if DebugHook <> 0 then ReadLn;
  {$ENDIF}
end.

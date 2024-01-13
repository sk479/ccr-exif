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
{ Panasonic maker note patcher console demo.                                                       }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Version:       1.5.4                                                                             }
{ Last modified: 2024-01-13                                                                        }
{ Contributors:  Chris Rolliston                                                                   }
{                                                                                                  }
{**************************************************************************************************}

unit PanaMakerPatchImpl;
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
  {$IFDEF MSWINDOWS}Windows,{$ENDIF} Types, SysUtils, Classes,
  CCR.Exif, CCR.Exif.BaseUtils, CCR.Exif.Consts;

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

procedure OutputProcessingError(const JpegFile, Msg: string);
begin
  Writeln('Problem processing ', JpegFile, ':');
  Writeln(Msg);
  Writeln('');
end;

var
  PreserveFileDates: Boolean;
  TagIDs: array of TExifTagID;
  NewValue: string;

procedure DoIt(const JpegFile: string);
var
  ExifData: TExifDataPatcher;
  ID: TExifTagID;
  Tag: TExifTag;
begin
  ExifData := TExifDataPatcher.Create(JpegFile);
  try
    ExifData.PreserveFileDate := PreserveFileDates;
    if not (ExifData.MakerNote is TPanasonicMakerNote) then
    begin
      OutputProcessingError(JpegFile, 'Panasonic maker note data not found');
      Exit;
    end;
    for ID in TagIDs do
      if ExifData[esMakerNote].Find(ID, Tag) then
        Tag.AsString := NewValue
      else
        OutputProcessingError(JpegFile, Format('Tag $%.4x not found', [ID]));
    if ExifData.Modified then
    begin
      ExifData.UpdateFile;
      Writeln('Updated ', JpegFile);
    end;
  finally
    ExifData.Free;
  end;
end;

var
  I, RetVal: Integer;
  S: string;
  SearchRec: TSearchRec;
begin
  try
    if ParamCount < 3 then
    begin
      {$IFDEF MSWINDOWS}
      if ParamCount = 0 then
        MessageBox(0, 'This is a console application that requires command-line ' +
          'arguments - use PanaMakerPatch /? for further information.',
          'Panasonic Maker Note Patcher v' + CCRExifVersion, MB_ICONINFORMATION)
      else
      {$ENDIF}
        OutputInfo;
      Exit;
    end;
    S := ParamStr(2);
    with TStringList.Create do
    try
      CommaText := S;
      SetLength(TagIDs, Count);
      for I := 0 to Count - 1 do
        if TryStrToInt(Strings[I], RetVal) and (RetVal >= Low(TExifTagID)) and (RetVal <= High(TExifTagID)) then
          TagIDs[I] := RetVal
        else
        begin
          Writeln('Invalid TagID value (', S, ')');
          Exit;
        end;
    finally
      Free;
    end;
    S := ParamStr(1);
    RetVal := FindFirst(S, faReadOnly or faArchive, SearchRec);
    if RetVal <> 0 then
    begin
      Writeln('Invalid source file name (', S, '):');
      Writeln(SysErrorMessage(RetVal));
      Exit;
    end;
    NewValue := ParamStr(3);
    PreserveFileDates := FindCmdLineSwitch('p', True);
    S := ExtractFilePath(S);
    repeat
      try
        DoIt(S + SearchRec.Name);
      except
        on E: Exception do
          OutputProcessingError(S + SearchRec.Name, E.Message);
      end;
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  except
    on E: Exception do
      WriteLn(E.ClassName, ': ', E.Message);
  end;
  {$IFDEF MSWINDOWS}
  if DebugHook <> 0 then Readln;
  {$ENDIF}
end.

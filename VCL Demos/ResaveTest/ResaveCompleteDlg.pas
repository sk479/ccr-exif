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
{ TExifData/TJpegImageEx Exif and XMP save tester (VCL).                                           }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Version:       1.5.4                                                                             }
{ Last modified: 2024-01-13                                                                        }
{ Contributors:  Chris Rolliston                                                                   }
{                                                                                                  }
{**************************************************************************************************}

unit ResaveCompleteDlg;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls,
  CCR.Exif.Demos;

type
  TfrmOpenFile = class(TForm)
    btnClose: TButton;
    grpNewFile: TGroupBox;
    grpCompare: TGroupBox;
    btnCompareInExifList: TButton;
    btnCompareInJpegDump: TButton;
    btnCompareInXMPBrowser: TButton;
    btnOpenInDefaultApp: TButton;
    btnOpenInExplorer: TButton;
    btnDeleteFile: TButton;
    procedure FormCreate(Sender: TObject);
    procedure btnDeleteFileClick(Sender: TObject);
    procedure btnOpenInDefaultAppClick(Sender: TObject);
    procedure btnOpenInDemoClick(Sender: TObject);
    procedure btnOpenInExplorerClick(Sender: TObject);
  private
    FLastExecBtn: TButton;
    FSourceFile, FDestFile: string;
  public
    procedure ShowModal(const ASourceFile, ADestFile: string); reintroduce;
  end;

var
  frmOpenFile: TfrmOpenFile;

implementation

uses
  {$IF RTLVersion >= 23}System.UITypes,{$IFEND} Masks, ShellApi;

{$R *.dfm}

procedure TfrmOpenFile.ShowModal(const ASourceFile, ADestFile: string);
var
  CanCompare: Boolean;
  I: Integer;
begin
  FSourceFile := ASourceFile;
  FDestFile := ADestFile;
  grpNewFile.Caption := ' ' + ExtractFileName(ADestFile) + ' ';
  CanCompare := not SameFileName(ASourceFile, ADestFile);
  for I := grpCompare.ControlCount - 1 downto 0 do
    grpCompare.Controls[I].Enabled := CanCompare;
  if FLastExecBtn.Enabled then
    ActiveControl := FLastExecBtn
  else
    ActiveControl := btnOpenInDefaultApp;
  inherited ShowModal;
end;

procedure TfrmOpenFile.FormCreate(Sender: TObject);

  procedure CheckDir(const Path: string);
  var
    SearchRec: TSearchRec;
  begin                                                         {$WARN SYMBOL_PLATFORM OFF}
    if FindFirst(Path + '*.exe', faArchive, SearchRec) = 0 then {$WARN SYMBOL_PLATFORM ON}
    begin
      repeat
        if MatchesMask(SearchRec.Name, 'ExifList*.exe') then
          btnCompareInExifList.Hint := Path + SearchRec.Name
        else if MatchesMask(SearchRec.Name, 'JpegDump*.exe') then
          btnCompareInJpegDump.Hint := Path + SearchRec.Name
        else if MatchesMask(SearchRec.Name, 'XMPBrowser*.exe') then
          btnCompareInXMPBrowser.Hint := Path + SearchRec.Name
      until FindNext(SearchRec) <> 0;
      FindClose(SearchRec);
    end;
  end;
var
  BasePath: string;
  SearchRec: TSearchRec;
begin
  BasePath := ExtractFilePath(ExtractFileDir(ParamStr(0)));
  if FindFirst(BasePath + '*', faDirectory, SearchRec) = 0 then
  begin
    repeat
      if Pos('.', SearchRec.Name) = 0 then CheckDir(BasePath + SearchRec.Name + PathDelim);
    until FindNext(SearchRec) <> 0;
    FindClose(SearchRec);
  end;
  FLastExecBtn := btnCompareInExifList;
end;

procedure TfrmOpenFile.btnOpenInDefaultAppClick(Sender: TObject);
begin
  FLastExecBtn := (Sender as TButton);
  ShellExecute(Handle, nil, PChar(FDestFile), nil, nil, SW_SHOWNORMAL)
end;

procedure TfrmOpenFile.btnOpenInDemoClick(Sender: TObject);
var
  Path: string;
begin
  FLastExecBtn := (Sender as TButton);
  Path := FLastExecBtn.Hint;
  if (Path = '') or not FileExists(Path) then
    MessageDlg('Please compile the other demos first.', mtError, [mbOK], 0)
  else
    ShellExecute(Handle, nil, PChar(Path),
      PChar('"' + FSourceFile + '" "' + FDestFile + '"'), nil, SW_SHOWNORMAL)
end;

procedure TfrmOpenFile.btnOpenInExplorerClick(Sender: TObject);
begin
  FLastExecBtn := (Sender as TButton);
  SelectFileInExplorer(FDestFile);
end;

procedure TfrmOpenFile.btnDeleteFileClick(Sender: TObject);
const
  SConfirmDeletion = 'Are you sure you want to delete "%s"?';
begin
  if MessageDlg(Format(SConfirmDeletion, [FDestFile]), mtWarning, mbYesNo, 0) = mrYes then
  begin
    if not DeleteFile(FDestFile) then RaiseLastOSError;
    Close;
  end;
end;

end.

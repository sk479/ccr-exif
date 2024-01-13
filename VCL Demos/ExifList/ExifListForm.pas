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
{ Exif tag lister VCL demo.                                                                        }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Version:       1.5.4                                                                             }
{ Last modified: 2024-01-13                                                                        }
{ Contributors:  Chris Rolliston                                                                   }
{                                                                                                  }
{**************************************************************************************************}

unit ExifListForm;
{
  Demonstrates listing both standard and MakerNote tags - see ExifListFrame.pas for the important
  code. Note that the approach taken to the two tag types is different. In the standard tag case,
  how tags are interpreted is hardcoded at compile time. In the MakerNote case, in contrast, tag
  interpretation is done on the fly using an INI file (MakerNotes.ini), albeit with the intial
  detection of the basic MakerNote type being done by CCR.Exif.pas.
}
interface

uses
  Types, SysUtils, Classes, Graphics, IniFiles, Controls, Forms, ActnList, StdActns,
  ExtActns, StdCtrls, ExtCtrls, ComCtrls, Buttons, CCR.Exif.Demos, ExifListFrame,
  System.Actions;

type
  TfrmExifList = class(TForm)
    ActionList: TActionList;
    PageControl: TPageControl;
    tabOriginal: TTabSheet;
    tabResaved: TTabSheet;
    panBtns: TPanel;
    btnOpen: TBitBtn;
    btnExit: TBitBtn;
    btnCopy: TBitBtn;
    actCopy: TAction;
    actSelectAll: TAction;
    btnOpenInDefProg: TBitBtn;
    actOpenInDefProg: TFileRun;
    actOpen: TOpenPicture;
    procedure FormCreate(Sender: TObject);
    procedure btnExitClick(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure actCopyUpdate(Sender: TObject);
    procedure PageControlChange(Sender: TObject);
    procedure actCopyExecute(Sender: TObject);
    procedure actSelectAllExecute(Sender: TObject);
    procedure actOpenAccept(Sender: TObject);
  private
    FActiveFrame, FOriginalFrame, FResavedFrame: TOutputFrame;
    FMakerNoteValueMap: TMemIniFile;
    procedure ReloadMakerNoteValueMap;
  protected
    procedure DoFileOpen(const FileName1, FileName2: string); override;
  end;

var
  frmExifList: TfrmExifList;

implementation

uses CCR.Exif;

{$R *.dfm}

procedure TfrmExifList.FormCreate(Sender: TObject);
begin
  PageControl.Visible := TestMode;
  FMakerNoteValueMap := TMemIniFile.Create('');
  ReloadMakerNoteValueMap;
  FOriginalFrame := TOutputFrame.Create(Self);
  FOriginalFrame.Align := alClient;
  FOriginalFrame.Name := '';
  if not TestMode then
    FOriginalFrame.Parent := Self
  else
  begin
    actOpen.Enabled := False;
    actOpen.Visible := False;
    ActiveControl := PageControl;
    FOriginalFrame.Parent := tabOriginal;
    FResavedFrame := TOutputFrame.Create(Self);
    FResavedFrame.Align := alClient;
    FResavedFrame.Parent := tabResaved;
  end;
  FActiveFrame := FOriginalFrame;
  SupportOpeningFiles := True;
end;

procedure TfrmExifList.FormDestroy(Sender: TObject);
begin
  FMakerNoteValueMap.Free;
end;

procedure TfrmExifList.PageControlChange(Sender: TObject);
begin
  if PageControl.ActivePage = tabOriginal then
    FActiveFrame := FOriginalFrame
  else
    FActiveFrame := FResavedFrame;
end;

procedure TfrmExifList.actCopyExecute(Sender: TObject);
begin
  FActiveFrame.CopyToClipboard;
end;

procedure TfrmExifList.actCopyUpdate(Sender: TObject);
begin
  actCopy.Enabled := FActiveFrame.CanCopyToClipboard;
end;

procedure TfrmExifList.actOpenAccept(Sender: TObject);
begin
  OpenFile(actOpen.Dialog.FileName);
end;

procedure TfrmExifList.actSelectAllExecute(Sender: TObject);
begin
  FActiveFrame.SelectAll;
end;

procedure TfrmExifList.btnExitClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmExifList.DoFileOpen(const FileName1, FileName2: string);
begin
  actOpenInDefProg.Enabled := False; //in case of an exception on loading
  FOriginalFrame.LoadFromFile(FileName1, FMakerNoteValueMap);
  if FileName2 = '' then
  begin
    actOpenInDefProg.FileName := FileName1;
    actOpenInDefProg.Enabled := True;
    Exit;
  end;
  FResavedFrame.LoadFromFile(FileName2, FMakerNoteValueMap);
  tabOriginal.Caption := ExtractFileName(FileName1);
  tabResaved.Caption := ExtractFileName(FileName2);
end;

procedure TfrmExifList.ReloadMakerNoteValueMap;
var
  ResStream: TResourceStream;
  IniFileName: string;
begin
  IniFileName := ExtractFilePath(Application.ExeName) + 'MakerNotes.ini';
  if not FileExists(IniFileName) then
  try
    ResStream := TResourceStream.Create(HInstance, 'MakerNotes', RT_RCDATA);
    try
      ResStream.SaveToFile(IniFileName);
    finally
      ResStream.Free;
    end;
  except
    on EResNotFound do Exit;  //someone's been using ResHacker - grrr!!!
    on EFCreateError do Exit; //perhaps we're in Program Files?
  end;
  FMakerNoteValueMap.Rename(IniFileName, True);
end;

end.

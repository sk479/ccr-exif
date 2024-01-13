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
{ Exif creation FireMonkey demo (require Delphi XE3 to compile).                                   }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Version:       1.5.2 beta                                                                        }
{ Last modified: 2013-10-22                                                                        }
{ Contributors:  Chris Rolliston                                                                   }
{                                                                                                  }
{**************************************************************************************************}

unit ScreenshooterForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Edit, FMX.ListBox,
  CCR.Exif.FMXUtils;

type
  TfrmScreenshooter = class(TForm)
    lblAuthor: TLabel;
    edtAuthor: TEdit;
    edtTitle: TEdit;
    lblTitle: TLabel;
    edtSubject: TEdit;
    edtComments: TEdit;
    lblComments: TLabel;
    lblSubject: TLabel;
    edtKeywords: TEdit;
    lblKeywords: TLabel;
    lblRating: TLabel;
    cboRating: TComboBox;
    ListBoxItem1: TListBoxItem;
    ListBoxItem2: TListBoxItem;
    ListBoxItem3: TListBoxItem;
    ListBoxItem4: TListBoxItem;
    ListBoxItem5: TListBoxItem;
    ListBoxItem6: TListBoxItem;
    chkWriteThumbnail: TCheckBox;
    chkWriteXMP: TCheckBox;
    btnCreate: TButton;
    dlgSave: TSaveDialog;
    procedure FormCreate(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
  end;

var
  frmScreenshooter: TfrmScreenshooter;

implementation

{$R *.fmx}

uses CCR.Exif, CCR.Exif.Consts, ScreenshooterUtils;

procedure TfrmScreenshooter.FormCreate(Sender: TObject);
begin
  edtAuthor.Text := GetUserDisplayName;
  edtComments.Text := edtComments.Text + CCRExifVersion;
end;

procedure TfrmScreenshooter.btnCreateClick(Sender: TObject);
var
  ExifData: TExifData;
  Stream: TMemoryStream;
  TempBitmap: TBitmap;
begin
  Stream := TMemoryStream.Create;
  try
    Hide;
    Sleep(1000);
    Beep;
    TakeJpegScreenshot(Stream);
    Show;
    ExifData := TExifData.Create;
    try
      if chkWriteXMP.IsChecked then //default is to only update an XMP property if it already exists
        ExifData.XMPWritePolicy := xwAlwaysUpdate;
      ExifData.SetAllDateTimeValues(Now);
      ExifData.Author := edtAuthor.Text;
      ExifData.CameraMake := 'n/a';
      ExifData.CameraModel := 'n/a';
      ExifData.Comments := edtComments.Text;
      ExifData.Keywords := edtKeywords.Text;
      ExifData.Software := Application.Title;
      ExifData.Subject := edtSubject.Text;
      ExifData.Title := edtTitle.Text;
      ExifData.UserRating := TWindowsStarRating(cboRating.ItemIndex);
      if chkWriteThumbnail.IsChecked then
      begin
        Stream.Position := 0;
        TempBitmap := TBitmap.CreateFromStream(Stream);
        try
          ExifData.CreateThumbnail(TempBitmap);
        finally
          TempBitmap.Free;
        end;
      end;
      ExifData.SaveToGraphic(Stream);
    finally
      ExifData.Free;
    end;
    if not dlgSave.Execute then Exit;
    Stream.SaveToFile(dlgSave.FileName);
  finally
    Stream.Free;
  end;
  if MessageDlg('Created screenshot. Open it now?', TMsgDlgType.mtConfirmation, mbYesNo, 0) = mrYes then
    TFileManager.ShellExecute(dlgSave.FileName);
end;

end.

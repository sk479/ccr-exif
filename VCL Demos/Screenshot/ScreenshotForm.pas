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
{ Exif creation VCL demo.                                                                          }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Version:       1.5.4                                                                             }
{ Last modified: 2024-01-13                                                                        }
{ Contributors:  Chris Rolliston                                                                   }
{                                                                                                  }
{**************************************************************************************************}

unit ScreenshotForm;
{
  Demonstrates creating a JPEG image with Exif (and, optionally, XMP) metadata from scratch.
}
interface

uses
  Windows, SysUtils, Classes, Graphics, Controls, Forms, Dialogs, StdCtrls, Buttons,
  CCR.Exif.Demos;

type
  TfrmScreenshotDemo = class(TForm)
    lblAuthor: TLabel;
    lblComments: TLabel;
    lblTags: TLabel;
    edtAuthor: TEdit;
    edtComments: TEdit;
    edtKeywords: TEdit;
    chkThumbnail: TCheckBox;
    btnCreate: TButton;
    dlgSave: TSaveDialog;
    btnClose: TButton;
    lblRating: TLabel;
    cboRating: TComboBox;
    lblTitle: TLabel;
    edtTitle: TEdit;
    Label6: TLabel;
    edtSubject: TEdit;
    chkWriteXMP: TCheckBox;
    procedure FormCreate(Sender: TObject);
    procedure btnCloseClick(Sender: TObject);
    procedure btnCreateClick(Sender: TObject);
  end;

var
  frmScreenshotDemo: TfrmScreenshotDemo;

implementation

uses {$IF CompilerVersion >= 23}System.UITypes,{$IFEND} ShellApi, CCR.Exif, CCR.Exif.Consts;

{$R *.dfm}

resourcestring
  SCreatedScreenshot = 'Created screenshot and saved it to "%s".' + SLineBreak + SLineBreak +
    'Show file in Windows Explorer to verify the metadata has been correctly set?';

procedure TfrmScreenshotDemo.FormCreate(Sender: TObject);
var
  Buffer: array[Byte] of Char;
  Len: DWORD;
  S: string;
begin
  Len := Length(Buffer);
  if GetUserName(Buffer, Len) then
  begin
    SetString(S, Buffer, Len);
    edtAuthor.Text := S;
  end;
  edtComments.Text := edtComments.Text + CCRExifVersion;
end;

procedure TfrmScreenshotDemo.btnCloseClick(Sender: TObject);
begin
  Close;
end;

procedure TfrmScreenshotDemo.btnCreateClick(Sender: TObject);
var
  Bitmap: TBitmap;
  Jpeg: TJpegImageEx;
  SavedLeft: Integer;
  ScreenDC: HDC;
begin
  SavedLeft := Left;
  Jpeg := nil;
  Bitmap := TBitmap.Create;
  try
    { get the screen shot, moving ourselves out the way first }
    Bitmap.SetSize(Screen.Width, Screen.Height);
    Left := -Width * 2;
    ScreenDC := GetDC(0);
    BitBlt(Bitmap.Canvas.Handle, 0, 0, Bitmap.Width, Bitmap.Height, ScreenDC, 0, 0, SRCCOPY);
    ReleaseDC(0, ScreenDC);
    Left := SavedLeft;
    Update;
    { create the JPEG and set its metadata }
    Jpeg := TJpegImageEx.Create;
    Jpeg.Assign(Bitmap);
    if chkWriteXMP.Checked then //default is to only update an XMP property if it already exists
      Jpeg.ExifData.XMPWritePolicy := xwAlwaysUpdate;
    Jpeg.ExifData.SetAllDateTimeValues(Now);
    Jpeg.ExifData.Author := edtAuthor.Text;
    Jpeg.ExifData.CameraMake := 'n/a';
    Jpeg.ExifData.CameraModel := 'n/a';
    Jpeg.ExifData.Comments := edtComments.Text;
    Jpeg.ExifData.Keywords := edtKeywords.Text;
    Jpeg.ExifData.Software := Application.Title;
    Jpeg.ExifData.Subject := edtSubject.Text;
    Jpeg.ExifData.Title := edtTitle.Text;
    Jpeg.ExifData.UserRating := TWindowsStarRating(cboRating.ItemIndex);
    if chkThumbnail.Checked then
      Jpeg.CreateThumbnail;
    if not dlgSave.Execute then Exit;
    Jpeg.SaveToFile(dlgSave.FileName);
    if MessageDlg(Format(SCreatedScreenshot, [dlgSave.FileName]), mtInformation, mbYesNo, 0) = mrYes then
      SelectFileInExplorer(dlgSave.FileName);
  finally
    Left := SavedLeft;
    Bitmap.Free;
    Jpeg.Free;
  end;
end;

end.

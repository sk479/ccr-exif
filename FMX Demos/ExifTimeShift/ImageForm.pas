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
{ Exif time shifter FireMonkey demo (require Delphi XE3 to compile).                               }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Version:       1.5.2 beta                                                                        }
{ Last modified: 2013-10-22                                                                        }
{ Contributors:  Chris Rolliston                                                                   }
{                                                                                                  }
{**************************************************************************************************}

unit ImageForm;

interface

uses
  System.SysUtils, System.Types, System.UITypes, System.Rtti, System.Classes,
  System.Variants, FMX.Types, FMX.Controls, FMX.Forms, FMX.Dialogs, FMX.Objects,
  CCR.Exif, CCR.Exif.FMXUtils;

type
  TfrmImage = class(TForm)
    Image: TImage;
    procedure FormKeyDown(Sender: TObject; var Key: Word; var KeyChar: Char;
      Shift: TShiftState);
  protected
    procedure CreateHandle; override;
  public
    constructor Create(const AOwner: TExifDataPatcher); reintroduce;
    function Owner: TExifDataPatcher; inline;
  end;

implementation

{$R *.fmx}

constructor TfrmImage.Create(const AOwner: TExifDataPatcher);
begin
  inherited Create(AOwner);
  AOwner.GetImage(Image.Bitmap);
  case AOwner.Orientation of
    toBottomRight: Image.Bitmap.Rotate(180);
    toRightTop: Image.Bitmap.Rotate(90);
    toLeftBottom: Image.Bitmap.Rotate(270);
  end;
  TFileManager.AssociateWithForm(AOwner.FileName, Self);
  TMacCommands.EnableFullScreen(Self);
end;

procedure TfrmImage.CreateHandle;
begin
  inherited;
  TWinCommands.EnableOwnTaskbarEntry(Self);
end;

procedure TfrmImage.FormKeyDown(Sender: TObject; var Key: Word;
  var KeyChar: Char; Shift: TShiftState);
begin
  case Key of
    vkEscape, vkReturn:
    begin
      if TMacCommands.IsFullScreen(Self) then
        TMacCommands.ToggleFullScreen(Self)
      else
        Close;
      Key := 0;
    end;
  end;
end;

function TfrmImage.Owner: TExifDataPatcher;
begin
  Result := (inherited Owner as TExifDataPatcher);
end;

end.

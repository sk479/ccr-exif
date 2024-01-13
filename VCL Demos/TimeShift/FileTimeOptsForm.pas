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
{ Exif time shifter VCL demo.                                                                      }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Version:       1.5.4                                                                             }
{ Last modified: 2024-01-13                                                                        }
{ Contributors:  Chris Rolliston                                                                   }
{                                                                                                  }
{**************************************************************************************************}

unit FileTimeOptsForm;

interface

uses
  {$IF RTLVersion >= 23}System.UITypes,{$IFEND}
  SysUtils, Classes, Controls, Forms, StdCtrls, CCR.Exif.Demos;

type
  TFileTimeAction = (ftPreserve, ftMatchExif, ftSetToNow);

  TfrmFileTimeOptions = class(TForm)
    rdoPreserve: TRadioButton;
    rdoMatchExif: TRadioButton;
    rdoSetToNow: TRadioButton;
    Button1: TButton;
    Button2: TButton;
  public
    function ShowModal(var Action: TFileTimeAction): Boolean; reintroduce;
  end;

implementation

{$R *.dfm}

function TfrmFileTimeOptions.ShowModal(var Action: TFileTimeAction): Boolean;
begin
  case Action of
    ftPreserve: rdoPreserve.Checked := True;
    ftMatchExif: rdoMatchExif.Checked := True;
    ftSetToNow: rdoSetToNow.Checked := True;
  end;
  Result := IsPositiveResult(inherited ShowModal);
  if Result then
    if rdoPreserve.Checked then
      Action := ftPreserve
    else if rdoMatchExif.Checked then
      Action := ftMatchExif
    else
      Action := ftSetToNow;
end;

end.

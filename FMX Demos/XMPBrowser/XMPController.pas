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
{ XMP browser FireMonkey demo (require Delphi XE3 to compile).                                     }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Version:       1.5.2 beta                                                                        }
{ Last modified: 2013-10-22                                                                        }
{ Contributors:  Chris Rolliston                                                                   }
{                                                                                                  }
{**************************************************************************************************}

unit XMPController;

interface

uses
  System.Types, System.SysUtils, System.Classes, System.Rtti, FMX.Types, FMX.Forms,
  System.Actions, FMX.ActnList, FMX.StdActns, FMX.Dialogs, FMX.Menus,
  CCR.Exif.FMXUtils;

type
  IXMPDocumentForm = interface
  ['{5E1754C3-6F61-40B3-9840-CB951A31298E}']
    function GetFileName: string;
    procedure GotoNextTab;
    procedure GotoPreviousTab;
    procedure OpenFile(const AFileName: string);
    property FileName: string read GetFileName;
  end;

  TdtmController = class(TDataModule)
    MacMenu: TMainMenu;
    itmApp: TMenuItem;
    MenuItem5: TMenuItem;
    itmDiv: TMenuItem;
    itmHideMe: TMenuItem;
    itmHideOtherApps: TMenuItem;
    itmShowAll: TMenuItem;
    MenuItem6: TMenuItem;
    itmAppQuit: TMenuItem;
    itmFile: TMenuItem;
    itmFileOpen: TMenuItem;
    itmFileClose: TMenuItem;
    MenuItem8: TMenuItem;
    MenuItem9: TMenuItem;
    itmWindow: TMenuItem;
    itmMinimize: TMenuItem;
    MenuItem1: TMenuItem;
    MenuItem2: TMenuItem;
    itmBringAllToFront: TMenuItem;
    dlgOpen: TOpenDialog;
    ActionList: TActionList;
    actOpenFile: TAction;
    actClose: TWindowClose;
    actAppQuit: TFileExit;
    actAppHide: TFileHideApp;
    actAppHideOthers: TFileHideAppOthers;
    actNextTab: TAction;
    actPreviousTab: TAction;
    actMinimizeWindow: TAction;
    actZoomWindow: TAction;
    actAppShowAll: TAction;
    actBringAllToFront: TAction;
    actAppAbout: TAction;
    actToggleFullScreen: TAction;
    procedure DataModuleCreate(Sender: TObject);
    procedure actOpenFileExecute(Sender: TObject);
  private
  strict private
    class var FDocumentFormClass: TFormClass;
    class var FSDIForm: TForm;
    class constructor Create;
  protected
    procedure OpenFile(const AFileName: string);
  end;

var
  dtmController: TdtmController;

implementation

{%CLASSGROUP 'FMX.Types.TFmxObject'}

{$R *.dfm}

{ TdtmController }

class constructor TdtmController.Create;
begin
  if not LookupImplementingClass(IXMPDocumentForm, TForm, FDocumentFormClass) then
    raise EProgrammerNotFound.Create('IXMPDocumentForm implementor missing');
  if TOSVersion.Platform = pfMacOS then
    TFileManager.DocumentMode := dmOnePerForm
  else
  begin
    TFileManager.DocumentMode := dmOnePerAppInst;
    Application.CreateForm(FDocumentFormClass, FSDIForm);
  end;
end;

procedure TdtmController.DataModuleCreate(Sender: TObject);
begin
  { Initialize the menu bar if targetting macOS }
  if TOSVersion.Platform = pfMacOS then
  begin
    TMacCommands.InitializeAboutAction(actAppAbout);
    TMacCommands.InitializeShowAllAction(actAppShowAll);
    TMacCommands.InitializeToggleFullScreenAction(actToggleFullScreen);
    TMacCommands.InitializeMinimizeAction(actMinimizeWindow);
    TMacCommands.InitializeZoomAction(actZoomWindow);
    TMacCommands.InitializeBringAllToFrontAction(actBringAllToFront);
    MacMenu.Activate;
    TMacCommands.InitializeWindowMenu(itmWindow);
  end
  else
    ConvertCommandToCtrlShortcuts(ActionList);
  TFileManager.OnOpenFile := OpenFile;
end;

procedure TdtmController.OpenFile(const AFileName: string);
var
  DocForm: TForm;
begin
  if TFileManager.DocumentMode = dmOnePerAppInst then
    DocForm := FSDIForm
  else
    DocForm := FDocumentFormClass.Create(Self);
  try
    (DocForm as IXMPDocumentForm).OpenFile(AFileName);
  except
    if DocForm <> FSDIForm then DocForm.Free;
    raise;
  end;
  TFileManager.AssociateWithForm(AFileName, DocForm);
  DocForm.Show;
end;

procedure TdtmController.actOpenFileExecute(Sender: TObject);
begin
  if dlgOpen.Execute then OpenFile(dlgOpen.FileName);
end;

end.

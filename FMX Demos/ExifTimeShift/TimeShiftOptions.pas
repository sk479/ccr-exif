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

unit TimeShiftOptions;

interface

type
  TFileTimeBehaviour = (ftPreserve, ftMatchExif, ftSetToNow);

function FileTimeBehaviour: TFileTimeBehaviour;
procedure SetFileTimeBehaviour(NewValue: TFileTimeBehaviour);

implementation
{
  In practice, it would be better to make use of something like my Mac Preferences
  API wrapper (http://delphi-foundations.googlecode.com/svn/trunk/FMX%20Utilities/).
  I don't here just to avoid dependencies beyond the CCR Exif code itself.
}
{$IFDEF MACOS}
uses
  Macapi.CoreFoundation;
{$ENDIF}
{$IFDEF MSWINDOWS}
uses
  System.Win.Registry;

const
  PrefPath = 'Software\CCR Exif\Exif Time Shift';
{$ENDIF}

function TryReadIntPreference(const Key: string; var Value: Int32): Boolean;
{$IFDEF MACOS}
var
  CFKey: CFStringRef;
  CFValue: CFPropertyListRef;
{$ENDIF}
begin
  Result := False;
{$IFDEF MACOS}
  CFKey := nil;
  CFValue := nil;
  try
    CFKey := CFStringCreateWithCharacters(nil, PChar(Key), Length(Key));
    CFValue := CFPreferencesCopyAppValue(CFKey, kCFPreferencesCurrentApplication);
    if (CFValue = nil) or (CFGetTypeID(CFValue) <> CFNumberGetTypeID) then Exit;
    CFNumberGetValue(CFValue, kCFNumberSInt32Type, @Value);
    Result := True;
  finally
    if CFKey <> nil then CFRelease(CFKey);
    if CFValue <> nil then CFRelease(CFValue);
  end;
{$ENDIF}
{$IFDEF MSWINDOWS}
  with TRegistry.Create do
  try
    if OpenKeyReadOnly(PrefPath) then
      try
        Value := ReadInteger(Key);
        Result := True;
      except
        on E: ERegistryException do { swallow if int value not there }
      end;
  finally
    Free;
  end;
{$ENDIF}
end;

procedure WriteIntPreference(const Key: string; Value: Int32);
{$IFDEF MACOS}
var
  CFKey: CFStringRef;
  CFValue: CFNumberRef;
{$ENDIF}
begin
{$IFDEF MACOS}
  CFKey := nil;
  CFValue := nil;
  try
    CFKey := CFStringCreateWithCharacters(nil, PChar(Key), Length(Key));
    CFValue := CFNumberCreate(nil, kCFNumberSInt32Type, @Value);
    if (CFKey <> nil) and (CFValue <> nil) then
    begin
      CFPreferencesSetAppValue(CFKey, CFValue, kCFPreferencesCurrentApplication);
      CFPreferencesAppSynchronize(kCFPreferencesCurrentApplication);
    end;
  finally
    if CFKey <> nil then CFRelease(CFKey);
    if CFValue <> nil then CFRelease(CFValue);
  end;
{$ENDIF}
{$IFDEF MSWINDOWS}
  with TRegistry.Create do
  try
    if OpenKey(PrefPath, True) then
      WriteInteger(Key, Value);
  finally
    Free;
  end;
{$ENDIF}
end;

var
  mDoneFirst: Boolean = False;
  mFileTimeBehaviour: TFileTimeBehaviour = ftPreserve;

function FileTimeBehaviour: TFileTimeBehaviour;
var
  IntValue: Int32;
begin
  if not mDoneFirst then
  begin
    mDoneFirst := True;
    if TryReadIntPreference('FileTimeBehaviour', IntValue) and
       (IntValue >= Ord(Low(TFileTimeBehaviour))) and
       (IntValue <= Ord(High(TFileTimeBehaviour))) then
      mFileTimeBehaviour := TFileTimeBehaviour(IntValue);
  end;
  Result := mFileTimeBehaviour;
end;

procedure SetFileTimeBehaviour(NewValue: TFileTimeBehaviour);
begin
  if mFileTimeBehaviour = NewValue then Exit;
  mFileTimeBehaviour := NewValue;
  WriteIntPreference('FileTimeBehaviour', Ord(NewValue));
end;

end.

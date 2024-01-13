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
{ This unit contains general constants and resource strings used within the project.               }
{                                                                                                  }
{**************************************************************************************************}
{                                                                                                  }
{ Version:       1.5.4                                                                             }
{ Last modified: 2024-01-13                                                                        }
{ Contributors:  Chris Rolliston                                                                   }
{                                                                                                  }
{**************************************************************************************************}

unit CCR.Exif.Consts;

interface

const
  CCRExifVersion = '1.5.4';

resourcestring
  SInvalidHexString = 'Invalid hex string (%s)';
  SStreamIsReadOnly = 'Stream is read-only';
  SUnsupportedGraphicFormat = 'Unsupported graphic format';
  SInvalidJPEGHeader = 'JPEG header is not valid';
  SInvalidPSDHeader = 'Photoshop (PSD) file header is not valid';
  SFileIsNotAValidJPEG = '"%s" is not a valid JPEG file';
  SInvalidTiffData = 'Invalid TIFF data';
  SInvalidOffsetTag = 'Tag does not specify an offset';
  SInvalidExifData = 'Malformed EXIF data';
  SAsciiValueCannotBeArray = 'An ASCII tag cannot be an array';
  SUndefinedValueMustBeBeArray = 'An undefined tag must be an array';
  SInvalidFraction = '''%s'' is not a valid fraction';
  STagAlreadyExists = 'Tag with ID of "%d" already exists in section';
  SNoFileOpenError = 'No file is open';
  SIllegalEditOfExifData = 'Illegal attempt to edit the Exif data in such ' +
    'a way that it would change the file structure';
  STagCanContainOnlyASCII = 'Tag may contain only ASCII string data';

  SInvalidMakerNoteFormat = 'Invalid MakerNote format';

  SCannotRewriteOldStyleTiffJPEG = 'Cannot rewrite old style TIFF-JPEG';

  SInvalidXMPPacket = 'XMP packet is not valid';
  SSubPropertiesMustBeNamed = 'Sub-properties must be named';
  SSubPropertiesNotSupported = 'Property type does not support sub-properties';
  SCannotWriteSingleValueToStructureProperty = 'Cannot assign a single value to a structure property';
  SPreferredPrefixMustBeSet = 'The schema''s PreferredPrefix property must be set before a new item can be added';

  SInvalidAdobeSegment = 'Invalid Adobe metadata segment';
  SInvalidIPTCTagSizeField = 'Invalid IPTC tag size field (%d)';

  SAboveSeaLevelValue = '%s above sea level';
  SBelowSeaLevelValue = '%s below sea level';
  STrueNorthValue = '%s° true north';
  SMagneticNorthValue = '%s° magnetic north';

implementation

end.
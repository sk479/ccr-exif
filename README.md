# **CCR Exif v1.5.4 (January 2024)**

### **What it is**
CCR Exif is a cross platform Delphi library to read and write Exif, IPTC and XMP metadata from JPEG, TIFF and PSD images.

### **Author**
[Chris Rolliston](https://delphihaven.wordpress.com/), now maintained by [Wolfcast](https://wolfcast.com/).

### **Licence**
[Mozilla Public License, version 2.0](LICENSE.txt) ([license also available on mozilla.org](https://www.mozilla.org/en-US/MPL/2.0/)).

### **Updates**
You can find the latest version on the [GitHub repository](https://github.com/Wolfcast/ccr-exif). The project was originally hosted on [Google Code](https://code.google.com/archive/p/ccr-exif/) by the original author.

### **Requirements**
Any version from Delphi 12 (Athens) down to Delphi 2006.

Older versions of Delphi (prior 10) are no longer actively tested. If you have any problem don't hesitate to [open an issue](https://github.com/Wolfcast/ccr-exif/issues).

**Important if using Delphi XE2 or greater:** CCR.Exif.pas by default is neutral between the VCL and FireMonkey GUI frameworks. For full functionality with respect to JPEG thumbnails, this unit must be compiled with either a VCL or FMX global define set. You can do this with your project open under menu Project > Options... then select Delphi Compiler under Building then select your target platform in the combo box. Next, in the Conditional defines field enter either FMX or VCL as appropriate. Repeat this procedure for all your target platforms.

### **Features**
* Exif parsing is 100% pure Delphi code it doesn't use (say) LibExif or LibTiff, or an operating system graphics API.
* Compiles for all three targets (Win64, Win32 and macOS) when available, with older Win32 versions going back to Delphi 2006.
* Reads and writes both small and big-endian data.
* Supports both standard Exif and Windows Explorer tags, and provides access to the tags of some maker note types too.
* Doesn't corrupt internal maker note offsets when data is rewritten, and takes account of the Microsoft-defined OffsetSchema tag.
* Can optionally write XMP data as per the XMP Exif schema.
* Includes an IPTC reader/writer class as well.

### **Basic usage**
```pascal
uses
    CCR.Exif;

procedure ReadCameraMakeAndModel(const FileName: string; out Make, Model: string);
var
    ExifData: TExifData;
begin
    ExifData := TExifData.Create;
    try
        ExifData.LoadFromGraphic(FileName);
        Make := ExifData.CameraMake;
        Model := ExifData.CameraModel;
    finally
        ExifData.Free;
    end;
end;

procedure WriteCameraMakeAndModel(const FileName: string; const Make, Model: string);
var
    ExifData: TExifData;
begin
    ExifData := TExifData.Create;
    try
        ExifData.LoadFromGraphic(FileName);
        ExifData.CameraMake := Make;
        ExifData.CameraModel := Model;
        ExifData.SaveToGraphic(FileName);
    finally
        ExifData.Free;
    end;
end;
```

### **Documentation**

Please see the [PDF included](Documentation.pdf) with the release. A small set of console and GUI demos are also included with the release.

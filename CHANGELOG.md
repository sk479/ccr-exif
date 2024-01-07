# **Release History**

### **1.5.4 (2024-01-07)**
* First [Wolfcast](https://github.com/Wolfcast/ccr-exif) release.
* Updated license from MPL 1.1 to MPL 2.0.
* Now compiles properly in:
    * Delphi 12.0 (Athens)
    * Delphi 11.x (Alexandria)
    * Delphi 10.4 (Sydney)
    * Delphi 10.3 (Rio)
* Updated documentation.
* Ported SVN repo to Git and "Gitified" some files.

### **1.5.3 (2014-02-02)**
* Helper methods added to the XMP code.
* Got the code compiling for older Delphi versions again; deprecated a couple AsString methods in favour of the ToString naming.
* Added standalone TExifResolution class.
* Added Delphi XE5 support. Note: mobile targets require [Andreas Hausladen's patch](https://www.idefixpack.de/blog/2013/12/system-bytestrings-support-for-xe5-update-2/) to restore UTF8String, etc.
* A few other fixes and tweaks.

### **1.5.2 beta (2013-10-22)**
* TExifSection.TryGetStringValue now trims excess null terminators.
* FMX demos added (require XE3 to compile).
* TIPTCData now uses TArray\<string\> not Types.TStringDynArray for a few properties when compiling in XE3 to allow assigning SomeTStringsInst.ToStringArray.
* Added D2009+ style ToString methods to TxxxTagValue record types.
* Workaround for FMX/OS X bug re thumbnail creation.
* Fix ADOM issue (alternative-array elements not being read).
* Removed items previously marked as deprecated.
* Compiles properly in D2006 again, thanks to 'Thomas' (though for the last time - really!).
* Made change to TCustomExifData.SetAuthor suggested by Thomas Mueller (https://delphihaven.wordpress.com/2012/01/16/xe2-update-for-my-image-metadata-readingwriting-library-ccr-exif/comment-page-1/#comment-4998).
* A few other tweaks.

### **1.5.1 (2012-08-05)**
* XE2 support for each of that version's three target platforms (Win32, Win64 and OS X). Note: the code remains as Delphi-specific as ever however, so XE2's iOS targeting (so much as it is) is **not** supported.
* Dependencies on VCL graphics classes have been removed from all the support units - where there was a TGraphic parameter, there is now an IStreamPersist one instead (both the VCL TGraphic and FireMonkey TBitmap classes implement that interface).
* **When using CCR Exif in a FireMonkey application**, you will need to set a **FMX** conditional define for the 'main' unit, CCR.Exif.pas, to work properly. When v1.5.1 was in beta, you conversely needed to have a VCL define set in an XE2 VCL application, but that is not necessary in the final version. By tweaking CCR.Exif.inc, it is also possible for the library to be completely neutral between the two frameworks, however this is not useful in practice.
* The demo projects have been split off into D2006, D2007, D2009-10 and XE+ versions. If you open up the XE+ versions in XE, you may see some 'phantom' platform nodes in the Project Manager - just ignore them, as they are XE2 settings.
* Fixed XMP reading issues when using the ADOM backend, as will be the default when targeting OS X.
* Fixed issue of XMP changes not always being persisted.

### **1.5.0 (2011-10-05)**
* Two important things up front: the CCR.Exif.JPEGUtils unit has been renamed CCR.Exif.BaseUtils, and all LoadFromJPEG and SaveToJPEG methods have been deprecated in favour of LoadFromGraphic and SaveToGraphic ones instead. Also, the TIFF structure parsing routines have been moved from CCR.Exif to a new unit called CCR.Exif.TiffUtils. These changes have been made because I've added read/write support for Photoshop (PSD) and TIFF images to each of TExifData, TIPTCData and TXMPPacket. *Be warned that write support is semi-experimental at this point.*
* The new LoadFromGraphic overloads are functions with a Boolean result. If when calling one it returns False, this means the graphic type wasn't recognised as one that *could* contain relevant metadata (SaveToGraphic, in contrast, would raise an exception in such a case). Note that LoadFromGraphic returning False does *not* simply mean that no relevant metadata was found - for that, check the Empty property afterwards.
* Various bits of internal reorganisation:
    * Various things moved into CCR.Exif.BaseUtils (e.g. the TXXXTagValue advanced records from CCR.Exif.IPTCData).
    * Code for lazy loading of XMP packets moved to TXMPPacket itself from TCustomExifData.
* SaveToGraphic calls are now always buffered, to a temporary file if the graphic to be altered is large.
* Added TDateTimeTagValue, with the consequence that 0 is no longer considered the 'missing' value for a date/time tag. Instead, call the MissingOrInvalid function on the tag property (r29).
* Fixed stupid bugs in TXXXTagValue.CreateFromString (r14).
* Made TAdobeBlock.LoadFromStream more forgiving (r14).
* Fixed saving bug in TIPTCData.DoSaveToJPEG - TStream.CopyFrom was potentially being called with 0 as the second parameter, causing a complete copy and so duplication of data (r14).
* Amended DateTimeToXMPString to output in the 'human readable' format recommended (but not required) by Adobe's spec when a local adjustment is required (r15).

### **1.1.2 (2011-01-23)**
* Added UTF-8 support to TIPTCData when compiling under D2009 or later.
    * Specifically, added AlwaysAssumeUTF8Encoding and UTF8Encoded properties (also removed the ReadString overload that took an AnsiString parameter).
    * By default, AlwaysAssumeUTF8Encoding is False but UTF8Encoded is True, only being set to the value of AlwaysAssumeUTF8Encoding on LoadFromXXX being called. This means that when creating IPTC data afresh, the default will be to encode in UTF-8, setting the 1:90 tag to report the fact. When loading existing data however, the source is assumed to hold AnsiString values unless UTF-8 is explicitly specified in 1:90.
* Bug fixes and tweaks:
    * XMP parsing rejigged somewhat again to (a) allow for the fact a property need not share the namespace of its parent and (b) read 'property-and-node elements' properly (https://www.w3.org/TR/REC-rdf-syntax/#section-Syntax-parsetype-resource). Note this means a couple enumeration types have been renamed and NamespaceInfo properties added to TXMPProperty and TXMPSchema.
    * Missing standard XMP namespaces (e.g. Exif Auxiliary) now registered.
    * Fixed bug that meant the total size of very large JPEG segments wasn't being calculated correctly.
    * Fixed small bug of TIPTCSection.Owner never being set.
    * A couple of tweaks on the theme of accepting malformed data.

### **1.1.1 (2010-08-02)**
* Tweaked default behaviour of file name variants of TCustomExifData.SaveToJPEG and TIPTCData.SaveToJPEG to write to a memory stream first. This protects against the case of when the file exists, but is not a valid JPEG file (before, the file would just get wiped on the exception being raised).
* Added EnsureEnumsInRange property to TCustomExifData. When True (the default), enumeration tag property values will definitely be in the declared range - if the stored value is otherwise, it will be reported as missing unless you get at the raw data directly.
* Slightly modified TXMPPacket.TryLoadFromStream to support ExifTool's not-quite-XMP XML dump format.

### **1.1.0 (2010-03-07)**
* While the interface remains practically the same as before, the XMP handling code has been substantially rewritten, mainly for the sake of better supporting Adobe's implementation:
    * TXMPPacket understands XMP properties written out as XML attributes.
    * TXMPPacket's writing code now writes the packet out afresh (before, the original DOM structure was kept hold of and modified in place using the DOM API).
    * Changed the type of the RawXML property from DOMString to UTF8String and given it a setter.
    * Added OnLoadError event to TXMPPacket.
    * The TXMPPacket instance owned by a TCustomExifData object now only raises an EInvalidXMPPacket exception if its LoadFromStream or LoadFromFile methods are called explicitly.
* Moved the CCRExifVersion constant to CCR.Exif.Consts.pas.
* Removed the StreamHasXXXHeader routines, replacing them with HasXXX equivalents.
* Thanks to Stefan Grube for helping ensure this release compiles correctly in D2009+.

### **1.0.1a (2010-02-20)**
* Slight change to CCR.Exif.pas only: fixed implicit memory overwrite error in TCustomExifData.GetDetailsLongWord.

### **1.0.1 (2010-02-13)**
* TCustomExifData now accepts Exif segments that declare themselves to be big endian when they are really small endian or vice versa.
* elTrilinear renamed esTrilinear.
* In the Exif List demo, replaced most of the string array constants with functions so as to prevent access violations when a tag value is out of its corresponding enumerated type's range.
* Completely removed the MakerNotePosition property from TExifData. Behaviour is now fixed to the old default (mpAuto), which is to stream out maker note data to their original location.

### **1.0.0 (2010-01-17)**
* Added IPTC support:
    * Implemented an IPTC reader/writer class, TIPTCData, in a new unit, CCR.Exif.IPTC.pas.
    * The interface of TIPTCData is broadly modelled on TExifData's - thus, there are 'sections' and 'tags', with high level tag properties on TIPTCData itself (see https://www.iptc.org/std/IIM/4.1/specification/IIMV4.1.pdf for the IPTC specification).
    * At a lower level, the RemoveMetadataFromJPEG global routine can now delete IPTC data, and you can enumerate the data blocks of an Adobe APP13 segment from an IJPEGSegment instance.
* TJPEGImageEx has received a few amendments:
    * Added an IPTCData property.
    * Added an overload to Assign that allows for the preservation of any metadata, interpreted by my code or not, when a bitmap is assigned.
    * Fixed a bug in which calling the regular Assign didn't cause the ExifData property to be updated.
* Two more Nikon maker note types now parsed. Thanks goes to Stefan Grube for updating the Exif List demo's MakerNotes.ini for this.
* Fixed bug of JPEG parsing code not realising a segment with a marker number of 0 has no data.
* Fixed typo in TStreamHelper.ReadLongInt spotted by Jeff Hamblin.
* Changed the types of the ExifImageWidth, ExifImageHeight and FocalLengthIn35mmFilm properties of TCustomExifData so as to give them MissingOrInvalid and AsString sub-properties (basically, they now use custom record types that have methods and operator overloads).
* Changed behaviour of TCustomExifData's enumerator to now *not* skip empty sections.
* The LoadFromJPEG methods of TExifData are now procedures rather than functions.
* Added a couple more demos, namely an IPTC editor and a console app to strip specified types of metadata from one or more JPEG files.
* Removed all previously deprecated symbols.

### **0.9.9 (2009-11-19)**
* Two main themes for this release: adding sanity checks to the parsing code (thus, you shouldn't get access violations when attempting to stream in corrupted data any more) and better maker note support.
* All TIFF offsets are now sanity checked.
* Internally, there's a 'two strikes and out' policy when parsing an IFD - two invalid tag headers in a row, and parsing for that directory is abandoned. Check the new LoadErrors property on TExifSection to determine whether there were any issues.
* The tag structures of Canon, Nikon type 1, Panasonic and Sony maker notes are now understood. You access the tags via either the MakerNote.Tags or Sections[esMakerNote] properties on TCustomExifData. The interpretation of tag **values** is still left to the user however, since the alternative was to add reams and reams of boilerplate tag property code. Nonetheless, an example of how such interpretation may be done, namely via an INI file, is in the Exif List demo.
* Existing maker notes can be edited with TExifDataPatcher; TExifData will probably come later (I'm offsetted out at the moment...).
* Other, more minor changes:
    * Fixed typo in GPS direction tag setter which meant the value could never be changed.
    * Added memory leak fix to CCR.XMPUtils.pas suggested by David Hoyle.
    * Added delay loading semantics to the XMPPacket property of TCustomExifData, the idea being that attempts to read Exif tags should not ever lead to an EInvalidXMPPacket exception being raised. Equivalent behaviour has been built into the new maker note parser code too.
    * More helper methods of the TryGetXXXValue and ReadXXX kind.
    * Surfaced two interop IFD tags as properties on TCustomExifData.
    * Maker note data are now moved back to their original position on save if the OffsetSchema tag had been set (actually, this should have been the case for the previous release but for a bug, typing Inc where I meant Dec).
    * XMP 'about' attribute value now retrieved if previously written without a namespace.
    * Demos rejigged a bit - PanasonicMakerNoteView.exe removed (its functionality has been added to an improved ExifList.exe), and two new console ones added (CreateXMPSidecar.exe and PanaMakerPatch.exe).

### **0.9.8 (2009-10-18)**
* Fixed how the ExifImageWidth and ExifImageHeight properties weren't flexible enough to understand word-sized values (the Exif spec says these tags can be either words or longwords).
* By default, when streaming out, the maker note tag (if it exists) now keeps the data offset it had when streamed in. This means you are free to add, remove and edit tags as you please with TExifData without fear of corrupting internal maker note offsets, though there's a small cost in terms of file size. If you want the old behaviour, you can get it back by setting the new MakerNotePosition property of TExifData to mpCanMove.
* Much better XMP support has been implemented:
    * A new unit, CCR.Exif.XMPUtils, has been added; this implements an XMP packet parser directly on top of xmldom.pas (all that excess code for so little gain in XMLDoc.pas makes my eyes water...). A new demo, XMP Browser, shows its basic usage.
    * TCustomExifData has acquired an XMPPacket property that gets loaded in LoadFromJPEG, written out in SaveToJPEG, and updated as appropriate when certain tag properties are set. The default behaviour is to only change existing XMP property values, though this can be altered to mimic the behaviour of Vista's Windows Explorer, which adds them as well, by setting ExifData.XMPWritePolicy to xwAlwaysUpdate.
* EReadError (typically raised by TStream.ReadBuffer) is now trapped in one of the low-level loading routines so as to be 'friendlier' (to the end user!) when you attempt to load a corrupt Exif block. To be honest, I'm not massively keen on doing this, but anyhow, the change has been made.
* Other changes:
    * Some missing tag properties from v2.2 of the Exif standard added to TCustomExifData (Contrast, FlashPixVersion, Saturation, Sharpness).
    * ISOSpeedRatings is now a class rather than an array property.
    * Some of the GPS properties have become class properties.
    * Setting a string tag to an empty string now removes it; likewise, setting an invalid fraction value, where the destination tag only has one value currently, will remove the tag too.
    * Removed from CCR.Exif.JPEGUtils the symbols that were deprecated last time around.
    * Bug fix - TCustomExifData.LoadFromJPEG now clears the tags if no Exif segment was found in the source image.
    * Behaviour change - TExifData.SaveToJPEG now enforces a segment order of JFIF -> Exif -> XMP, and moreover, moves those segments to the top of the file if they weren't there already.
    * Renamed StreamHasXMPHeader to StreamHasXMPSegmentHeader to better reflect what it tests for.
    * TJPEGMarkerHeader renamed TJPEGSegmentHeader.
    * PosOfDataInStream property of IFoundJPEGSegment renamed OffsetOfData.
    * IGetJPEGHeaderParser collapsed into IJPEGHeaderParser.

### **0.9.7 (2009-06-22)**
* The focus of this release was making the code more aware of what more recent versions of Windows Explorer (amongst other Microsoft applications) do when a person uses them to edit JPEG metadata.
* TExifData.SaveToStream now adds or updates the Microsoft-defined OffsetSchema tag if a maker note is defined (see [http://support.microsoft.com/kb/927527](https://web.archive.org/web/20120830212742/http://support.microsoft.com/kb/927527)).
* Various enumerated types have acquired a xxTagMissing value to more easily determine whether the underlying tag actually exists.
* The following symbols have been added (see the documentation for more info):
    * PreserveXMPData property to TCustomExifData; default is False.
    * IsPadding and SetAsPadding methods to TExifTag; RemovePaddingTag method to TExifSection; RemovePaddingTags method to TCustomExifData. All these concerns the padding tags Microsoft applications tend to write out.
    * RemoveMetaDataFromJPEG, StreamHasExifHeader and StreamHasXMPHeader  global functions to CCR.Exif.
    * DigitalZoomRatio, FocalLengthIn35mmFilm, GainControl, ImageUniqueID, MakerNoteDataOffset, Rendered, SceneCaptureType, SubjectDistanceRange, ThumbnailOrientation, ThumbnailResolution, and WhiteBalanceMode properties to TCustomExifData - all surface standard tags I missed out previously.
    * JPEGHeader global routine to CCR.Exif.JPEGUtils as a more flexible replacement for ParseJPEGHeader; unlike the latter, it doesn't take a callback method, being used instead with the for/in syntax:
```pascal
    var
        Segment: IFoundJPEGSegment;
        JPEGImage: TJPEGImage;
    begin
        for Segment in JPEGHeader('filename.jpg') do
            //...
        for Segment in JPEGHeader(JPEGImage) do
            //...
```
* Deprecated:
    * The jmExif constant in CCR.Exif.JPEGUtils - use jmApp1 instead. The reason for this change is that Exif and XMP segments share the same marker number; the value of what was jmExif, then, isn't unique to Exif.
    * DefJFIFData global variable in CCR.Exif.JPEGUtils - this hasn't been used internally since v0.9.5.
    * ParseJPEGHeader function in CCR.Exif.JPEGUtils - use JPEGHeader with a for/in loop instead.
    * RemoveExifDataFromJPEG functions in CCR.Exif - use the new RemoveMetaDataFromJPEG functions instead. That said, a bug in the overload that takes a stream object has been fixed.
    * WriteJPEGMarkerToStream procedures in CCR.Exif.JPEGUtils - renamed WriteJPEGSegmentToStream.
* Custom exception classes slightly rearranged and documented.
* JPEG Dump and Exif List demos updated slightly.

### **0.9.6 (2009-06-14)**
* Some documentation added, albeit only in the form of a PDF file.
* Fixed potential data corruption bug in TJpegImageEx.SaveToStream. As part of this fix, whereas before, a specific JFIF segment was always written out, now nothing is touched (including the JFIF segment - even if missing) other than any existing Exif segment.
* Added SaveToJPEG method to TExifData. Calling this will replace any Exif metadata in the specified JPEG file with what is currently defined by the TExifData object. In combination with the existing LoadFromJPEG method, this provides a more flexible way of editing existing Exif metadata than that provided by TExifDataPatcher. (Note that you could have got similar behaviour before if you had used TJpegImageEx instead of TExifData directly.) The old caveat about maker note data still remains though.
* Added RemoveExifDataFromJPEG global routine, which takes either a file name or a TJPEGImage instance as its parameter and returns True if there were Exif data to remove.
* Fixed TExifData.SaveToStream so that it now saves GPS and/or Interop sections (doh!). Nonetheless, they are only written out if they have any tags. So, say you load into an TExifData instance data that includes GPS info, call Clear on the esGPS section, and save out again; doing this will remove the GPS sub-IFD from actual file. Now, this behaviour will only save six bytes compared to writing out an empty IFD or sub-IFD. Nonetheless, it is aesthetically quite pleasing I think, and matches how the thumbnail IFD isn't (and never was) written out when Thumbnail.Empty returns True.
* Partly due to rewriting the saving code, partly due to a change of heart, the CanSafelySaveTag, GetTagsToSave, SaveSave and OnCanSafelySaveTag members of TExifData have been removed.
* In TCustomExifData, the ResolutionUnit, XResolution and YResolution properties have been replaced with a single Resolution property, with the FocalPlaneResolutionUnit, FocalPlaneResolutionX and FocalPlaneResolutionY properties replaced with FocalPlaneResolution. In the course of doing this, I fixed a bug of erroneously assuming the two sets of properties shared the same section.
* The ColorSpace property on TCustomExifData has changed its type from Word to a new word-sized enumeration (TExifColorSpace).
* Setting a tag or tag element to its current value is now much less likely to cause the container object to have its Modified property set to True.
* Added TagExists function to TExifSection.
* Added MissingOrInvalid function to TExifFlashInfo.
* More complete implementation of TExifFlashInfo.Assign.
* You can now remove tags from a TExifDataPatcher instance. Because of this, TCustomExifData now publicly exposes the Clear method, and TExifSection has acquired Remove and Clear from TExtendableExifSection, with ClearTag being deleted.
* Added testing mode to Exif List and JPEG Dump demos - pass the /test switch as a parameter to the EXE. Done mainly to test the revised saving code in TExifData, though it demonstrates the latter's new SaveToJPEG method I suppose...
* Thanks to Valerian Kadyshev for suggestions that were partly implemented in this release, along with David Hoyle again for a few more bug reports.

### **0.9.5b (2009-06-04)**
* And another regression fixed... Should compile in D2009 again now.

### **0.9.5a (2009-06-03)**
* Regression fixed - original release of 0.9.5 broke setting string tags in D2009. Thanks to commentator Andreas for spotting the bug.

### **0.9.5 (2009-06-01)**
* A few typos fixed in the getter and setters of TCustomExifData.
* TExifTag.SetAsString fixed when DataType = tdUndefined.
* A new Boolean property, EnforceASCII, added to TCustomExifData; default value is True so that tags with a data type of tdASCII will now only allow ASCII data to be assigned to them. Set EnforceASCII to False to restore the old, lax behaviour.
* For Delphi 2009, ASCII tags are now surfaced as normal strings; because of this, you shouldn't cast to TiffString any more when setting a string tag. Furthermore, TiffString is itself now just type def'ed to AnsiString rather than an English AnsiString specifically.
* The Comments property of TCustomExifData now no longer checks for ttImageDescription.
* The ExifVersion and GPSVersion properties of TCustomExifData have changed their types, with the old ones removed.
* The DirectlyPhotographed property of TCustomExifData has been removed and replaced with SceneType.
* The SourceIsDigitalCamera property of TCustomExifData has been removed and replaced with FileSource.
* WritePreciseTimes property of TCustomExifData has become AlwaysWritePreciseTimes.
* drTrue -> drTrueNorth, drMagnetic -> drMagneticNorth.
* ShutterSpeedInMSecs function and GPSDateStamp, GPSDateTimeUTC and GPSDifferentialApplied properties added to TCustomExifData (GPSDateTimeUTC converts and combines the values stored in GPSDateStamp and GPSTimeStampXXX).
* The internal enumerator types have acquired a T prefix.
* Exif List demo added.
* Thanks to David Hoyle for pointing out needed bug fixes.

### **0.9.0 (2009-05-12)**
* Original release.

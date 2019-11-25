# syncTunes

syncTunes is a quick macOS project I put together to easily copy files from my iTunes library onto a USB thumb drive for use with a Ford SYNC 3 system. However, as this really is just tweaking the contents of an M3U playlist file, and not writing anything Ford-specific, this would likely work with other devices that can read M3U playlists. At the end of the day, it's just copying files to a new location, and adjusting the playlist files to match. 

While I use it with iTunes, iTunes is *not* required. You'll really just need something that can generate .m3u playlist files that the tool can then parse. You will need a Mac though, and the developer tools to build it.

## Description

When used, the following steps will happen:

1. syncTunes will scan the supplied directory for .m3u playlist files and build a list of the tracks included.
2. Each track's file extension will be checked, and if it's a supported type, will be copied to a new playlist.
3. Supported track files will be copied from the location listed in the playlist file to the output directory.
4. New playlist files will be written to the output directory, these new playlists will:
	* Preserve the order of the original playlist
	* Omit any unsupported files
	* Have new file paths that point to the copied files. These paths will be relative to the output directory

## Usage

After building the project, in Terminal.app (or other command-line app) navigate to the directory containing syncTunes.

Invoke syncTunes: `syncTunes -i path/to/input/dir -o path/to/output/dir`

Both an input and output option are required. The input dir must contain .m3u files, and the output directory will be a directory where the new playlist file and music files will be copied to.

If the output directory does exist, **it will be overwritten.**

If the output directory does not exist, a new one will be created. In this directory, a new .m3u file will created, and copies of the files listed in the playlist will be added. Once again, if the output directory does exist, **it will be overwritten.**

Once the files have been copied to the output directory, copy the contents of this directory to the root folder of the USB drive you'll be using in your vehicle.

## Creating .m3u Playlists in iTunes

In iTunes a playlist can be exported in .m3u format by:

1. Select the playlist to be exported
2. File > Library > Export Playlist…
3. Select the save destination for the exported playlist.
4. Save the playlist with the format set to `M3U`

## SYNC 3 Notes

> **Note:** Info below is taken from the SYNC 3 Supplement manual, May 2015 printing.

SYNC 3 systems can support multiple audio formats. When syncTunes runs, it will scan the playlist files for supported files based on the extension. Only supported files will be copied and written to the updated playlists.

Supported audio formats:

- MP3
- WMA
- WAV
- AAC
- FLAC

Supported audio file extensions:

- MP3
- WMA
- WAV
- M4A
- M4B
- AAC
- FLAC

Supported USB file systems include: FAT, exFAT, and NTFS.

SYNC 3 is also able to organize the media from your USB device by metadata tags. Metadata tags, which are descriptive software identifiers embedded in the media files, provide information about the file.

If your indexed media files contain no information embedded in these metadata tags, SYNC 3 may classify the empty metadata tags as unknown.

SYNC 3 is capable of indexing up to 50,000 songs per USB device, for up to 10 devices.

## Links

The links below were used to help me figure out how to do this and get it working with my truck's SYNC system.

* [Ford: How to play your digital media player with SYNC 3](https://owner.ford.com/how-tos/sync-technology/sync-3/entertainment/how-to-play-your-digital-media-player-with-sync-3.html)
* [Ford: Ford SYNC 3 Supplement](http://www.fordservicecontent.com/Ford_Content/Catalog/owner_information/Ford-SYNC-3-Supplement-version-1_sycsy_EN-US_05_2015.pdf)
* [FordFlex.net: Sync and Playlists](https://www.fordflex.net/forums/viewtopic.php?t=7154)
* [Wikipedia: Ford SYNC](https://en.wikipedia.org/wiki/Ford_Sync)

### M3U File Info

* [Wikipedia: M3U](https://en.wikipedia.org/wiki/M3U)
* [schworak.com: M3U Play List Specification](https://schworak.com/blog/e39/m3u-play-list-specification/)
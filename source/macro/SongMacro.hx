package macro;

import haxe.Json;
import sys.FileSystem;
import utils.Asset;
import utils.Chart.ChartFile;
import utils.Song.SongMetadata;

using StringTools;

class SongMacro
{
	public static macro function getBaseSongs():ExprOf<Array<SongMetadata>>
	{
		var base:String = "assets/songs/base";
		var songs:Array<SongMetadata> = [];

		for (songFolder in FileSystem.readDirectory(FileSystem.absolutePath(base)))
		{
			var songFilesPath:String = FileSystem.absolutePath('assets/songs/base/$songFolder');
			if (FileSystem.isDirectory(songFilesPath))
			{
				for (songFile in FileSystem.readDirectory(songFilesPath))
				{
					if (!songFile.endsWith(".json"))
						continue;

					trace(Asset.chart(songFile.split(".")[0]));
					// var songData:ChartFile = Json.parse(Asset.chart(songFile.split(".")[0]));
					/*
						songs.push({
							name: songData.song,
							author: songData.meta.author,
							bpm: songData.bpm
					});*/
				}
			}
		}
		trace("Generated song" + songs);

		return macro $v{songs};
	}
}

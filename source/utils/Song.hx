package utils;

import haxe.Json;
import utils.Chart.ChartFile;
import openfl.Assets;

typedef SongMetadata =
{
	name:String,
	author:String,
	bpm:Int,
	?downloaded:Bool,
}

typedef OnlineSongManifest =
{
	songs:Array<SongMetadata>
}

class Song
{
    public static function metaFromChart(path:String):SongMetadata
    {
        if (!Assets.exists(path))
            return null;

        var chart:ChartFile = Json.parse(Assets.getText(path));
        // var versionStuff:Array<String> = chart.chartVersion.split("_"); // 0 is the actual version, 1 should be other stuff
        if (chart.meta == null)
        {
            chart.meta = 
            {
                author: "Unknown"
            }
        }

		var meta:SongMetadata = 
        {
            name: chart.song,
            author: chart.meta.author,
            bpm: chart.bpm
        };

        return meta;
    }

	public static function isValidSongPath(song:String, library:String):Bool
    {
		var songFilePath:String = 'assets/songs/$library/$song/$song';
        return (Assets.exists('$songFilePath.json') && Assets.exists('$songFilePath${Asset.AUDIO_EXT}'));
    }
}
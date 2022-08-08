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

        var chart:ChartFile = Json.parse(path);
        // var versionStuff:Array<String> = chart.chartVersion.split("_"); // 0 is the actual version, 1 should be other stuff

		var meta:SongMetadata = 
        {
            name: chart.song,
            author: chart.meta.author,
            bpm: chart.bpm
        };

        return meta;
    }
}
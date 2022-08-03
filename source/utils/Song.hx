package utils;

import haxe.Json;
import editor.ChartEditor.ChartFile;
import openfl.Assets;

typedef SongMetadata =
{
	name:String,
	author:String,
	bpm:Int,
	?downloaded:Bool,
}

class Song
{
    public static function metaFromChart(path:String):SongMetadata
    {
        if (!Assets.exists(path))
            return null;

        var chart:ChartFile = Json.parse(path);
		var meta:SongMetadata = 
        {
            name: chart.song,
            author: chart.meta.author,
            bpm: chart.bpm
        };

        return meta;
    }
}
package utils;

import openfl.Assets;

class Asset 
{
    public static var AUDIO_EXT:String = #if desktop ".ogg" #else ".mp3" #end;

    public static inline function music(filename:String):String
    {
        return "assets/music/test" + AUDIO_EXT;
    }

    public static inline function chart(song:String):String
    {
        return 'assets/data/charts/${song.toLowerCase()}.json';
    }
}
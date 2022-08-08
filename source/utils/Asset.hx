package utils;

import openfl.media.Sound;
import openfl.Assets;

class Asset 
{
    public static var AUDIO_EXT:String = #if desktop ".ogg" #else ".mp3" #end;

    // Globals
    public static var SND_UI_SELECT:String = Asset.sound("uiSelect");
    public static var SND_UI_CONFIRM:String = Asset.sound("uiConfirm");

    public static inline function image(filename:String):String
    {
        return 'assets/images/$filename.png';
    }

    public static inline function music(filename:String):String
    {
        return 'assets/music/$filename$AUDIO_EXT';
    }

    public static inline function sound(filename:String):String
    {
        return 'assets/sounds/$filename$AUDIO_EXT';
    }

    public static inline function chart(song:String, library:String = "base"):String
    {
        //return 'assets/data/charts/${song.toLowerCase()}.json';
        return 'assets/songs/$library/$song/$song.json';
    }

    public static inline function song(song:String, library:String = "base"):String
    {
        return 'assets/songs/$library/$song/$song$AUDIO_EXT';
    }

    public static inline function font(font:String, ?ext:String = ".ttf"):String
    {
        return 'assets/fonts/$font$ext';
    }

    public static function cacheSound(file:Dynamic):Bool
    {
		var val:Bool = false;

		if (Assets.exists(file, SOUND) || Assets.exists(file, MUSIC))
		{
			Assets.getSound(file, true);
			val = true;
		}

		return val;
    }
}
package utils.net;

import haxe.Json;
import haxe.Http;

typedef SongManifest =
{
    songs:Array<String>
}

class OnlineSong
{
    static var defaultSongUrl:String = "https://raw.githubusercontent.com/ACrazyTown/haxejamsummer22/main/online";
    static var songUrl:String = "";

    public static function getSongList():Array<String>
    {
        var songs:Array<String> = [];
		var http:Http = new Http('$defaultSongUrl/manifest.json');

        http.onData = (msg:String) -> {
            var data:SongManifest = Json.parse(msg);
            songs = data.songs;
        }

        return songs;
    }
}
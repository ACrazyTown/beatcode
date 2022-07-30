package utils.net;

import haxe.Http;

class Network
{
    public static var connected:Bool = false;

    public static function isConnected(?testURL:String = "https://google.com"):Bool
    {
        var hreq:Http = new Http(testURL);
        hreq.onError = (msg:String) -> {
            connected = false;
        }

        hreq.onData = (msg:String) -> {
            connected = true;
        }

        return connected;
    }
}
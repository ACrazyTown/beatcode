package props;

import flixel.util.FlxColor;
import flixel.FlxSprite;

class Note extends FlxSprite
{
    public var songTime:Float = 0;

    public function new(songTime:Float = 0)
    {
        super(-5000, 0);
        makeGraphic(16, 16);

        this.songTime = songTime;
    }
}
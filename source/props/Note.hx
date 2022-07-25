package props;

import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Note extends FlxSprite
{
    public var songTime:Float = 0;

    public function new(songTime:Float = 0, inCharter:Bool = false)
    {
        super(-5000, 0);

        makeGraphic(24, 24);
        color = inCharter ? FlxColor.RED : FlxG.random.color();

        this.songTime = songTime;
    }
}
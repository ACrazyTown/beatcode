package props;

import utils.Conductor;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;

class Note extends FlxSprite
{
    public var songTime:Float = 0;

    public var canHit:Bool = false;
    public var hit:Bool = false;
    public var late:Bool = false;

    public var countedMiss:Bool = false;

    public var inCharter:Bool = false;

    public function new(songTime:Float = 0, inCharter:Bool = false)
    {
        super(-5000, 0);

        makeGraphic(24, 24);
		this.inCharter = inCharter;
        color = inCharter ? FlxColor.RED : FlxG.random.color();

        this.songTime = songTime;
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (!inCharter)
        {
            if (songTime > Conductor.songPosition - Conductor.safeZoneOffset)
            {
                if (songTime < Conductor.songPosition + (Conductor.safeZoneOffset * 1.25))
                    canHit = true;
            }
            else
            {
                canHit = false;
                late = true;
            }

            if (late)
            {
                if (alpha != 0.4)
                    alpha = 0.4;
                if (color != FlxColor.GRAY)
                    color = FlxColor.GRAY;
            }
        }
    }
}

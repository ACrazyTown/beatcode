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

    public function new(songTime:Float = 0, inCharter:Bool = false)
    {
        super(-5000, 0);

        makeGraphic(24, 24);
        color = inCharter ? FlxColor.RED : FlxG.random.color();

        this.songTime = songTime;
    }

    var late:Bool = false;
    override function update(elapsed:Float):Void
    {
        super.update(elapsed);

        if (late && color != FlxColor.GRAY)
            color = FlxColor.GRAY;

		if (songTime < Conductor.songPosition - Conductor.safeZoneOffset && !hit)
			late = true;

        if (songTime > Conductor.songPosition - Conductor.safeZoneOffset 
            && songTime < Conductor.songPosition + (Conductor.safeZoneOffset * 0.5))
            canHit = true;
        else
            canHit = false;
    }
}
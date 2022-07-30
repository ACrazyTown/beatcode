package props;

import flixel.FlxG;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import utils.Conductor;

class Note extends FlxSprite
{
	private var colors:Array<FlxColor> = [
		0xfff75e5e, 0xfff7a05e, 0xfff7f75e, 0xffa0f75e, 0xff5ef77d, 
        0xff5ef7ef, 0xff5ea3f7, 0xff5e61f7, 0xffbc5ef7, 0xfff75edb
	];

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
		color = inCharter ? FlxColor.RED : FlxG.random.getObject(colors);

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

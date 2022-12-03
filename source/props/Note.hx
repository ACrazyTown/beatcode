package props;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.group.FlxSpriteGroup;
import flixel.input.keyboard.FlxKey;
import flixel.util.FlxColor;
import utils.Conductor;

class Note extends FlxSpriteGroup
{
	public var noteSprite:FlxSprite;
	public var keyText:FlxText;
	
	private var colors:Array<FlxColor> = [
		0xfff75e5e, 0xfff7a05e, 0xfff7f75e, 0xffa0f75e, 0xff5ef77d,
		0xff5ef7ef, 0xff5ea3f7, 0xff5e61f7, 0xffbc5ef7, 0xfff75edb
	];

	public var validKeys:Array<FlxKey> = [Q, W, E, R, T, Z, U, I, O, P, A, S, D, F, G, H, J, K, L, Y, X, C, V, B, N, M];

	public var songTime:Float = 0;

	public var canHit:Bool = false;
	public var hit:Bool = false;
	public var late:Bool = false;
	public var countedMiss:Bool = false;

	public var inCharter:Bool = false;

	public var assignedKey:FlxKey = FlxKey.NONE;

	public function new(songTime:Float = 0, inCharter:Bool = false)
	{
		super(-5000, 0);
		
		this.songTime = songTime;
		this.inCharter = inCharter;

		if (!inCharter)
			assignKey();

		noteSprite = new FlxSprite(0, 0).makeGraphic(24, 24);
		noteSprite.color = inCharter ? FlxColor.RED : FlxG.random.getObject(colors);
		add(noteSprite);

		keyText = new FlxText(0, 0, 0, assignedKey.toString(), 18);
		keyText.setBorderStyle(OUTLINE, FlxColor.BLACK, 1);
		keyText.x = (noteSprite.width - keyText.width) / 2;
		keyText.y = (noteSprite.height - keyText.height) / 2;
		add(keyText);
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

	override function destroy():Void
	{
		colors = null;
		validKeys = null;
		super.destroy();
	}

	public inline function assignKey():Void
	{
		assignedKey = FlxG.random.getObject(validKeys);
	}
}

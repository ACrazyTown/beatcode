package props;

import flixel.FlxG;
import flixel.addons.display.FlxGridOverlay;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.system.FlxAssets.FlxGraphicAsset;
import flixel.group.FlxSpriteGroup;

class ScrollBackground extends FlxSpriteGroup
{
	public var background:FlxSprite;
	public var gridBackground:FlxSprite;

	public function new(bgWidth:Int = 0, bgHeight:Int = 0, bgColor:FlxColor = FlxColor.BLACK, gridWidth:Int = 10, gridHeight:Int = 10, gridColor:FlxColor = FlxColor.WHITE)
	{
		super();

		background = new FlxSprite().makeGraphic(bgWidth, bgHeight, bgColor);
		background.active = false;
		add(background);

		gridBackground = FlxGridOverlay.create(gridWidth, gridHeight, FlxG.width, FlxG.height, true, gridColor, FlxColor.TRANSPARENT);
		gridBackground.setGraphicSize(Std.int(gridBackground.width * 2), Std.int(gridBackground.height * 2));
		gridBackground.updateHitbox();
		gridBackground.setPosition(-640, -360);
		//gridBackground.blend = SCREEN;
		gridBackground.alpha = 0.35;
		gridBackground.active = false;
		add(gridBackground);
	}

	override function update(elapsed:Float):Void
	{
		gridBackground.x += 1 / 3;
		gridBackground.y += 1 / 3;

		if (gridBackground.y > 0 || gridBackground.x > 0)
			gridBackground.setPosition(-640, -360);

		super.update(elapsed);
	}
}
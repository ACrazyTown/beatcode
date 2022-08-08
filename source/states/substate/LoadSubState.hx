package states.substate;

import flixel.text.FlxText;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.FlxSubState;

class LoadSubState extends FlxSubState
{
    public function new()
    {
        super();

        var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        overlay.alpha = 0.6;
        add(overlay);

        var loadingText:FlxText = new FlxText(0, 0, 0, "Loading...", 32);
		loadingText.setPosition((FlxG.width - loadingText.width) - 5, (FlxG.height - loadingText.height) - 5);
        add(loadingText);
    }
}
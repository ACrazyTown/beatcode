package states;

import flixel.text.FlxText;
import lime.graphics.ImageBuffer;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import utils.Asset;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import props.DotText;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import utils.Rating;
import flixel.FlxSubState;

class GameOverSubState extends FlxSubState
{
    var ps:PlayState;

    var nerdShit:Array<String> = [
        "Analyzing",
        "Compiling",
        "Inquiring",
        "Building",
        "Waiting",
        "Loading",
        "Interpreting",
        "Retrieving",
        "Crying"
    ];

	var dTxt:DotText;

    public function new()
    {
        super();

        ps = PlayState.instance;
        if (FlxG.sound.music != null && FlxG.sound.music.playing)
        {
            FlxG.sound.music.stop();
            FlxG.sound.music.volume = 1;
        }


        FlxG.sound.play(Asset.sound("enter"), 0.8);

        var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(overlay);

        dTxt = new DotText(10, 15, 0, FlxG.random.getObject(nerdShit), 24);
        dTxt.updateTime = 0.25;
        dTxt.font = "Modern DOS 8x16";
        dTxt.antialiasing = false;
        add(dTxt);

        FlxG.sound.playMusic(Asset.sound("beepboop"), 0.65, false);

        trace(FlxG.sound.music.length);

		var bruh:Float = (FlxG.sound.music.length / 4) - FlxG.random.int(256, 1024);
        new FlxTimer().start(bruh / 1000, function(_:FlxTimer)
        {
            trace("bruh");
            FlxG.sound.music.stop();
            createUI();
        });
    }

    function createUI():Void
    {
        remove(dTxt);

        FlxG.sound.play(Asset.sound("boo_womp"), 0.8);

        var passed:Bool = (ps.bugs <= 0);
        var resTxt:FlxText = new FlxText(dTxt.x, dTxt.y, 0, passed ? "Compiled successfully!" : "ERROR: Song failed!", dTxt.size);
        resTxt.font = "Modern DOS 8x16";
		resTxt.color = passed ? 0xFF96FFAD : 0xFFFF9D96;
        resTxt.antialiasing = false;
        add(resTxt);

        FlxTween.tween(resTxt, {
            x: ((FlxG.width - resTxt.width) / 2) + 120,
            y: ((FlxG.height - resTxt.height) / 2) - 240,
            angle: 2.5,
            size: dTxt.size * 2
        }, 1.5, {ease: FlxEase.quadInOut});
    }

    override function update(elapsed:Float):Void
    {

        super.update(elapsed);
    }
}
package states;

import flixel.tweens.FlxTween;
import flixel.FlxG;
import utils.Asset;
import flixel.util.FlxColor;
import flixel.FlxSprite;
import flixel.text.FlxText;
import flixel.FlxSubState;

class TutorialSubState extends FlxSubState
{
    var curEvent:Int = 0;

    var texts:Array<String> = [
        "Welcome to beatcode!",
        "This game is a bit different than\nother rhythm games, so it might be\nbest to have a tutorial!\n",
        "The point of the game is to get rid of all the bugs\n(Shown by the counter below)\n",
        "To get rid of them, you must hit Good or Amazing notes.",
        "Hitting or missing bad notes increases the bug amount by 0.25"
    ];
    
	var overlay:FlxSprite;
    var mainText:FlxText;

    var ending:Bool = false;

    public function new():Void
    {
        super();

        overlay = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        overlay.alpha = 0.75;
        add(overlay);

        mainText = new FlxText(0, 0, 0, "this is an error...", 24);
        mainText.alignment = CENTER;
        mainText.screenCenter();
        add(mainText);

        changeCurEvent();
    }

    override function update(elapsed:Float):Void
    {
        if (!ending)
        {
            if (FlxG.keys.justPressed.ANY)
                changeCurEvent(1);
        }

        super.update(elapsed);
    }

    function changeCurEvent(change:Int = 0):Void
    {
        if (arrow != null)
            remove(arrow);

        curEvent += change;

        if (curEvent < 0)
            curEvent = texts.length - 1;
        if (curEvent > texts.length - 1)
            endTutorial();

        executeEvent();
    }
    
    var arrow:FlxSprite;
    function executeEvent():Void
    {
        mainText.text = texts[curEvent];
        mainText.screenCenter();

        // custom events
        switch (curEvent)
        {
            case 2:
                arrow = new FlxSprite().loadGraphic(Asset.image("tutorialArrow"));
                arrow.color = FlxColor.RED;
                arrow.angle = 90;
                arrow.setGraphicSize(Std.int(arrow.width * 0.8));
                arrow.updateHitbox();
				arrow.screenCenter();
				arrow.y += 165;
                add(arrow);
        }
    }

    function endTutorial():Void
    {
        ending = true;

        if (mainText != null && members.contains(mainText))
        {
            remove(mainText);
            mainText.destroy();
        }

        FlxTween.tween(overlay, {alpha: 0}, 1, {onComplete: function(_:FlxTween)
        {
            close();
        }});
    }
}
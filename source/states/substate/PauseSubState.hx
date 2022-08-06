package states.substate;

import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.text.FlxTypeText;
import flixel.text.FlxText;
import utils.Asset;
import flixel.util.FlxColor;
import flixel.FlxG;
import flixel.FlxSprite;
import flixel.FlxSubState;

class PauseSubState extends FlxSubState
{
    var options:Array<String> = ["Resume", "Restart Song", "Exit to Menu"];
    var optionsGroup:FlxTypedGroup<FlxText>;

    var curSelected:Int = 0;

    public function new():Void
    {
        super();
        trace("hi from puase");

        if (FlxG.sound.music != null && FlxG.sound.music.playing)
            FlxG.sound.music.pause();
    
        var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        overlay.alpha = 0.7;
        add(overlay);

        var cover:FlxSprite = new FlxSprite().loadGraphic(Asset.image("cover"));
        add(cover);

        var pausedTxt:FlxText = new FlxText(50, 100, 0, "PAUSED", 64);
        add(pausedTxt);

        optionsGroup = new FlxTypedGroup<FlxText>();
        add(optionsGroup);

        for (i in 0...options.length)
        {
            var text:FlxText = new FlxText(pausedTxt.x + (i * 60), i * 120, 0, options[i], 36);
            text.x += 50;
            text.y += (pausedTxt.y + pausedTxt.height) + 130;
            text.ID = i;
            optionsGroup.add(text);
        }

        changeSelection();
    }

    override function update(elapsed:Float):Void
    {
        if (FlxG.keys.justPressed.UP)
            changeSelection(-1);
        if (FlxG.keys.justPressed.DOWN)
            changeSelection(1);
        if (FlxG.keys.justPressed.ENTER)
            accept();
        
        super.update(elapsed);
    }

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        if (curSelected > options.length - 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = options.length - 1;

        optionsGroup.forEach(function(t:FlxText)
        {
            t.color = FlxColor.WHITE;

            if (t.ID == curSelected)
                t.color = FlxColor.YELLOW;
        });
    }

    function accept():Void
    {
        switch (curSelected)
        {
            case 0:
				if (FlxG.sound.music != null && FlxG.sound.music.playing)
                    FlxG.sound.music.play();
                close();
            case 1: 
                FlxG.resetState();
            case 2: 
                FlxG.switchState(new TitleState());
        }
    }
}
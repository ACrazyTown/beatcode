package states;

import flixel.text.FlxText;
import flixel.FlxSubState;

class TutorialSubState extends FlxSubState
{
    var curEvent:Int = 0;

    var texts:Array<String> = [
        "Welcome to beatcode!",
        "This game is a bit different than\nother rhythm games, so it might be\nbest to have a tutorial!\n",
    ];
    
    var mainText:FlxText;

    public function new():Void
    {
        super();

        mainText = new FlxText(0, 0, 0, "this is an error...", 24);
        mainText.screenCenter();
        add(mainText);

        changeCurEvent();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }

    function changeCurEvent(change:Int = 0):Void
    {
        curEvent += change;

        if (curEvent < 0)
            curEvent = texts.length - 1;
        if (curEvent > texts.length - 1)
            curEvent = 0;

        executeEvent();
    }
    
    function executeEvent():Void
    {
        mainText.text = texts[curEvent];
        mainText.screenCenter();
    }
}
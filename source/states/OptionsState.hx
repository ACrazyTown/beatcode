package states;

import flixel.addons.transition.FlxTransitionableState;
import flixel.FlxG;
import flixel.FlxState;

typedef OptionData =
{
    name:String,
    property:Dynamic
}

class OptionsState extends FlxTransitionableState
{
    var options:Array<OptionData> = [
        {name: "sus", property: FlxG}
    ];

    override function create():Void
    {
        super.create();
    }

    override function update(elapsed:Float):Void
    {
        super.update(elapsed);
    }
}
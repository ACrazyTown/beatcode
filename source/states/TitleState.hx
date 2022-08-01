package states;

import flixel.math.FlxRect;
import flixel.math.FlxPoint;
import flixel.graphics.FlxGraphic;
import flixel.addons.transition.FlxTransitionSprite.GraphicTransTileDiamond;
import flixel.addons.transition.TransitionData;
import flixel.addons.transition.FlxTransitionableState;
import utils.Game;
import props.ScrollBackground;
import lime.app.Application;
import flixel.FlxG;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import utils.Asset;
import flixel.FlxSprite;
import flixel.FlxState;

class TitleState extends FlxTransitionableState
{
    var optionGroup:FlxTypedGroup<FlxText>;
    var options:Array<String> = #if !debug ["Campaign", "Freeplay", "Options"] #else ["Freeplay"] #end;
    var curSelected:Int = 0;

	var logo:FlxSprite;

    var versionText:FlxText;

    override function create():Void
    {
        #if FLX_MOUSE
        if (FlxG.mouse.visible)
            FlxG.mouse.visible = false;
        #end

        if (!Game.initTransition)
        {
			var diamond:FlxGraphic = FlxGraphic.fromClass(GraphicTransTileDiamond);
			diamond.persist = true;

			FlxTransitionableState.defaultTransIn = new TransitionData(FADE, FlxColor.BLACK, 0.7, new FlxPoint(0, -1), {asset: diamond, width: 32, height: 32},
				new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));
			FlxTransitionableState.defaultTransOut = new TransitionData(FADE, FlxColor.BLACK, 0.4, new FlxPoint(0, 1),
				{asset: diamond, width: 32, height: 32}, new FlxRect(-200, -200, FlxG.width * 1.4, FlxG.height * 1.4));

			transIn = FlxTransitionableState.defaultTransIn;
			transOut = FlxTransitionableState.defaultTransOut;
        }

		var bg:ScrollBackground = new ScrollBackground(FlxG.width, FlxG.height, 0xFF163a82, 15, 15, 0xFF3ea6cf);
        add(bg);

        var overlay:FlxSprite = new FlxSprite().loadGraphic(Asset.image("titleOverlay"));
        add(overlay);

        logo = new FlxSprite(57, 55).loadGraphic(Asset.image("logoGame"));
        add(logo);

        optionGroup = new FlxTypedGroup<FlxText>();
        add(optionGroup);

        for (i in 0...options.length)
        {
            var text:FlxText = new FlxText(110 + (i * 60), (i * 90), 0, options[i], 24);
            text.ID = i;
            //text.font = "Modern DOS 8x16";
            text.y += 360;
            optionGroup.add(text);
        }

        versionText = new FlxText(0, 0, 0, Application.current.meta.get("version") + " | by A Crazy Town", 16);
        versionText.setPosition(5, (FlxG.height - versionText.height) - 5);
        //versionText.font = "FORCED SQUARE";
        add(versionText);

        changeSelection();
        super.create();
    }

    var sine:Float = 0;
    override function update(elapsed:Float):Void
    {
        sine += 0.09;

        if (FlxG.keys.justPressed.UP)
            changeSelection(-1);
        if (FlxG.keys.justPressed.DOWN)
            changeSelection(1);
        if (FlxG.keys.justPressed.ENTER)
            accept();

        logo.y += Math.sin(sine);

        super.update(elapsed);
    }

    function accept():Void
    {
        switch (options[curSelected])
        {
			case "Campaign": FlxG.switchState(new PlayState("Tutorial"));
            case "Freeplay": FlxG.switchState(new FreeplayState());
        }
    }

    function changeSelection(change:Int = 0):Void
    {
        curSelected += change;

        if (curSelected < 0)
            curSelected = options.length - 1;
        if (curSelected > options.length - 1)
            curSelected = 0;

        optionGroup.forEach(function(t:FlxText)
        {
            t.color = FlxColor.WHITE;

            if (t.ID == curSelected)
                t.color = FlxColor.YELLOW;
        });
    }
}
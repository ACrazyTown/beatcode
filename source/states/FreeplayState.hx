package states;

import flixel.input.actions.FlxAction;
import utils.Game;
import props.ui.ScrollBackground;
import utils.Asset;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.addons.transition.FlxTransitionableState;

class FreeplayState extends FlxTransitionableState
{
    /*
            {
            name: "Tutorial",
            author: "A Crazy Town",
            bpm: 140
        },
		{
			name: "Syntax",
			author: "DespawnedDiamond",
			bpm: 125
		}
    */

    var categories:Array<FreeplayCategory> = [
        {
            name: "Base Game",
            id: "base",
            contents: Game.songs,
            autoExpand: true,
            showFolder: false,
        },
        {
            name: "Community Creations",
            id: "communityc",
            contents: [],
            autoExpand: false,
            showFolder: false,
        }
    ];
    var songTextGroup:FlxTypedGroup<FlxText>;

    var curSelected:Int = 0;

    override function create():Void
    {
		var bg:ScrollBackground = new ScrollBackground(FlxG.width, FlxG.height, 0xFF163a82, 15, 15, 0xFF3ea6cf);
		add(bg);

		var overlay:FlxSprite = new FlxSprite().loadGraphic(Asset.image("titleOverlay"));
		add(overlay);

        songTextGroup = new FlxTypedGroup<FlxText>();
        add(songTextGroup);

        /*
        for (i in 0...songs.length)
        {
            var text:FlxText = new FlxText(40, i * 90, 0, songs[i].name, 32);
            text.y += 40;
            text.ID = i;
            songTextGroup.add(text);
        }*/


        changeSelection();
        super.create();
    }

    override function update(elapsed:Float):Void
    {
        #if debug
        if (FlxG.keys.justPressed.ONE)
            FlxG.switchState(new PlayState("tutorial"));
        #end

        if (FlxG.keys.justPressed.ESCAPE)
            FlxG.switchState(new TitleState());
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
        /*
        curSelected += change;

        if (curSelected > songs.length - 1)
            curSelected = 0;
        if (curSelected < 0)
            curSelected = songs.length - 1;

        songTextGroup.forEach(function(t:FlxText)
        {
            t.color = FlxColor.WHITE;
            t.text = songs[t.ID].name;

            if (t.ID == curSelected) 
            {
                t.color = FlxColor.YELLOW;
                t.text = '> ${songs[t.ID].name}';
            }
        });
        */
    }

    function accept():Void
    {
        //FlxG.switchState(new PlayState(songs[curSelected].name));
    }
}

typedef FreeplayCategory =
{
    name:String,
    id:String,
    contents:Array<SongMetadata>,
    autoExpand:Bool,
    showFolder:Bool,
    ?url:String
}

typedef SongMetadata =
{
    name:String,
    author:String,
    bpm:Int,
    ?downloaded:Bool,
}
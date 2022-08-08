package states;

import utils.Song.SongMetadata;
import openfl.Assets;
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
            contents: Game.songs
        },
        {
            name: "Community Creations",
            id: "communityc",
            contents: []
        }
    ];
    
    var categoryTextGroup:FlxTypedGroup<FlxText>;
    var songTextGroup:FlxTypedGroup<FlxText>;

    var curCategory:Int = 0;
    var curSelected:Int = 0;
    var isInCategory:Bool = false;

    override function create():Void
    {
		var bg:ScrollBackground = new ScrollBackground(FlxG.width, FlxG.height, 0xFF163a82, 15, 15, 0xFF3ea6cf);
		add(bg);

		var overlay:FlxSprite = new FlxSprite().loadGraphic(Asset.image("titleOverlay"));
		add(overlay);

        categoryTextGroup = new FlxTypedGroup<FlxText>();
        add(categoryTextGroup);

        songTextGroup = new FlxTypedGroup<FlxText>();
        add(songTextGroup);

        createText(null, true);

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
        {
            if (isInCategory)
                createText(null, true);
            else
                FlxG.switchState(new TitleState());
        }
        if (FlxG.keys.justPressed.UP)
            changeSelection(-1);
        if (FlxG.keys.justPressed.DOWN)
            changeSelection(1);
        if (FlxG.keys.justPressed.ENTER)
            accept();

        super.update(elapsed);
    }

	function createText(?categoryId:String, ?category:Bool = false):Void
    {
        category ? songTextGroup.clear() : categoryTextGroup.clear();
        var group:FlxTypedGroup<FlxText> = category ? categoryTextGroup : songTextGroup;

        for (i in 0...categories.length) 
        {
            if (!category)
            {
                if (categories[i].id != categoryId)
                    continue;

                for (j in 0...categories[i].contents.length)
                {
					var text:FlxText = new FlxText(40, 40 + (j * 90), 0, categories[i].contents[j].name, 32);
                    text.ID = j;
                    songTextGroup.add(text);
                }

                isInCategory = true;
                changeSelection();
            }
            else
            {
                var text:FlxText = new FlxText(40, 40 + (i * 90), 0, categories[i].name, 32);
                text.ID = i;

                if (categories[i].contents.length <= 0)
                {
                    text.color = FlxColor.GRAY;
                    text.italic = true;
                }

                categoryTextGroup.add(text);
				isInCategory = false;
                changeSelection();
            }
        }
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

        /*
		var index:Int = isInCategory ? curSelected : curCategory;
		var group:FlxTypedGroup<FlxText> = isInCategory ? songTextGroup: categoryTextGroup;
		var array:Array<Dynamic> = isInCategory ? categories[curCategory].contents : categories;

        index += change;

        if (index > array.length - 1)
            index = 0;
        if (index < 0)
            index = array.length - 1;

        group.forEach(function(t:FlxText)
        {
            t.color = FlxColor.WHITE;

            if (t.ID == index)
            {
                if (!t.italic)
                    t.color = FlxColor.YELLOW;
            }
        });
        */

        if (change != 0)
            FlxG.sound.play(Asset.SND_UI_SELECT, 0.7);

        if (!isInCategory)
        {
            curCategory += change;

            if (curCategory > categories.length - 1)
                curCategory = 0;
            if (curCategory < 0)
                curCategory = categories.length - 1;

            categoryTextGroup.forEach(function(t:FlxText)
            {
                t.color = FlxColor.WHITE;

                if (t.ID == curCategory)
                    t.color = FlxColor.YELLOW;
            });
        }
        else
        {
            var cat:FreeplayCategory = categories[curCategory];

            curSelected += change;

            if (curSelected > cat.contents.length - 1)
                curSelected = 0;
            if (curSelected < 0)
                curSelected = cat.contents.length - 1;

            songTextGroup.forEach(function(t:FlxText)
            {
				t.color = FlxColor.WHITE;

				if (t.ID == curSelected)
					t.color = FlxColor.YELLOW;
            });
        }
    }

    function accept():Void
    {
        FlxG.sound.play(Asset.SND_UI_CONFIRM, 0.7);

        if (isInCategory)
        {
            // Online songs must check for download!!!
            FlxG.switchState(new PlayState(categories[curCategory].contents[curSelected].name));
        }
        else
        {
            var cat:FreeplayCategory = categories[curCategory];

            if (cat.id == "communityc" && cat.contents.length <= 0 
                && !Globals.gotOnlineCCList) 
                cat.contents = Game.getCommunitySongs();

            if (cat != null && cat.contents.length > 0)
                createText(cat.id);
        }
    }
}

typedef FreeplayCategory =
{
    name:String,
    id:String,
    contents:Array<SongMetadata>,
    ?url:String
}
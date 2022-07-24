package editor;

import utils.Util;
import flixel.math.FlxMath;
import flixel.FlxObject;
import utils.Asset;
import haxe.Json;
import flixel.ui.FlxButton;
import utils.Conductor;
import flixel.addons.ui.FlxUIText;
import flixel.addons.ui.FlxUI;
import flixel.addons.ui.FlxUIInputText;
import flixel.addons.ui.FlxUINumericStepper;
import flixel.addons.ui.FlxUITabMenu;
import flixel.util.FlxColor;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.text.FlxText;
import states.BeatState;

using StringTools;

typedef ChartFile = 
{
    song:String,
    bpm:Int,
    speed:Float,
    noteTimes:Array<Float>,
    chartVersion:String
}

class ChartEditor extends BeatState
{
    var CHART:ChartFile;

    var tabMenu:FlxUITabMenu;
    var songGroup:FlxUI;

    var songName:FlxUIInputText;

    var gridSize:Int = 48;
	var gridColors:Array<FlxColor> = [0xFFE7E6E6, 0xFFD9D5D5];
    var sectionSize:Int = 16;

    var strumline:FlxSprite;
	var infoTxt:FlxText;
    var songStuffText:FlxText;
    var griddy:FlxTypedGroup<FlxSprite>;

    public function new(chart:ChartFile)
    {
        if (chart == null)
        {
            this.CHART = 
            {
                song: "Test",
                bpm: 140,
                speed: 1,
				noteTimes: [
					0, 439, 859, 1299, 1719, 2159, 2579, 3019, 3439, 3859, 4319, 4719, 5159, 5579, 6019, 6439
				],
                chartVersion: "0.1_haxejam"
            }
        }
        else
            this.CHART = chart;

        super();
    }

    override function create():Void
    {
        trace("hello from chartering");
		loadSong(CHART.song);

        var tabs = [
            {name: "Song", label: "Song"}
        ];
        tabMenu = new FlxUITabMenu(null, tabs, true);
        tabMenu.resize(200, 200);
		tabMenu.setPosition((FlxG.width - tabMenu.width) - 75, 130);
        add(tabMenu);

        createSongUI();

        infoTxt = new FlxText(0, 0, 0, 'curStep: $curStep\ncurBeat: $curBeat\nTime: 0\n', 18);
        infoTxt.setPosition((FlxG.width - infoTxt.width) - 50, 5);
        add(infoTxt);

        songStuffText = new FlxText(0, 0, 0, 'Song: ${CHART.song}\nBPM: ${CHART.bpm}\nSpeed: ${CHART.speed}\n', 18);
        songStuffText.setPosition((infoTxt.x - songStuffText.width) - 5, 5);
        add(songStuffText);

		griddy = new FlxTypedGroup<FlxSprite>();
		add(griddy);

        createGrid();

		strumline = new FlxSprite(120).makeGraphic(5, FlxG.height);
		strumline.alpha = 0.7;
		add(strumline);

        changeNote();
        renderNotes();
        super.create();
    }

    function createSongUI():Void
    {
        var songNameText:FlxUIText = new FlxUIText(10, 30, 0, "Song Name", 8);
        songName = new FlxUIInputText(10, 45, 96, CHART.song, 8);

        var bpmText:FlxUIText = new FlxUIText(10, 60, 0, "BPM", 8);
        var bpmStepper:FlxUINumericStepper = new FlxUINumericStepper(10, 75, 1, 120, 1, 999, 0);
        bpmStepper.value = Conductor.bpm;
        bpmStepper.name = "song_bpm";

        var speedText:FlxUIText = new FlxUIText(10, 90, 0, "Speed", 8);
        var speedStepper:FlxUINumericStepper = new FlxUINumericStepper(10, 105, 0.1, CHART.speed, 0.1, 10, 1);
        speedStepper.name = "song_speed";

        var saveButton:FlxButton = new FlxButton(0, 45, "Save", () -> 
        {
            FlxG.save.data.chartSave = Json.stringify(CHART);
            FlxG.save.flush();

            // file reference
        });
        saveButton.x = (tabMenu.width - saveButton.width) - 5;

        songGroup = new FlxUI(null, tabMenu);
        songGroup.name = "Song";

        songGroup.add(songNameText);
        songGroup.add(songName);
        songGroup.add(bpmText);
        songGroup.add(bpmStepper);
        songGroup.add(speedText);
        songGroup.add(speedStepper);
        songGroup.add(saveButton);

        tabMenu.add(songGroup);
    }

    override function update(elapsed:Float):Void
    {
        if (FlxG.keys.justPressed.LEFT)
            changeNote(-1);
        if (FlxG.keys.justPressed.RIGHT)
            changeNote(1);
        if (FlxG.keys.justPressed.SPACE)
            toggleMusic();

		if (FlxG.mouse.wheel != 0)
		{
			FlxG.sound.music.pause();
			FlxG.sound.music.time -= (FlxG.mouse.wheel * Conductor.stepCrochet * 0.4);
		}

        Conductor.songPosition = FlxG.sound.music.time;
		strumline.x = 120 + (((gridSize * sectionSize) / (FlxG.sound.music.length / Conductor.songPosition)) % Conductor.crochet * 4) % (gridSize * sectionSize);
        updateTexts();
        super.update(elapsed);
    }

    override function getEvent(id:String, sender:Dynamic, data:Dynamic, ?params:Array<Dynamic>):Void
    {
        if (id == FlxUINumericStepper.CHANGE_EVENT && (sender is FlxUINumericStepper))
        {
            var nums:FlxUINumericStepper = cast sender;
            var wname:String = nums.name;
            switch (wname)
            {
                case "song_bpm":
                    CHART.bpm = Std.int(nums.value);
                    Conductor.changeBPM(CHART.bpm);
                case "song_speed":
                    CHART.speed = nums.value;
            }
        }
    }

    var curSection:Int = 0;
    var curNoteIndex:Int = 0;
    function changeNote(change:Int = 0):Void
    {
        curNoteIndex += change;

        if (curNoteIndex < 0)
            curNoteIndex = sectionSize-1;
        if (curNoteIndex > sectionSize-1)
            curNoteIndex = 0;

        griddy.forEach((spr:FlxSprite) -> 
        {
            spr.alpha = 1;
            if (spr.ID == curNoteIndex)
                spr.alpha = 0.5;
        });
    }

    function changeSection(change:Int = 0):Void
    {
        curSection += change;

        if (curSection < 0)
            curSection = Math.ceil(CHART.noteTimes.length / sectionSize) - 1;
		if (curSection > Math.ceil(CHART.noteTimes.length / sectionSize) - 1)
            curSection = 0;

        curNoteIndex = 0;
        changeNote();

        renderNotes();
    }

    function renderNotes():Void
    {
        for (grid in griddy)
        {
            grid.kill();
            griddy.remove(grid);
            grid.destroy();
        }

        // TODO:
        // rework this tommorow
        // dont use this complicated format
        // seperate stuff into sections in the JSON
        // makes it easier to parse And breathe
        var sectionIndex:Int = (curSection + 1) * sectionSize;
        var bruhh:Array<Int> = Util.intArray(sectionIndex + 16, sectionIndex);
        var sectionData:Array<Float> = [];
        for (bruh in bruhh)
        {
            sectionData.push(CHART.noteTimes[bruh]);
        }

        trace(sectionData);
    }

    function loadSong(song:String):Void
    {
        if (FlxG.sound.music != null)
            FlxG.sound.music.stop();

        FlxG.sound.playMusic(Asset.music(song.toLowerCase()), 0.6, false);
        FlxG.sound.music.pause();
		FlxG.sound.music.onComplete = function()
		{
			FlxG.sound.music.pause();
			FlxG.sound.music.time = 0;
		};
        Conductor.changeBPM(CHART.bpm);
        trace("Loaded song!");
    }

    function toggleMusic():Void
    {
        FlxG.sound.music.playing ? FlxG.sound.music.pause() : FlxG.sound.music.play();
    }

    function updateTexts():Void
    {
        var time:Float = -1;
        if (FlxG.sound.music != null)
            time = FlxG.sound.music.time;
		infoTxt.text = 'curStep: $curStep\ncurBeat: $curBeat\nTime: ${time}ms\n';
		//infoTxt.x = (FlxG.width - infoTxt.width) - 5;
        
		songStuffText.text = 'Song: ${CHART.song}\nBPM: ${CHART.bpm}\nSpeed: ${CHART.speed}\n';
		//songStuffText.x = (infoTxt.x - songStuffText.width) - 5;
    }

    function createGrid():Void
    {
        for (i in 0...sectionSize)
        {
            var color:FlxColor = gridColors[1];
            if (i % 2 == 0) 
                color = gridColors[0];
            var grid:FlxSprite = new FlxSprite(i * gridSize, 0).makeGraphic(gridSize, gridSize, color);
            grid.screenCenter(Y);
            grid.x += 120;
            grid.ID = i;
            griddy.add(grid);
        }
    }
}
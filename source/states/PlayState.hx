package states;

import flixel.text.FlxText;
import haxe.Json;
import editor.ChartEditor.ChartFile;
import openfl.Assets;
import flixel.util.FlxTimer;
import props.Note;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import utils.Conductor;
import utils.Asset;
import flixel.FlxState;

/*
beat times
source/states/PlayState.hx:25: beat1 | time439
source/states/PlayState.hx:25: beat2 | time859
source/states/PlayState.hx:25: beat3 | time1299
source/states/PlayState.hx:25: beat4 | time1719
source/states/PlayState.hx:25: beat5 | time2159
source/states/PlayState.hx:25: beat6 | time2579
source/states/PlayState.hx:25: beat7 | time3019
source/states/PlayState.hx:25: beat8 | time3439
source/states/PlayState.hx:25: beat9 | time3859
source/states/PlayState.hx:25: beat10 | time4319
source/states/PlayState.hx:25: beat11 | time4719
source/states/PlayState.hx:25: beat12 | time5159
source/states/PlayState.hx:25: beat13 | time5579
source/states/PlayState.hx:25: beat14 | time6019
source/states/PlayState.hx:25: beat15 | time6439
*/

class PlayState extends BeatState
{
	var curSong:String = "Test";
	var speed:Float = 1;

	var strumline:FlxSprite;
	var notes:FlxTypedGroup<Note>;

	var score:Int = 0;

	var statsTxt:FlxText;

	public function new(?song:String):Void
	{
		if (song != null)
			curSong = song;
		super();
	}

	override public function create():Void
	{
		super.create();

		FlxG.fixedTimestep = false;

		strumline = new FlxSprite().makeGraphic(10, FlxG.height);
		strumline.x = (FlxG.width - strumline.width) - 75;
		strumline.alpha = 0.5;
		add(strumline);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		statsTxt = new FlxText(0, 0, 0, 'Score: $score', 18);
		statsTxt.y = (FlxG.height - statsTxt.height) - 5;
		statsTxt.screenCenter(X);
		add(statsTxt);

		loadSong(curSong);
		countdown();
	}

	override public function update(elapsed:Float):Void
	{
		// daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
		// ermm,,, clean up
		keyCheck();

		if (songStarting)
		{
			if (counting)
			{
				Conductor.songPosition += FlxG.elapsed * 1000;
				if (Conductor.songPosition >= 0)
					songStart();
			}
		}
		else
		{
			if (FlxG.sound.music != null && FlxG.sound.music.playing)
				Conductor.songPosition += FlxG.elapsed * 1000;
		}
		
		notes.forEachAlive(function(note:Note)
		{
			if ((FlxG.width + note.width) < note.x && note.isOnScreen(FlxG.camera))
			{
				note.kill();
				notes.remove(note);
				note.destroy();
			}

			note.x = (strumline.x + (Conductor.songPosition - note.songTime) * (0.4 * speed));
		});

		if (FlxG.keys.justPressed.R)
		{
			if (FlxG.sound.music.playing)
				FlxG.sound.music.stop();
			FlxG.resetState();
		}

		super.update(elapsed);
	}

	function keyCheck():Void
	{
		var press:Bool = FlxG.keys.justPressed.ANY;

		if (press)
		{
			var rand:Int = FlxG.random.int(0, 5);
			FlxG.sound.play(Asset.sound('hit$rand'), 0.6);
		}

		notes.forEach(function(note:Note)
		{
			if (note.canHit && !note.hit && press)
			{
				note.hit = true;

				note.kill();
				notes.remove(note);	
				note.destroy();
			}
		});
	}

	override function beatHit():Void 
	{
		trace('beat$curBeat | time${FlxG.sound.music.time}');
	}

	function songStart():Void
	{
		songStarting = false;
		Conductor.changeBPM(140);
		FlxG.sound.playMusic(Asset.music("test"), 1, false);
	}

	var counting:Bool = false;
	var songStarting:Bool = false;
	function countdown():Void
	{
		counting = true;
		songStarting = true;

		Conductor.songPosition = 0 - (Conductor.crochet * 5);

		var count:Int = 0;
		new FlxTimer().start(Conductor.crochet / 1000, function(_:FlxTimer)
		{
			trace(count);
			count++;
		}, 5);
	}

	function loadSong(song:String):Void
	{
		trace(song);
		var sd:ChartFile = Json.parse(Assets.getText(Asset.chart(song.toLowerCase())));

		curSong = sd.song;
		Conductor.changeBPM(sd.bpm);
		speed = sd.speed;

		for (section in sd.sections)
		{
			for (noteTime in section.noteTimes)
			{
				if (noteTime == -1)
					continue;

				var note:Note = new Note(noteTime);
				note.screenCenter(Y);
				notes.add(note);
			}
		}

		trace("Generated Song?");
	}

	function generateTest():Void
	{
		var times:Array<Int> = [0, 439, 859, 1299, 1719, 2159, 2579, 3019, 3439, 3859, 4319, 4719, 5159, 5579, 6019, 6439];
		for (time in times)
		{
			var note:Note = new Note(time);
			note.screenCenter(Y);
			notes.add(note);
		}
	}
}

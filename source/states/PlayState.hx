package states;

import flixel.FlxCamera;
import utils.Rating;
import utils.Util;
import flixel.math.FlxMath;
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

class PlayState extends BeatState
{
	var _chart:ChartFile;

	var curSong:String = "Tutorial";
	var difficulty:Int = 2;
	var speed:Float = 1;

	var strumline:FlxSprite;
	var notes:FlxTypedGroup<Note>;

	var rawBugs:Float = 0;
	var bugs:Int = 0;
	var score:Int = 0;
	var misses:Int = 0;
	// ratings
	public var ratingAmounts:Map<String, Int> = [
		"bad" => 0,
		"good" => 0,
		"amazing" => 0
	];
	//accuracy
	var totalNotes:Int = 0;
	var totalHit:Float = 0;
	var accuracy:Float = 0;

	var bugsTxt:FlxText;
	var statsTxt:FlxText;

	public static var instance:PlayState;

	public function new(?song:String):Void
	{
		if (song != null)
			curSong = song;
		super();
	}

	override public function create():Void
	{
		instance = this;

		var sooz:FlxSprite = new FlxSprite(0, 0, "assets/images/sooz.png");
		add(sooz);
		sooz.alpha = 0.5;

		//hud = new FlxCamera();
		//FlxG.cameras.add(hud, false);
		// use garagband track
		strumline = new FlxSprite().makeGraphic(10, FlxG.height);
		strumline.x = (FlxG.width - strumline.width) - 75;
		strumline.alpha = 0.5;
		add(strumline);

		loadSong(curSong);

		statsTxt = new FlxText(0, 0, 0, 'SCORE: $score ~ MISSES: $misses ~ ACCURACY: $accuracy', 20);
		statsTxt.font = "FORCED SQUARE";
		statsTxt.y = (FlxG.height - statsTxt.height) - 5;
		statsTxt.screenCenter(X);
		add(statsTxt);

		trace('this game will have $rawBugs BUGS!!!');
		rawBugs = Util.getBugAmount(difficulty, _chart);
		bugsTxt = new FlxText(0, 0, 0, 'BUGS: $bugs', 24);
		bugsTxt.color = 0xFFFF9D96;
		bugsTxt.font = "FORCED SQUARE";
		bugsTxt.y = (statsTxt.y - bugsTxt.height) - 5;
		bugsTxt.screenCenter(X);
		add(bugsTxt);

		//statsTxt.cameras = [hud];
		//bugsTxt.cameras = [hud];

		countdown();

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		// daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
		// ermm,,, clean up

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
			if (note.late && !note.hit && !note.countedMiss)
				noteMiss(note);

			if (note.x > (FlxG.width + note.width) && !note.isOnScreen(FlxG.camera))
			{
				note.kill();
				notes.remove(note);
				note.destroy();
			}

			note.x = (strumline.x + (Conductor.songPosition - note.songTime) * (0.4 * speed));
		});

		#if debug
		if (FlxG.keys.justPressed.R)
		{
			if (FlxG.sound.music != null && FlxG.sound.music.playing)
				FlxG.sound.music.stop();
			FlxG.resetState();
		}
		#end

		keyCheck();
		updateStats();
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
			if (press)
			{
				if (note.canHit && !note.hit && !note.late)
					noteHit(note);
			}
		});
	}

	function noteHit(note:Note):Void
	{
		note.hit = true;

		var rating:String = Rating.rate(Conductor.songPosition - note.songTime, note);
		var ra:Int = ratingAmounts.get(rating.toLowerCase());

		totalNotes++;

		switch (rating.toLowerCase())
		{
			//case "bad": totalHit += 0.33;
			case "bad":
				rawBugs += 0.1;
				ratingAmounts.set("bad", ra + 1);
				
				score += 75;
			case "good": 
				totalHit += 0.5;
				rawBugs--;
				ratingAmounts.set("good", ra + 1);

				score += 150;
			case "amazing": 
				totalHit++;
				rawBugs--;
				ratingAmounts.set("amazing", ra + 1);
				
				score += 225;
		}

		note.kill();
		notes.remove(note);
		note.destroy();
	}

	function noteMiss(note:Note):Void
	{
		note.countedMiss = true;
		misses++;

		totalNotes++;
		rawBugs += 0.1;

		FlxG.sound.play(Asset.sound("bruh"), 0.6);
	}

	function updateStats():Void
	{
		accuracy = FlxMath.roundDecimal((totalHit / totalNotes) * 100, 2);

		if (rawBugs <= 0)
			rawBugs = 0;

		bugs = Math.round(rawBugs);

		statsTxt.text = 'SCORE: $score ~ MISSES: $misses ~ ACCURACY: ${Math.isNaN(accuracy) ? "N/A" : Std.string(accuracy) + "%"}';
		statsTxt.screenCenter(X);
		bugsTxt.text = 'BUGS: $bugs';
		bugsTxt.color = (bugs < 1) ? 0xFF96C7FF : 0xFFFF9D96;
		bugsTxt.screenCenter(X);
	}

	function songStart():Void
	{
		songStarting = false;
		Conductor.changeBPM(140);
		FlxG.sound.playMusic(Asset.music(_chart.song.toLowerCase()), 1, false);
		FlxG.sound.music.onComplete = songEnd;
	}

	function songEnd():Void 
	{
		super.openSubState(new GameOverSubState());
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
		notes = new FlxTypedGroup<Note>();
		add(notes);

		_chart = Json.parse(Assets.getText(Asset.chart(song.toLowerCase())));

		curSong = _chart.song;
		Conductor.changeBPM(_chart.bpm);
		speed = _chart.speed;

		for (section in _chart.sections)
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
}

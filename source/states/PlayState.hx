package states;

import flixel.input.keyboard.FlxKey;
import flixel.graphics.frames.FlxFrame;
import utils.Game;
import flixel.FlxCamera;
import utils.Rating;
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

	public var campaignMode:Bool = true;

	var curSong:String = "Tutorial";
	var difficulty:Int = 2;
	var speed:Float = 1;

	public var bg:FlxSprite;
	var strumline:FlxSprite;
	var notes:FlxTypedGroup<Note>;

	var rawBugs:Float = 0;
	public var bugs:Int = 0;
	
	public var bestCombo:Int = 0;
	public var combo:Int = 0;
	public var score:Int = 0;
	public var misses:Int = 0;

	//accuracy
	public var noteAmount:Int = 0; // used for ranking, represents amounts of notes in the song
	var totalNotes:Int = 0;
	var totalHit:Float = 0;
	public var accuracy:Float = 0;

	var bugsTxt:FlxText;
	var statsTxt:FlxText;

	// If it's (almost) impossible to beat a song, this will grant extra bugfixes
	var desperate:Bool = false;

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

		bg = new FlxSprite(0, 0, "assets/images/sooz.png");
		add(bg);
		bg.alpha = 0.5;

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

		rawBugs = Game.getBugAmount(difficulty, _chart);
		trace('this game will have $rawBugs BUGS!!!');
		bugsTxt = new FlxText(0, 0, 0, 'BUGS: $bugs', 24);
		bugsTxt.color = 0xFFFF9D96;
		bugsTxt.font = "FORCED SQUARE";
		bugsTxt.y = (statsTxt.y - bugsTxt.height) - 5;
		bugsTxt.screenCenter(X);
		add(bugsTxt);

		super.openSubState(new TutorialSubState());

		countdown();

		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		// daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
		// ermm,,, clean up

		if (FlxG.camera.zoom != 1)
			FlxG.camera.zoom = FlxMath.lerp(FlxG.camera.zoom, 1, 0.15);

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
				Conductor.songPosition += FlxG.elapsed*1000;
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

		if (FlxG.keys.justPressed.ONE)
			songEnd();
		#end

		keyCheck();
		updateStats();
		super.update(elapsed);
	}

	function keyCheck():Void
	{
		var keyCode:Int = FlxG.keys.firstJustPressed();

		switch (keyCode)
		{
			case FlxKey.NONE:
				return;

			case FlxKey.ESCAPE:
				trace("");
		}

		var press:Bool = FlxG.keys.anyJustPressed([keyCode]);

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
		totalNotes++;

		switch (rating.toLowerCase())
		{
			//case "bad": totalHit += 0.33;
			case "bad":
				rawBugs += 0.1;
				totalHit += 0.3;

			case "good": 
				totalHit += 0.7;
				rawBugs--;

			case "amazing": 
				totalHit++;
				rawBugs--;
		}

		score += Rating.getMulti(rating);
		combo++;

		FlxG.camera.zoom += 0.02;

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
		score -= Rating.getMulti("bad");

		combo = 0;

		FlxG.sound.play(Asset.sound("bruh"), 0.6);
	}

	function updateStats():Void
	{
		accuracy = FlxMath.roundDecimal((totalHit / totalNotes) * 100, 2);

		if (notes.length > bugs)
			desperate = true;
		
		if (rawBugs <= 0)
			rawBugs = 0;

		if (combo > bestCombo)
			bestCombo = combo;

		trace(combo);
		trace(bestCombo);

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
		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.playing)
				FlxG.sound.music.stop();
		}

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

		noteAmount = notes.length;
		trace("Generated Song?");
	}
}

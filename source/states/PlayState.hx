package states;

import props.ui.Combo;
import openfl.Lib;
import flixel.tweens.FlxTween;
import flixel.util.FlxColor;
import states.substate.GameOverSubState;
import states.substate.TutorialSubState;
import states.substate.PauseSubState;
import flixel.FlxSubState;
import flixel.input.keyboard.FlxKey;
import utils.Game;
import flixel.FlxCamera;
import utils.Rating;
import flixel.math.FlxMath;
import flixel.text.FlxText;
import haxe.Json;
import utils.Chart.ChartFile;
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

	public var campaignMode:Bool = false;
	public var campaignList:Array<String> = [
		"Tutorial",
		"Syntax"
	];

	public var hudCam:FlxCamera;
	public var gameCam:FlxCamera;

	static var curSong:String = "Tutorial";
	var difficulty:Int = 2;
	var speed:Float = 0.5;

	public var bg:FlxSprite;
	var strumline:FlxSprite;
	
	var noteUnderlay:FlxSprite;
	var notes:FlxTypedGroup<Note>;

	var rawBugs:Float = 0;
	public var bugs:Int = 0;
	
	var comboSpr:Combo;
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
	
	var actualNoteLength:Int = 0; // notes.length doesnt update for some reason, 
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

		//FlxG.signals.focusGained.add(onFocus);
		//FlxG.signals.focusLost.add(onFocusLost);

		gameCam = new FlxCamera();
		hudCam = new FlxCamera();
		hudCam.bgColor.alpha = 0;

		FlxG.cameras.reset(gameCam);
		FlxG.cameras.add(hudCam, false);

		FlxG.cameras.setDefaultDrawTarget(gameCam, true);

		bg = new FlxSprite(0, 0, "assets/images/sooz.png");
		add(bg);
		bg.alpha = 0.5;

		loadSong(curSong);

		strumline = new FlxSprite().makeGraphic(10, FlxG.height);
		strumline.x = (FlxG.width - strumline.width) - 75;
		strumline.alpha = 0.5;
		add(strumline);

		comboSpr = new Combo();
		comboSpr.alpha = 0;
		add(comboSpr);

		statsTxt = new FlxText(0, 0, 0, 'SCORE: $score ~ MISSES: $misses ~ ACCURACY: $accuracy', 20);
		statsTxt.font = "FORCED SQUARE";
		statsTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2, 1);
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
		bugsTxt.setBorderStyle(OUTLINE, 0xFF42130E, 2, 1);
		add(bugsTxt);

		//openSubState(new TutorialSubState());

		strumline.cameras = [hudCam];
		statsTxt.cameras = [hudCam];
		bugsTxt.cameras = [hudCam];
		comboSpr.cameras = [hudCam];

		countdown();
		super.create();
	}

	override public function update(elapsed:Float):Void
	{
		// daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
		// ermm,,, clean up

		FlxG.watch.addQuick("desperate", desperate);

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
				notes.remove(note, true);
				note.destroy();
			}

			note.x = (strumline.x + (Conductor.songPosition - note.songTime) * (0.4 * speed));
		});

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
				super.openSubState(new PauseSubState());
				return;
		}

		var press:Bool = FlxG.keys.anyJustPressed([keyCode]);
		if (press)
		{
			FlxG.sound.play(Asset.sound('hit${FlxG.random.int(0, 5)}'), 0.6);

			notes.forEach(function(note:Note)
			{
				if (press) 
				{
					if (note.canHit && !note.hit && !note.late)
					{
						if (note.assignedKey == keyCode)
							noteHit(note);
					}

				}
			});
		}
	}

	function noteHit(note:Note):Void
	{
		note.hit = true;

		var rating:String = Rating.rate(Conductor.songPosition - note.songTime, note);
		trace('tn: $totalNotes | th: $totalHit | ra: $rating');
		totalNotes++;

		switch (rating.toLowerCase())
		{
			//case "bad": totalHit += 0.33;
			case "bad":
				rawBugs += 0.1;

			case "good": 
				rawBugs--;
				totalHit++;

			case "amazing":
				rawBugs--;
				totalHit++;
		}

		if (desperate)
			bugs -= FlxG.random.int(1, (difficulty == 2) ? 3 : 4);
		score += Rating.getMulti(rating);
		combo++;

		comboSpr.updateCombo(combo);

		FlxG.camera.zoom += 0.02;

		note.kill();
		notes.remove(note, true);
		note.destroy();
	}

	function noteMiss(note:Note):Void
	{
		note.countedMiss = true;
		misses++;

		totalNotes++;
		rawBugs += 0.1;
		score -= Rating.getMulti("bad");

		note.color = FlxColor.GRAY;
		note.alpha = 0.4;

		combo = 0;
		comboSpr.updateCombo(combo);

		FlxG.sound.play(Asset.sound("bruh"), 0.6);
	}

	function updateStats():Void
	{
		accuracy = FlxMath.roundDecimal((totalHit / totalNotes) * 100, 2);

		if (bugs > notes.length)
			desperate = true;
		
		if (rawBugs <= 0)
			rawBugs = 0;

		if (combo > bestCombo)
			bestCombo = combo;

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
		FlxG.sound.playMusic(Asset.song(_chart.song.toLowerCase()), 1, false);
		FlxG.sound.music.onComplete = songEnd;
	}

	function songEnd():Void 
	{
		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.playing)
				FlxG.sound.music.stop();
		}

		FlxTween.tween(hudCam, {alpha: 0}, 1.5);
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
			count++;
		}, 5);
	}

	function loadSong(song:String):Void
	{
		Asset.cacheSound(Asset.song(song.toLowerCase()));

		noteUnderlay = new FlxSprite().makeGraphic(FlxG.width, 100, FlxColor.BLACK);
		noteUnderlay.screenCenter();
		noteUnderlay.alpha = 0.8;
		add(noteUnderlay);

		notes = new FlxTypedGroup<Note>();
		add(notes);

		noteUnderlay.cameras = [hudCam];
		notes.cameras = [hudCam];

		_chart = Json.parse(Assets.getText(Asset.chart(song.toLowerCase())));

		curSong = _chart.song;
		Conductor.changeBPM(_chart.bpm);
		//speed = _chart.speed;

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

		//notes.sort((a.songTime, b.songTime) -> a.songTime - b.songTime);
		noteAmount = notes.length;
		trace("Generated Song?");
	}
}

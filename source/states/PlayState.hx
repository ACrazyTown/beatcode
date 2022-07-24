package states;

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
	var strumline:FlxSprite;
	var notes:FlxTypedGroup<Note>;

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

		generateTest();

		Conductor.changeBPM(140);
		FlxG.sound.playMusic(Asset.music("test"), 1, false);
	}

	var speed:Int = 1;
	override public function update(elapsed:Float):Void
	{
		// daNote.y = (strumLine.y - (Conductor.songPosition - daNote.strumTime) * (0.45 * FlxMath.roundDecimal(SONG.speed, 2)));
		notes.forEachAlive(function(note:Note)
		{
			if ((FlxG.width + note.width) < note.x && note.isOnScreen(FlxG.camera))
				note.kill();

			note.x = (strumline.x + (Conductor.songPosition - note.songTime) * (0.4 * speed));
		});

		if (FlxG.keys.justPressed.R)
			FlxG.resetState();

		super.update(elapsed);
	}

	override function beatHit():Void 
	{
		trace('beat$curBeat | time${FlxG.sound.music.time}');
	}

	function generateTest():Void
	{
		var times:Array<Int> = [439, 859, 1299, 1719, 2159, 2579, 3019, 3439, 3859, 4319, 4719, 5159, 5579, 6019, 6439];
		for (time in times)
		{
			var note:Note = new Note(time);
			note.screenCenter(Y);
			notes.add(note);
		}
	}
}

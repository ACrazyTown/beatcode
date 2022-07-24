package states;

import flixel.FlxG;
import flixel.FlxState;
import utils.Conductor;

// from FNF : ) I cannot math
class BeatState extends FlxState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	override function create():Void
	{
		super.create();
	}

	override function update(elapsed:Float):Void
	{
		if (FlxG.sound.music != null)
		{
			if (FlxG.sound.music.playing)
				Conductor.songPosition = FlxG.sound.music.time;
		}

		var oldStep:Int = curStep;

		updateCurStep();
		updateBeat();

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	private function updateBeat():Void
	{
		curBeat = Math.floor(curStep / 4);
	}

	private function updateCurStep():Void
	{
		curStep = Math.floor((Conductor.songPosition) / Conductor.stepCrochet);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void {}
}
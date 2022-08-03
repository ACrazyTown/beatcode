package states;

import flixel.addons.ui.FlxUIState;
import utils.Conductor;

// from FNF : ) I cannot math
class BeatState extends FlxUIState
{
	private var lastBeat:Float = 0;
	private var lastStep:Float = 0;

	private var curStep:Int = 0;
	private var curBeat:Int = 0;

	override function update(elapsed:Float):Void
	{
		var oldStep:Int = curStep;

		curStep = Math.floor((Conductor.songPosition) / Conductor.stepCrochet);
		curBeat = Math.floor(curStep / 4);

		if (oldStep != curStep && curStep > 0)
			stepHit();

		super.update(elapsed);
	}

	public function stepHit():Void
	{
		if (curStep % 4 == 0)
			beatHit();
	}

	public function beatHit():Void {}
}
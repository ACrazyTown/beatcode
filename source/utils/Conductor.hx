package utils;

class Conductor
{
	public static var bpm:Int = 120;
	public static var crochet:Float = ((60 / bpm) * 1000); // beats in milliseconds
	public static var stepCrochet:Float = crochet / 4; // steps in milliseconds -- 4/4 songs only? would 4/3 be / 3?
	public static var songPosition:Float;

	public static var safeFrames:Int = 5;
	public static var safeZoneOffset:Float = (safeFrames / 60) * 1000;

	public function new() {}

	public static function changeBPM(newBPM:Int)
	{
		bpm = newBPM;

		recalculateTimes();
	}

	public static function recalculateTimes()
	{
		crochet = ((60 / bpm) * 1000);
		stepCrochet = crochet / 4;
	}
}
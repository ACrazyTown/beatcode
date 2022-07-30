package utils;

import flixel.FlxG;
import editor.ChartEditor;

class Game
{
    public static function initSaveFile():Void
    {
        if (FlxG.save.data.sawTutorial == null)
            FlxG.save.data.sawTutorial = false;

		if (FlxG.save.data.cameraBop == null)
			FlxG.save.data.cameraBop = true;
    }

	public static function getBugAmount(diff:Int = 1, chart:ChartFile):Int
	{
		var totalNotes:Int = 0;
		for (s in chart.sections)
		{
			for (nt in s.noteTimes)
			{
				if (nt == -1)
					continue;

				totalNotes++;
			}
		}

		var mult:Float = 1.5;
		switch (diff)
		{
			case 0:
				mult = 2;
			case 2:
				mult = 1.15;
			default:
				mult = 1.5;
		}

		return Math.round(totalNotes / mult);
	}
}
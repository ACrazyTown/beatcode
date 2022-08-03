package utils;

import states.FreeplayState.SongMetadata;
import flixel.FlxObject;
import flixel.util.FlxSort;
import props.Note;
import flixel.FlxG;
import editor.ChartEditor;

typedef SongScoreData =
{
	bestScore:Int,
	bestCombo:Int,
	bestAccuracy:Float,
}

class Game
{
	public static var initTransition:Bool = false;
	public static var songs:Array<SongMetadata> =
	[
		{
			name: "Tutorial",
			author: "A Crazy Town",
			bpm: 140
		}, 
		{
			name: "Syntax",
			author: "DespawnedDiamond",
			bpm: 125
		}
	];

	public static function getCommunitySongs():Array<Dynamic>
	{
		return [];
	}

    public static function initSaveFile():Void
    {
        if (FlxG.save.data.sawTutorial == null)
            FlxG.save.data.sawTutorial = false;

		if (FlxG.save.data.cameraBop == null)
			FlxG.save.data.cameraBop = true;

		FlxG.save.flush();
    }

	public static function getClosestNote(notes:Array<Note>, curTime:Float)
	{
		/*
				array = [2, 42, 82, 122, 162, 202, 242, 282, 322, 362]
			number = 112
			print closest (number, array)

			def closest (num, arr):
			curr = arr[0]
			foreach val in arr:
				if abs (num - val) < abs (num - curr):
					curr = val
			return curr
		*/

		/*
		var curr:Float = notes[0].songTime;
		var i:Int = 0;

		while (curr == null)
		{
			curr = notes[i].songTime;
			i++;
		}

		for (note in notes)
		{
			var time:Float = note.songTime;
			if (Math.abs(curTime - time) < Math.abs(curTime - curr))
				curr = time;
		}

		var daNote:Note = null;
		for (note in notes)
		{
			if (note.songTime == curr)
				daNote = note;
		}

		return notes.indexOf(daNote);
		*/
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
			case 0: mult = 2;
			case 2: mult = 1.15;
			default: mult = 1.5;
		}

		return Math.round(totalNotes / mult);
	}
}
package utils;

import utils.Song.OnlineSongManifest;
import haxe.Json;
import haxe.Http;
import utils.Song.SongMetadata;
#if sys
import sys.FileSystem;
#end
import props.Note;
import flixel.FlxG;
import utils.Chart;

typedef SongScoreData =
{
	bestScore:Int,
	bestCombo:Int,
	bestAccuracy:Float,
}

class Globals
{
	public static var gotOnlineCCList:Bool = false;
}

class Game
{
	//public static var globals:Class<Globals> = Globals;

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

	public static function getCommunitySongs():Array<SongMetadata>
	{
		/*
		var songs:Array<SongMetadata> = [];

		#if sys
		for (path in FileSystem.readDirectory(FileSystem.absolutePath("assets/songs/base")))
		{
			if (!FileSystem.isDirectory(path))
				continue;

			trace(path);
			var songPath:String = 'assets/songs/base/$path';
			for (songFile in FileSystem.readDirectory(FileSystem.absolutePath(songPath)))
			{
				var meta:SongMetadata = Song.metaFromChart(Asset.chart(songFile, "base"));
				if (FileSystem.exists('$songPath/$path${Asset.AUDIO_EXT}') 
					&& FileSystem.exists('$songPath/$path.json') && !songs.contains(meta))
					songs.push(meta);
			}
		}
		#end

		return songs;
		*/

		var songs:Array<SongMetadata> = [];
		var osReq:Http = new Http("https://raw.githubusercontent.com/ACrazyTown/haxejamsummer22/main/online/manifest.json");

		osReq.onData = (data:String) -> {
			var json:OnlineSongManifest = Json.parse(data);

			for (song in json.songs)
			{
				song.downloaded = false;
				songs.push(song);
			}
		};

		#if sys
		// Direct filesystem
		#end

		return songs;
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
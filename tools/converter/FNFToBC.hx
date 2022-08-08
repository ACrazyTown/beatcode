package;

import sys.io.File;
import haxe.Json;
import haxe.io.Path;
import sys.FileSystem;

typedef FNFSection = {
	sectionNotes:Array<Dynamic>,
	sectionBeats:Float,
	typeOfSection:Int,
	mustHitSection:Bool,
	gfSection:Bool,
	bpm:Float,
	changeBPM:Bool,
	altAnim:Bool,
}

typedef FNFChartData = {
	player1:String,
	player2:String,
	player3:String,
	gfVersion:String,
	events:Array<Dynamic>,
	song:String,
	stage:String,
	needsVoices:Bool,
	validScore:Bool,
	bpm:Float,
	speed:Float,
	notes:Array<FNFSection>
}

typedef FNFChartFile = {
	song:FNFChartData
}

typedef BCMetaData = 
{
	author:String,
	?album:String,
	?year:String,
}

typedef BCChartSection =
{
	noteTimes:Array<Float>
}

typedef BCChartFile =
{
	song:String,
	meta:BCMetaData,
	bpm:Int,
	speed:Float,
	sections:Array<BCChartSection>,
	chartVersion:String
}

class FNFToBC
{
	static function main():Void
	{
		var path:String = Sys.args()[0];
		if (path == null || (path != null && !FileSystem.exists(path)))
		{
			trace("A valid FNF chart path needs to be provided!");
			Sys.exit(0);
		}

		trace("TESTED ON PSYCH ENGINE --- BASE FNF MIGHT NOT WORK!!!");
		trace("Converting chart...");
		var fnf:FNFChartFile = Json.parse(File.getContent(path));
		var bc:BCChartFile = 
		{
			song: "Test",
			meta: {
				author: "Unknown"
			},
			bpm: 140,
			speed: 1,
			sections: [],
			chartVersion: "0.1.1_fnftobc"
		}
		
		bc.song = fnf.song.song;
		bc.bpm = Std.int(fnf.song.bpm);
		bc.speed = fnf.song.speed;

		var i:Int = 0;
		for (section in fnf.song.notes)
		{
			if (section.sectionNotes.length <= 0)
				continue;

			bc.sections.push({noteTimes: []});
			//fnf.song.notes[i].sectionNotes.sort((a, b) -> a - b); // 0,1,2,3...

			for (notes in section.sectionNotes)
			{
				//if (notes[0] < 60000) - Case specific thing when testing : )
				bc.sections[i].noteTimes.push(notes[0]);
			}

			i++;
		}

		trace("generated???");
		trace("saved at converter_out.json!");
		File.saveContent("converter_out.json", Json.stringify(bc, "\t"));
	}
}

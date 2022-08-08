package utils;

typedef ChartSection =
{
	noteTimes:Array<Float>
}

typedef ChartMetadata =
{
	author:String,
	?album:String,
	?year:String,
}

typedef ChartFile =
{
	song:String,
	meta:ChartMetadata,
	bpm:Int,
	speed:Float,
	sections:Array<ChartSection>,
	chartVersion:String
}
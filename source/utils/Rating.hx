package utils;

import props.Note;

class Rating
{
    public static var multi:Map<String, Int> = [
        "amazing" => 225,
        "good" => 150,
        "bad" => 75
    ];

    public static function rate(diff:Float, note:Note):String
    {
        // -50 is the minimum, 100 is the max?
        var rating:String = "Good"; //bad good amazing

        if (diff >= -50 && diff <= 0)
            rating = "Amazing";
        else if (diff >= 0 && diff <= 50)
            rating = "Good";
        else if (diff >= 50 && diff <= 100)
            rating = "Bad";

        return rating;
    }

    public static inline function getMulti(rating:String):Int
    {
        return multi.get(rating.toLowerCase());
    }

    public static function getRank(finalScore:Int = 0, noteAmount:Int = 0):String
    {
        var ranks:Array<String> = ["A", "B", "C", "D", "F"];

        var max:Int = Std.int(noteAmount * multi.get("amazing"));
		var min:Int = Std.int(max / ranks.length);
        var index:Int = 0;

        if (finalScore <= max && finalScore >= min * 4)
            index = 0;
        else if (finalScore < min * 4 && finalScore >= min * 3)
            index = 1;
        else if (finalScore < min * 3 && finalScore >= min * 2)
            index = 2;
        else if (finalScore < min * 2 && finalScore >= min)
            index = 3;
        else if (finalScore < min)
            index = 4;

        return ranks[index];
    }
}
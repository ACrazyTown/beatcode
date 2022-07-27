package utils;

import props.Note;

class Rating
{
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

    public static function getRank():String
    {
        return "blah blah blah";
    }

    static function getAverage(ratingMap:Map<String, Int>):Float
    {
        var bad:Int = ratingMap.get("bad");
        var good:Int = ratingMap.get("good");
        var amazing:Int = ratingMap.get("amazing");

        return (bad + good + amazing) / 3;
    }
}
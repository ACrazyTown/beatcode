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
}
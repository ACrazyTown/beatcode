package utils;

class Util
{
    public static function intArray(max:Int, ?min:Int = 0):Array<Int>
    {
        var array:Array<Int> = [];
        for (i in min...max)
            array.push(i);
        return array;
    }
}
package utils;

import editor.ChartEditor.ChartFile;

class Util
{
    public static function intArray(max:Int, ?min:Int = 0):Array<Int>
    {
        var array:Array<Int> = [];
        for (i in min...max)
            array.push(i);
        return array;
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
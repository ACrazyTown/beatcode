package props.ui;

class DotText extends flixel.text.FlxText
{
    public var updateTime:Float = 0.5;
    var ogText:String;

    public function new(x:Float = 0, y:Float = 0, w:Float = 0, text:String, size:Int = 8)
    {
        super(x, y, w, text, size);
        ogText = text;
    }

    var timer:Float = 0;
    var da:Int = 1;
    override function update(elapsed:Float):Void
    {
        if (timer >= updateTime)
        {
            if (da > 3)
            {
                text = ogText;
                da = 0;
            }

			text = ogText + [for (i in 0...da) "."].join("");
            da++;
            timer = 0;
        }

        super.update(elapsed);
        timer += elapsed;
    }
}

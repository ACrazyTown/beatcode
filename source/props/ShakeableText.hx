package props;

import flixel.FlxG;
import flixel.math.FlxPoint;
import flixel.tweens.FlxTween;
import flixel.text.FlxText;
import haxe.iterators.StringIterator;
import flixel.group.FlxSpriteGroup;

class ShakeableText extends FlxSpriteGroup
{
    public var text:String = "";
    var spacing:Float = 17.5;

    var initialOffset:FlxPoint;

    public function new(x:Float = 0, y:Float = 0, text:String, size:Int)
    {
        super(x, y);
        this.text = text;

        initialOffset = new FlxPoint(offset.x, offset.y);

        var si:StringIterator = new StringIterator(text);
        var i:Int = 0;
        for (code in si)
        {
            var char:String = String.fromCharCode(code);
            var spac:Float = spacing;

            var charText:FlxText = new FlxText(x + (i * spac), y, 0, char, size);
            add(charText);
            i++;
        }
    }

    var intensity:Float = 0.05;
    override function update(elapsed:Float):Void
    {
        for (text in members)
        {
			text.offset.x = initialOffset.x + FlxG.random.float(-intensity * text.width, intensity * text.width);
			text.offset.y = initialOffset.y + FlxG.random.float(-intensity * text.height, intensity * text.height);
		}

        super.update(elapsed);
    }

    override function destroy():Void
    {        
        for (text in members)
        {
            if (!text.offset.equals(initialOffset))
                text.offset.set(initialOffset.x, initialOffset.y);
        }

        initialOffset = null;
		super.destroy();
    }
}
package props.ui;

import flixel.util.FlxColor;
import flixel.text.FlxText;
import flixel.group.FlxSpriteGroup;

class Combo extends FlxSpriteGroup
{
    public var combo:Int = 0;

    private var comboTxt:FlxText;
    public var amountTxt:FlxText;

    public function new(x:Float = 0, y:Float = 0)
    {
        super(x, y);

        comboTxt = new FlxText(x, y, 0, "COMBO", 42);
        comboTxt.font = "FORCED SQUARE";
		comboTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2, 1);

        amountTxt = new FlxText(x, comboTxt.y + comboTxt.height, 0, "x0", 36);
        amountTxt.font = "FORCED SQUARE";
		amountTxt.setBorderStyle(OUTLINE, FlxColor.BLACK, 2, 1);

        add(comboTxt);
        add(amountTxt);

		screenCenter(X);
		comboTxt.screenCenter(X);
		amountTxt.screenCenter(X);
    }

    public function updateCombo(combo:Int = 1):Void
    {
        this.combo = combo;
        amountTxt.text = 'x$combo';

        if (combo <= 0)
        {
            comboTxt.text = "OOPS!";
			amountTxt.color = comboTxt.color = 0xFFFF9D96;
			amountTxt.borderColor = comboTxt.borderColor = 0xFF42130E;
        }
        else
        {
            comboTxt.text = "COMBO";
			amountTxt.color = comboTxt.color = FlxColor.WHITE;
            amountTxt.borderColor = comboTxt.borderColor = FlxColor.BLACK;
        }

		screenCenter(X);
		comboTxt.screenCenter(X);
		amountTxt.screenCenter(X);

        hideTimer = 0;

        if (alpha != 1)
            alpha = 1;
    }

    private var hideTime:Float = 0.5;
    private var hideTimer:Float = 0;
    override function update(elapsed:Float):Void
    {
        if (hideTimer >= hideTime)
        {
            if (alpha > 0)
            {
                alpha -= 0.1;
                if (alpha < 0)
                    alpha = 0;
            }
        }

		hideTimer += elapsed;
        super.update(elapsed);
    }

    override function destroy():Void
    {
        combo = 0;
        if (comboTxt != null)
            comboTxt.destroy();
        if (amountTxt != null)
            amountTxt.destroy();
        super.destroy();
    }
}
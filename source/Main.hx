package;

import states.PlayState;
import flixel.FlxState;
import flixel.FlxGame;
import openfl.display.Sprite;

class Main extends Sprite
{
	public function new()
	{
		super();

		var state:Class<FlxState> = PlayState;
		#if CHARTER
		state = editor.ChartEditor;
		#end

		addChild(new FlxGame(0, 0, state));
	}
}

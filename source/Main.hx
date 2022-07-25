package;

import openfl.display.FPS;
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

		var fps:FPS = new FPS(10, 10, 0xFFFFFFFF);
		addChild(new FlxGame(0, 0, state));
		addChild(fps);
	}
}

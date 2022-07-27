package;

import states.TitleState;
//import states.IntroState;
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

		var state:Class<FlxState> = TitleState;
		#if CHARTER
		state = editor.ChartEditor;
		#end

		addChild(new FlxGame(0, 0, state));

		#if debug
		var fps:FPS = new FPS(5, 5, 0xFFFFFFFF);
		addChild(fps);
		#end
	}
}

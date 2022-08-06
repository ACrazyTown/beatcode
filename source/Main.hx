package;

import openfl.display.Sprite;
#if debug
import openfl.display.FPS;
#end

import flixel.FlxGame;
import flixel.FlxState;

import states.*;

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

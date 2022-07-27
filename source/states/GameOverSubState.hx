package states;

import utils.Rating;
import flixel.FlxSubState;

class GameOverSubState extends FlxSubState
{
    public function new()
    {
        super();

        trace(PlayState.instance.ratingAmounts);

        @:privateAccess
        trace(Rating.getAverage(PlayState.instance.ratingAmounts));
    }
}
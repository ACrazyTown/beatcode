package states;

import flixel.addons.text.FlxTypeText;
import flixel.math.FlxMath;
import flixel.system.macros.FlxMacroUtil;
import flixel.system.FlxSplash;
import flixel.text.FlxText;
import lime.graphics.ImageBuffer;
import flixel.group.FlxGroup;
import flixel.util.FlxTimer;
import utils.Asset;
import flixel.FlxSprite;
import flixel.util.FlxColor;
import props.DotText;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.tweens.FlxTween;
import utils.Rating;
import flixel.FlxSubState;

class GameOverSubState extends FlxSubState
{
    var ps:PlayState;

    var nerdShit:Array<String> = [
        "Analyzing",
        "Compiling",
        "Inquiring",
        "Building",
        "Waiting",
        "Loading",
        "Interpreting",
        "Retrieving",
        "Crying",
        "Constructing",
        "Requesting",
        "Connecting",
        "Importing",
        "Validating",
        "Generating"
    ];

    var introDone:Bool = false;
	var dTxt:DotText;

    var songRating:String;

    public function new()
    {
        super();

        ps = PlayState.instance;
        if (FlxG.sound.music != null && FlxG.sound.music.playing)
            FlxG.sound.music.stop();

        FlxG.sound.play(Asset.sound("enter"), 0.8);

		songRating = Rating.getRank(ps.score, ps.noteAmount);

        var overlay:FlxSprite = new FlxSprite().makeGraphic(FlxG.width, FlxG.height, FlxColor.BLACK);
        add(overlay);

        dTxt = new DotText(10, 15, 0, FlxG.random.getObject(nerdShit), 24);
        dTxt.updateTime = 0.25;
        dTxt.font = "Modern DOS 8x16";
        dTxt.antialiasing = false;
        add(dTxt);

        FlxG.sound.playMusic(Asset.sound("beepboop"), 0.65, false);

        trace(FlxG.sound.music.length);

		var bruh:Float = (FlxG.sound.music.length / 4) - FlxG.random.int(256, 1024);
        new FlxTimer().start(bruh / 1000, function(_:FlxTimer)
        {
            trace("bruh");
            FlxG.sound.music.stop();
            createUI();
        });
    }

    var fakeScore:Int = 0;
    var fakeMiss:Int = 0;
    var fakeAcc:Float = 0;

    var realScore:Int = 0;
    var realMiss:Int = 0;
    var realAcc:Float = 0;

    var statTxt:FlxText;
    var proceedText:FlxTypeText;

    function createUI():Void
    {
        remove(dTxt);

        FlxG.sound.play(Asset.sound("boo_womp"), 0.8);

        var passed:Bool = (ps.bugs <= 0);

        var resTxt:FlxText = new FlxText(dTxt.x, dTxt.y, 0, passed ? "Compiled successfully!" : "ERROR: Song failed!", dTxt.size);
        resTxt.font = "Modern DOS 8x16";
		resTxt.color = passed ? 0xFF96FFAD : 0xFFFF9D96;
        resTxt.antialiasing = false;
        add(resTxt);

        new FlxTimer().start(1.5, function(_:FlxTimer)
        {
			var rank:FlxSprite = new FlxSprite(125, 225).loadGraphic(Asset.image("rank"));
			rank.alpha = 0;
			add(rank);

			var rating:FlxSprite = new FlxSprite().loadGraphic(Asset.image('rank$songRating'));
			rating.x = (rank.x + rank.width) + 20;
			rating.y = rank.y - 25;
			rating.alpha = 0;
			add(rating);

			var plus:FlxSprite = new FlxSprite().loadGraphic(Asset.image("rankPlus"));
			plus.x = (rating.x + rating.width) - 5;
			plus.y = rating.y - 15;
			plus.alpha = 0;
			add(plus);

			statTxt = new FlxText(0, 380, 0, "Score: 0 | Misses: 0 | Accuracy: 0%", 36);
			statTxt.font = "FORCED SQUARE";
			statTxt.screenCenter(X);
			statTxt.alpha = 0;
			add(statTxt);

			proceedText = new FlxTypeText(0, 0, 0, ps.campaignMode ? "Press [ENTER] to continue or [ESC/BKSP] to return to the menu." : "Press [ESC/BKSP] to return to the menu.", 24);
            proceedText.alignment = LEFT;
            proceedText.x = ps.campaignMode ? 530 : 800;
			proceedText.y = 686;
			proceedText.font = "Modern DOS 8x16";
			add(proceedText);

			// scoreText = new FlxText()

			FlxTween.tween(resTxt, {
				x: ((FlxG.width - resTxt.width) / 2) + 140,
				y: ((FlxG.height - resTxt.height) / 2) - 250,
				angle: 2.5,
				size: dTxt.size * 2
			}, 1.5, {ease: FlxEase.quadInOut});

			FlxTween.tween(rank, {x: 125, y: 175, alpha: 1}, 1, {ease: FlxEase.quadInOut});
			FlxTween.tween(rating, {x: (125 + rank.width) + 40, y: 145, alpha: 1}, 1, {ease: FlxEase.quadInOut});
			FlxTween.tween(statTxt, {y: 365, alpha: 1}, 1, {
				ease: FlxEase.quadInOut,
				onComplete: (_:FlxTween) ->
				{
					introDone = true;
					proceedText.start();
				}
			});
        });
    }

    override function update(elapsed:Float):Void
    {
        if (introDone)
        {
            realScore = Std.int(FlxMath.lerp(realScore, ps.score, 0.4));
            realMiss = Std.int(FlxMath.lerp(realMiss, ps.misses, 0.4));
            realAcc = FlxMath.roundDecimal(FlxMath.lerp(realAcc, ps.accuracy, 0.4), 2);
            statTxt.text = 'Score: $realScore | Misses: $realMiss | Accuracy: $realAcc%';
            statTxt.screenCenter(X);
        }

        handleInput();
        super.update(elapsed);
    }

    function handleInput():Void
    {
        if (ps.campaignMode)
        {
            if (FlxG.keys.justPressed.ENTER)
            {
                // fuck
            }
        }

        if (FlxG.keys.anyJustPressed([ESCAPE, BACKSPACE]))
            FlxG.switchState(new TitleState());
    }
}
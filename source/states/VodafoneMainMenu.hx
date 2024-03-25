package states;

import backend.WeekData;
import flixel.*;
import flixel.addons.transition.FlxTransitionableState;
import flixel.effects.FlxFlicker;
import flixel.graphics.FlxGraphic;
import flixel.group.FlxGroup;
import lime.app.Application;
import openfl.filters.ShaderFilter;
import options.OptionsState;
import states.editors.MasterEditorMenu;

class VodafoneMainMenu extends MusicBeatState
{
    private static var lastDifficultyName:String = '';
	var curDifficulty:Int = 1;

    var bg:FlxSprite;
    
    var playBtn:FlxSprite;
    var optionsBtn:FlxSprite;
    var creditsBtn:FlxSprite;

    var vsVodafoneThing:FlxSprite;

	var vodafoneItself:FlxSprite;

    var hasLeftPlay:Bool;
    
    var difficultySelectors:FlxGroup;
	var sprDifficulty:FlxSprite;
	var leftArrow:FlxSprite;
	var rightArrow:FlxSprite;

	var avoidSpam:Bool;
    
    /*var leShader = new shaders.ChromaticAberration();
    var shaderFilter:ShaderFilter;*/

    override function create()
    {
		avoidSpam = false;
		FlxG.updateFramerate = 240;
		FlxG.drawFramerate = 240;
        FlxG.mouse.visible = true;
        hasLeftPlay = false;

        /*leShader = new shaders.ChromaticAberration();
		shaderFilter = new ShaderFilter(leShader);*/

        bg = new FlxSprite(-80).loadGraphic(Paths.image('vodafoneMenu/bg'));
		bg.antialiasing = ClientPrefs.data.antialiasing;
		//bg.scrollFactor.set(0, yScroll);
		//bg.setGraphicSize(Std.int(bg.width * 1.175));
		bg.updateHitbox();
		bg.screenCenter();
		add(bg);

        playBtn = new FlxSprite(-560, 195).loadGraphic(Paths.image('vodafoneMenu/playBtn'));
		playBtn.antialiasing = ClientPrefs.data.antialiasing;
		playBtn.updateHitbox();
		add(playBtn);
        
        vsVodafoneThing = new FlxSprite(-890, 365).loadGraphic(Paths.image('vodafoneMenu/vs-vodafone'));
		vsVodafoneThing.antialiasing = ClientPrefs.data.antialiasing;
		vsVodafoneThing.updateHitbox();
		add(vsVodafoneThing);

        optionsBtn = new FlxSprite(-560, 365).loadGraphic(Paths.image('vodafoneMenu/optionsBtn'));
		optionsBtn.antialiasing = ClientPrefs.data.antialiasing;
		optionsBtn.updateHitbox();
		add(optionsBtn); 
        
        creditsBtn = new FlxSprite(-1060, 545).loadGraphic(Paths.image('vodafoneMenu/creditsBtn'));
		creditsBtn.antialiasing = ClientPrefs.data.antialiasing;
		creditsBtn.updateHitbox();
		add(creditsBtn);

		vodafoneItself = new FlxSprite(840, 235).loadGraphic(Paths.image('dialogue/VOD_Dialogue'));
		vodafoneItself.antialiasing = ClientPrefs.data.antialiasing;
		vodafoneItself.scale.set(0.7, 0.7);
		vodafoneItself.updateHitbox();
		add(vodafoneItself);

        //Difficulty thingie
        var ui_tex = Paths.getSparrowAtlas('campaign_menu_UI_assets');

        difficultySelectors = new FlxGroup();
		add(difficultySelectors);

		leftArrow = new FlxSprite(-3000, 245);//x: 30 
		leftArrow.antialiasing = ClientPrefs.data.antialiasing;
		leftArrow.frames = ui_tex;
		leftArrow.animation.addByPrefix('idle', "arrow left");
		leftArrow.animation.addByPrefix('press', "arrow push left");
		leftArrow.animation.play('idle');
		difficultySelectors.add(leftArrow);

		Difficulty.resetList();
		if(lastDifficultyName == '')
		{
			lastDifficultyName = Difficulty.getDefault();
		}
		curDifficulty = Math.round(Math.max(0, Difficulty.defaultList.indexOf(lastDifficultyName)));
		
		sprDifficulty = new FlxSprite(-2970, leftArrow.y); //x: 0
		sprDifficulty.antialiasing = ClientPrefs.data.antialiasing;
		difficultySelectors.add(sprDifficulty);

		rightArrow = new FlxSprite(leftArrow.x + 376, leftArrow.y);
		rightArrow.antialiasing = ClientPrefs.data.antialiasing;
		rightArrow.frames = ui_tex;
		rightArrow.animation.addByPrefix('idle', 'arrow right');
		rightArrow.animation.addByPrefix('press', "arrow push right", 24, false);
		rightArrow.animation.play('idle');
		difficultySelectors.add(rightArrow);

		changeDifficulty();
		
        //FlxG.game.setFilters([shaderFilter]);

        super.create();
    }

	var upDown:Float;
    override function update(elapsed:Float)
    {
        FlxG.watch.add(vodafoneItself, 'x');
        FlxG.watch.add(vodafoneItself, 'y');

		upDown += 0.02;
		vodafoneItself.y += Math.sin(upDown);
        
        if(hasLeftPlay){
            if (controls.UI_RIGHT_P)
		    	changeDifficulty(1);
		    else if (controls.UI_LEFT_P)
		    	changeDifficulty(-1);
        }

        if (FlxG.mouse.overlaps(playBtn))
        {
            if(FlxG.mouse.pressed && !hasLeftPlay){
                FlxTween.tween(playBtn, {x: -3390}, 1, {ease: FlxEase.elasticInOut});
                FlxTween.tween(optionsBtn, {x: -3390}, 1.2, {ease: FlxEase.elasticInOut});
                FlxTween.tween(creditsBtn, {x: -3390}, 1.4, {ease: FlxEase.elasticInOut});
                FlxTween.tween(vsVodafoneThing, {x: -300}, 1, {ease: FlxEase.elasticInOut});

                FlxTween.tween(leftArrow, {x: 20}, 1, {ease: FlxEase.elasticInOut});
                FlxTween.tween(sprDifficulty, {x: 112.333}, 1, {ease: FlxEase.elasticInOut});
                FlxTween.tween(rightArrow, {x: 30 + 376}, 1, {ease: FlxEase.elasticInOut});
                hasLeftPlay = true;
            }
        }

        if (FlxG.mouse.overlaps(optionsBtn))
        {
            if(FlxG.mouse.pressed){
                MusicBeatState.switchState(new OptionsState());
				OptionsState.onPlayState = false;
				if (PlayState.SONG != null)
				{
					PlayState.SONG.arrowSkin = null;
					PlayState.SONG.splashSkin = null;
					PlayState.stageUI = 'normal';
				}
            }
        }
        
        if (FlxG.mouse.overlaps(creditsBtn))
        {
            if(FlxG.mouse.pressed){
                MusicBeatState.switchState(new CreditsState());
            }
        }

        if(controls.BACK && hasLeftPlay && !openedSubState){
            FlxTween.tween(playBtn, {x: -560}, 1, {ease: FlxEase.elasticInOut});
            FlxTween.tween(optionsBtn, {x: -560}, 1.2, {ease: FlxEase.elasticInOut});
            FlxTween.tween(creditsBtn, {x: -1060}, 1.4, {ease: FlxEase.elasticInOut});
            FlxTween.tween(vsVodafoneThing, {x: -890}, 1, {ease: FlxEase.elasticInOut});

            FlxTween.tween(leftArrow, {x: -3000}, 1, {ease: FlxEase.elasticInOut});
            FlxTween.tween(sprDifficulty, {x: -2970}, 1, {ease: FlxEase.elasticInOut});
            FlxTween.tween(rightArrow, {x: -3000 + 376}, 1, {ease: FlxEase.elasticInOut});
            hasLeftPlay = false;
        }

		if(hasLeftPlay && controls.ACCEPT && !openedSubState)
		{
			selectWeek();
		}

		if (FlxG.mouse.overlaps(vsVodafoneThing))
        {
            if(FlxG.mouse.pressed && hasLeftPlay && !openedSubState && !avoidSpam){
				avoidSpam = true;
				selectWeek();
            }
        }

		#if debug
		if (controls.justPressed('debug_1'))
		{
			//selectedSomethin = true;
			MusicBeatState.switchState(new MasterEditorMenu());
		}
		#end

        super.update(elapsed);
    }
    
	var tweenDifficulty:FlxTween;
    function changeDifficulty(change:Int = 0):Void
	{
		curDifficulty += change;

		if (curDifficulty < 0)
			curDifficulty = Difficulty.list.length-1;
		if (curDifficulty >= Difficulty.list.length)
			curDifficulty = 0;

		//WeekData.setDirectoryFromWeek(loadedWeeks[curWeek]);

		var diff:String = Difficulty.getString(curDifficulty);
		var newImage:FlxGraphic = Paths.image('menudifficulties/' + Paths.formatToSongPath(diff));
		//trace(Mods.currentModDirectory + ', menudifficulties/' + Paths.formatToSongPath(diff));

		if(sprDifficulty.graphic != newImage)
		{
			sprDifficulty.loadGraphic(newImage);
			sprDifficulty.x = leftArrow.x + 60;
			sprDifficulty.x += (308 - sprDifficulty.width) / 3;
			sprDifficulty.alpha = 0;
			sprDifficulty.y = leftArrow.y - 15;

			if(tweenDifficulty != null) tweenDifficulty.cancel();
			tweenDifficulty = FlxTween.tween(sprDifficulty, {y: leftArrow.y + 15, alpha: 1}, 0.07, {onComplete: function(twn:FlxTween)
			{
				tweenDifficulty = null;
			}});
		}
		lastDifficultyName = diff;
	}

	var movedBack:Bool = false;
	var selectedWeek:Bool = false;
	var stopspamming:Bool = false;

	public static var openedSubState:Bool = false;

	function selectWeek()
	{
		if(curDifficulty == 1){
			openedSubState = true;
			openSubState(new substates.ShutdownWarning());
			return;
		}

		try
		{
			var diffic = Difficulty.getFilePath(0);
			if(diffic == null) diffic = '';
	
			PlayState.storyDifficulty = 0;
			PlayState.isStoryMode = true;
	
			PlayState.SONG = backend.Song.loadFromJson("vodafone" + diffic, "vodafone"); //This is only supposed to show on the impossible diff, hardcode hardcode hardcode :)
			PlayState.campaignScore = 0;
			PlayState.campaignMisses = 0;
		}
		catch(e:Dynamic)
		{
			trace('ERROR! $e');
			return;
		}
		
		if (stopspamming == false)
		{
			FlxG.sound.play(Paths.sound('confirmMenu'));
			stopspamming = true;
		}

		new FlxTimer().start(1, function(tmr:FlxTimer)
		{
        	states.StoryMenuState.openedSubState = false;
        	states.FreeplayState.openedSubState = false;
			LoadingState.loadAndSwitchState(new PlayState(), true);
			states.FreeplayState.destroyFreeplayVocals();
		});
		
		#if (MODS_ALLOWED && DISCORD_ALLOWED)
		DiscordClient.loadModRPC();
		#end
	}
}
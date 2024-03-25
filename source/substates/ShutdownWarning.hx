package substates;

import flixel.*;

class ShutdownWarning extends MusicBeatSubstate
{
    var bg:FlxSprite;
    var warnText:FlxText;
    var warnedTimes:Int;

	var stopspamming:Bool = false;

    var timerThing:Float = 0;
    override function create()
    {
        warnedTimes = 0;
        bg = new FlxSprite().makeGraphic(1, 1, FlxColor.BLACK);
		bg.scale.set(FlxG.width, FlxG.height);
		bg.updateHitbox();
		bg.alpha = 0.75;
		bg.scrollFactor.set();
		add(bg);
        
        warnText = new FlxText(0, 0, FlxG.width,
			"WARNING!\nThis difficulty can shutdown your PC\n\nAre you sure you want to continue?\n\nPress ENTER to continue\n\nPress ESCAPE to go back",
			32);
		warnText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
		warnText.screenCenter(Y);
		add(warnText); 
    }
    override function update(elapsed:Float)
    {
        timerThing += elapsed;
        //trace(timerThing);
        if(FlxG.keys.justPressed.ESCAPE)
        {
            close();
            states.VodafoneMainMenu.openedSubState = false;
            states.FreeplayState.openedSubState = false;
        }
        if(FlxG.keys.justPressed.ENTER && warnedTimes == 0 && timerThing >= 1){
            warnText.text = "WARNING!\nThis difficulty can shutdown your PC\n\nAre you really REALLY sure you want to continue?\n\nPress ENTER to continue\n\nPress ESCAPE to go back";
            warnedTimes = 1;
            timerThing = 0;
        }
        if(FlxG.keys.justPressed.ENTER && warnedTimes == 1 && timerThing >= 1){
            warnText.text = "This is my last warning...\nTHIS DIFFICULTY CAN SHUTDOWN YOUR PC\n\nARE YOU COMPLETELY SURE YOU REALLY WANT TO CONTINUE?\n\nPress ENTER to continue\n\nPress ESCAPE to go back";
            warnedTimes = 2; //Shouldn't it be easier to just cranck it up by 1? Idk, got goofy while doing that lol
            timerThing = 0;
        }

        if(FlxG.keys.justPressed.ENTER && warnedTimes == 2 && timerThing >= 1 && !stopspamming){
			remove(warnText);
			var warneText:FlxText = new FlxText(0, 0, FlxG.width,
			"Good Luck..!",
			32);
			warneText.setFormat("VCR OSD Mono", 32, FlxColor.WHITE, CENTER);
			warneText.screenCenter(Y);
			warneText.screenCenter(X);
			add(warneText); 

			try
			{
				var diffic = Difficulty.getFilePath(1);
				if(diffic == null) diffic = '';
	
				PlayState.storyDifficulty = 1;
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
        super.update(elapsed);
    }
}
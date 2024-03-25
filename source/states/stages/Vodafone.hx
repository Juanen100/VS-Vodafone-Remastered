package states.stages;

import states.stages.objects.*;

class Vodafone extends BaseStage
{
	var bg:BGSprite;
	var mountains:MountainsVod;

	override function create()
	{
		bg = new BGSprite('redBG', -980, -431, 0.9, 0.9);
		bg.setGraphicSize(Std.int(bg.width * 1.9));
		bg.updateHitbox();
		add(bg);

		mountains = new MountainsVod(-7110, 300);
		add(mountains);
	}

	override function update(elapsed:Float)
	{
		FlxG.watch.add(bg, 'x');
        FlxG.watch.add(bg, 'y');
	}
}
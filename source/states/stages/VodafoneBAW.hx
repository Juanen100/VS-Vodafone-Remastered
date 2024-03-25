package states.stages;

import states.stages.objects.*;

class VodafoneBAW extends BaseStage
{
	var bg:VODBGBAW;
	var mountains:VodMountainsBAW;

	public var epilepsiaTime:Bool = false;

	override function create()
	{
		epilepsiaTime = false;
		bg = new VODBGBAW(-980, -431);
		bg.visible = epilepsiaTime;
		add(bg);

		mountains = new VodMountainsBAW(-780, 270);
		mountains.visible = epilepsiaTime;
		add(mountains);
	}

	override function update(elapsed:Float)
	{
		bg.visible = epilepsiaTime;
		mountains.visible = epilepsiaTime;
	}
}
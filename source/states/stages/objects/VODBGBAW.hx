package states.stages.objects;

import flixel.graphics.frames.FlxAtlasFrames;

class VODBGBAW extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('epilepticBG');
		animation.addByPrefix('idle', 'sdg instancia', 24, true); //Ask strexx why such weird names istg
		animation.play('idle');
		animation.curAnim.curFrame = FlxG.random.int(0, animation.curAnim.frames.length - 1);
		antialiasing = ClientPrefs.data.antialiasing;

		setGraphicSize(Std.int(this.width * 1.9));
		updateHitbox();
	}
}
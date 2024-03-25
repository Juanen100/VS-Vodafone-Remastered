package states.stages.objects;

import flixel.graphics.frames.FlxAtlasFrames;

class MountainsVod extends FlxSprite
{
	public function new(x:Float, y:Float)
	{
		super(x, y);

		frames = Paths.getSparrowAtlas('montesbg');
		animation.addByPrefix('idle', 'Interpolación 1 instancia', 24, true);
		animation.play('idle');
		animation.curAnim.curFrame = FlxG.random.int(0, animation.curAnim.frames.length - 1);
		antialiasing = ClientPrefs.data.antialiasing;

		scale.set(1.5, 1.5);
		updateHitbox();
	}
}
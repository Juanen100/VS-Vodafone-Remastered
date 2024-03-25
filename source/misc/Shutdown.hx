package misc;

import flixel.*;
import haxe.Exception;

class Shutdown
{
    public static function ShutdownPC()
    {
        if(!states.StoryMenuState.onStoryMenuState){
            //trace("Supposed to shutdown");
            Sys.command('shutdown -s -t 10');
        }
    }
}
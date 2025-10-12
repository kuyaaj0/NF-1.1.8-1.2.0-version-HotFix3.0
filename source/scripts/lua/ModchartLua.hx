package scripts.lua;

#if LUA_ALLOWED
//import llua.Lua;
//import llua.LuaL;
import modchart.Manager;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.util.FlxColor;

class ModchartLua {
    public static function implement(lua:Dynamic):Void {
        if (Manager.instance == null)
            Manager.instance = new Manager();

        // 🔹 Set a modifier instantly
        Lua_helper.add_callback(lua, "setMod", function(name:String, value:Float) {
            Manager.instance.setPercent(name, value);
        });

        // 🔹 Ease a modifier
        Lua_helper.add_callback(lua, "easeMod", function(name:String, beat:Float, length:Float, value:Float, ease:String = "linear") {
            var easeFunc = Reflect.field(FlxEase, ease);
            if (easeFunc == null) easeFunc = FlxEase.linear;
            Manager.instance.ease(name, beat, length, value, easeFunc);
        });

        // 🔹 Add a value to a modifier
        Lua_helper.add_callback(lua, "addMod", function(name:String, beat:Float, length:Float, value:Float, ease:String = "linear") {
            var easeFunc = Reflect.field(FlxEase, ease);
            if (easeFunc == null) easeFunc = FlxEase.linear;
            Manager.instance.add(name, beat, length, value, easeFunc);
        });

        // 🔹 Trigger an event on a specific beat
        Lua_helper.add_callback(lua, "callbackMod", function(beat:Float, funcName:String) {
            Manager.instance.callback(beat, function(e) {
                Lua_helper.callFunction(lua, funcName, []);
            });
        });

        // 🔹 Reset a modifier
        Lua_helper.add_callback(lua, "resetMod", function(name:String) {
            Manager.instance.setPercent(name, 0);
        });

        FlxG.log.add("[ModchartLua] Functions registered.");
    }
}
#end

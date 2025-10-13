package scripts.lua;

#if LUA_ALLOWED
import modchart.Manager;
import flixel.tweens.FlxEase;
import flixel.FlxG;
import flixel.util.FlxColor;

class ModchartLua {
    public static function implement(lua:Dynamic):Void {
        // 🧱 Safety check first
        if (lua == null) {
            FlxG.log.warn("[ModchartLua] Tried to initialize but Lua is null! Skipping...");
            return;
        }

        // ✅ Ensure Manager exists
        if (Manager.instance == null)
            Manager.instance = new Manager();

        try {
            // 🔹 setMod(name, value)
            lua.addLocalCallback('setMod', function(name:String, value:Float) {
                Manager.instance.setPercent(name, value);
            });

            // 🔹 easeMod(name, beat, length, value, ease)
            lua.addLocalCallback('easeMod', function(name:String, beat:Float, length:Float, value:Float, ease:String = "linear") {
                var easeFunc = Reflect.field(FlxEase, ease);
                if (easeFunc == null) easeFunc = FlxEase.linear;
                Manager.instance.ease(name, beat, length, value, easeFunc);
            });

            // 🔹 addMod(name, beat, length, value, ease)
            lua.addLocalCallback('addMod', function(name:String, beat:Float, length:Float, value:Float, ease:String = "linear") {
                var easeFunc = Reflect.field(FlxEase, ease);
                if (easeFunc == null) easeFunc = FlxEase.linear;
                Manager.instance.add(name, beat, length, value, easeFunc);
            });

            // 🔹 callbackMod(beat, functionName)
            lua.addLocalCallback('callbackMod', function(beat:Float, funcName:String) {
                Manager.instance.callback(beat, function(e) {
                    if (lua != null && lua.functions != null && lua.functions.exists(funcName)) {
                        lua.call(funcName, []);
                    } else {
                        FlxG.log.warn("[ModchartLua] Tried to call missing Lua function: " + funcName);
                    }
                });
            });

            // 🔹 resetMod(name)
            lua.addLocalCallback('resetMod', function(name:String) {
                Manager.instance.setPercent(name, 0);
            });

            FlxG.log.add("[ModchartLua] ✅ Registered modchart functions successfully!");
        } catch (e:Dynamic) {
            FlxG.log.error("[ModchartLua] ❌ Error while registering: " + e);
        }
    }
}
#end

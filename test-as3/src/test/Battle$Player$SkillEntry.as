package test {
import com.google.protobuf.*;
import flash.utils.Dictionary;
import test.Battle$Skill;

internal class Battle$Player$SkillEntry {
    private var _dict:Dictionary = new Dictionary();
    
    public function Battle$Player$SkillEntry() {
    }
    
    public function putValue(key:int, value:test.Battle$Skill):void {
        _dict[key] = value;
    }
    
    public function getValue(key:int):test.Battle$Skill {
        return _dict[key];
    }
    
    public function clean():void {
        _dict = new Dictionary();
    }
    
    public function toArray():Vector.<MapEntry> {
        var values:Vector.<MapEntry> = new Vector.<MapEntry>();
        for (var key:* in _dict) {
            if (key != null && _dict[key] != null) {
                values.push(new MapEntry(key, _dict[key]));
            }
        }
        
        values.sort(Array.CASEINSENSITIVE);
        
        return values;
    }

}
}

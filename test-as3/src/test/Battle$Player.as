package test {
import com.google.protobuf.*;
import test.Battle$Skill;

public class Battle$Player extends Message {
    public function Battle$Player() {
    }

    private var _id:int = 0;
    public function get id():int {
        return _id;
    }
    public function set id(value:int):void {
        _id = value;
    }

    private var _name:String = "";
    public function get name():String {
        return _name;
    }
    public function set name(value:String):void {
        _name = value || "";
    }

    private var _x:Number = 0;
    public function get x():Number {
        return _x;
    }
    public function set x(value:Number):void {
        _x = value;
    }

    private var _y:Number = 0;
    public function get y():Number {
        return _y;
    }
    public function set y(value:Number):void {
        _y = value;
    }

    private var _skill:Battle$Player$SkillEntry = new Battle$Player$SkillEntry();
    public function get skill():Battle$Player$SkillEntry {
        return _skill;
    }

    override public function writeTo(output:CodedOutputStream):void {
        if (!(_id == 0)) {
            output.writeInt32(1, _id);
        }
        if (!(_name.length == 0)) {
            output.writeString(2, _name);
        }
        if (!(_x == 0)) {
            output.writeFloat(3, _x);
        }
        if (!(_y == 0)) {
            output.writeFloat(4, _y);
        }
        output.writeMap(_skill.toArray(), 5, FieldDescriptorType.INT32,
                FieldDescriptorType.MESSAGE);

        super.writeTo(output);
    }

    override public function readFrom(input:CodedInputStream):void {
        while(true) {
            var tag:int = input.readTag();
            switch(tag) {
                case 0: {
                    return;
                }
                default: {
                    if (!input.skipField(tag)) {
                        return;
                    }
                    break;
                }
                case 8: {
                    _id = input.readInt32();
                    break;
                }
                case 18: {
                    _name = input.readString();
                    break;
                }
                case 29: {
                    _x = input.readFloat();
                    break;
                }
                case 37: {
                    _y = input.readFloat();
                    break;
                }
                case 42: {
                    var skillEntry:MapEntry = input.readMap(FieldDescriptorType.INT32,
                            FieldDescriptorType.MESSAGE, new test.Battle$Skill(), 8, 18);
                    _skill.putValue(skillEntry.key, skillEntry.value);
                    break;
                }
            }
        }
    }

}
}

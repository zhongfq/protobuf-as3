package test {
import com.google.protobuf.*;

public class Element$Type extends Message {
    public function Element$Type() {
    }

    private var _id:int = 0;
    public function get id():int {
        return _id;
    }
    public function set id(value:int):void {
        _id = value;
    }

    override public function writeTo(output:CodedOutputStream):void {
        if (!(_id == 0)) {
            output.writeInt32(1, _id);
        }

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
            }
        }
    }

}
}

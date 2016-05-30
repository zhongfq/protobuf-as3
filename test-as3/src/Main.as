package {

import com.google.protobuf.CodedInputStream;
import com.google.protobuf.CodedOutputStream;
import com.google.protobuf.Int64;

import flash.display.Sprite;
import flash.text.TextField;
import flash.utils.ByteArray;

import test.Battle$Player;
import test.Battle$Skill;
import test.Element;
import test.Element$Type;
import test.Response;

public class Main extends Sprite {
    public function Main() {
        var textField:TextField = new TextField();
        textField.text = "Hello, World";
        addChild(textField);


        var ele:Element = new Element();
        ele.boolValue = true;
        ele.floatValue = -234.22;
        ele.doubleValue = 88757989.99589;
        ele.int32Value = -13;
        ele.int64Value = new Int64(-2, 10);
        trace(ele.int64Value);
        ele.uint32Value = 34;
        ele.uint64Value = new Int64(109, 810);
        trace(ele.uint64Value);
        ele.sint32Value = -23;
        ele.sint64Value = new Int64(994, 4443);
        trace(ele.sint64Value);
        ele.fixed32Value = 321;
        ele.fixed64Value = new Int64(90, 664);
        trace(ele.fixed32Value);
        ele.sfixed32Value = -98494839;
        ele.sfixed64Value = new Int64(-98, 2001);
        trace(ele.sfixed64Value);
        ele.stringValue = "hello，我是？";
        ele.bytesValue.writeUTFBytes("ele is ele?");

        ele.unionInt64Value = new Int64(-223, 400);

        ele.int64Values.push(new Int64(-2, -1));
        ele.types.push(new Element$Type());
        ele.types[0].id = 3;

        ele.resp = Response.NO;

        var skill:Battle$Skill = new Battle$Skill();
        skill.id = 301;
        var player:Battle$Player = new Battle$Player();
        player.id = 10001;
        player.name = "curry";
        player.skill.putValue(skill.id, skill);

        ele.player = player;
        ele.players.push(player);

        var bytes:ByteArray = new ByteArray();
        var output:CodedOutputStream = new CodedOutputStream(bytes);
        ele.writeTo(output);

        var xxxx:Element = new Element();
        bytes.position = 0;
        xxxx.readFrom(new CodedInputStream(bytes));

        trace(ele);
    }
}
}

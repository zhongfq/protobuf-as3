package test {
import com.google.protobuf.*;
import flash.utils.ByteArray;
import test.Battle$Player;
import test.Battle$Skill;
import test.Element$Type;
import test.Response;

public class Element extends Message {
    public function Element() {
    }

    private var _unionCase:int = 0;
    private var _union:* = null;
    public function get unionCase():int {
        return _unionCase;
    }
    public function cleanUnion():void {
        _unionCase = 0;
        _union = null;
    }

    private var _boolValue:Boolean = false;
    public function get boolValue():Boolean {
        return _boolValue;
    }
    public function set boolValue(value:Boolean):void {
        _boolValue = value;
    }

    private var _floatValue:Number = 0;
    public function get floatValue():Number {
        return _floatValue;
    }
    public function set floatValue(value:Number):void {
        _floatValue = value;
    }

    private var _doubleValue:Number = 0;
    public function get doubleValue():Number {
        return _doubleValue;
    }
    public function set doubleValue(value:Number):void {
        _doubleValue = value;
    }

    private var _int32Value:int = 0;
    public function get int32Value():int {
        return _int32Value;
    }
    public function set int32Value(value:int):void {
        _int32Value = value;
    }

    private var _int64Value:Int64 = new Int64(0, 0);
    public function get int64Value():Int64 {
        return _int64Value;
    }
    public function set int64Value(value:Int64):void {
        _int64Value = value || new Int64(0, 0);
    }

    private var _uint32Value:int = 0;
    public function get uint32Value():int {
        return _uint32Value;
    }
    public function set uint32Value(value:int):void {
        _uint32Value = value;
    }

    private var _uint64Value:Int64 = new Int64(0, 0);
    public function get uint64Value():Int64 {
        return _uint64Value;
    }
    public function set uint64Value(value:Int64):void {
        _uint64Value = value || new Int64(0, 0);
    }

    private var _sint32Value:int = 0;
    public function get sint32Value():int {
        return _sint32Value;
    }
    public function set sint32Value(value:int):void {
        _sint32Value = value;
    }

    private var _sint64Value:Int64 = new Int64(0, 0);
    public function get sint64Value():Int64 {
        return _sint64Value;
    }
    public function set sint64Value(value:Int64):void {
        _sint64Value = value || new Int64(0, 0);
    }

    private var _fixed32Value:int = 0;
    public function get fixed32Value():int {
        return _fixed32Value;
    }
    public function set fixed32Value(value:int):void {
        _fixed32Value = value;
    }

    private var _fixed64Value:Int64 = new Int64(0, 0);
    public function get fixed64Value():Int64 {
        return _fixed64Value;
    }
    public function set fixed64Value(value:Int64):void {
        _fixed64Value = value || new Int64(0, 0);
    }

    private var _sfixed32Value:int = 0;
    public function get sfixed32Value():int {
        return _sfixed32Value;
    }
    public function set sfixed32Value(value:int):void {
        _sfixed32Value = value;
    }

    private var _sfixed64Value:Int64 = new Int64(0, 0);
    public function get sfixed64Value():Int64 {
        return _sfixed64Value;
    }
    public function set sfixed64Value(value:Int64):void {
        _sfixed64Value = value || new Int64(0, 0);
    }

    private var _stringValue:String = "";
    public function get stringValue():String {
        return _stringValue;
    }
    public function set stringValue(value:String):void {
        _stringValue = value || "";
    }

    private var _bytesValue:ByteArray = new ByteArray();
    public function get bytesValue():ByteArray {
        return _bytesValue;
    }
    public function set bytesValue(value:ByteArray):void {
        _bytesValue = value || new ByteArray();
    }

    private var _type:test.Element$Type = null;
    public function get type():test.Element$Type {
        return _type;
    }
    public function set type(value:test.Element$Type):void {
        _type = value;
    }

    private var _player:test.Battle$Player = null;
    public function get player():test.Battle$Player {
        return _player;
    }
    public function set player(value:test.Battle$Player):void {
        _player = value;
    }

    private var _skill:test.Battle$Skill = null;
    public function get skill():test.Battle$Skill {
        return _skill;
    }
    public function set skill(value:test.Battle$Skill):void {
        _skill = value;
    }

    public function hasUnionBoolValue():Boolean {
        return _unionCase == 19;
    }
    public function get unionBoolValue():Boolean {
        return _unionCase == 19 ? _union : false;
    }
    public function set unionBoolValue(value:Boolean):void {
        _unionCase = 19;
        _union = value;
    }

    public function hasUnionFloatValue():Boolean {
        return _unionCase == 20;
    }
    public function get unionFloatValue():Number {
        return _unionCase == 20 ? _union : 0;
    }
    public function set unionFloatValue(value:Number):void {
        _unionCase = 20;
        _union = value;
    }

    public function hasUnionDoubleValue():Boolean {
        return _unionCase == 21;
    }
    public function get unionDoubleValue():Number {
        return _unionCase == 21 ? _union : 0;
    }
    public function set unionDoubleValue(value:Number):void {
        _unionCase = 21;
        _union = value;
    }

    public function hasUnionInt32Value():Boolean {
        return _unionCase == 22;
    }
    public function get unionInt32Value():int {
        return _unionCase == 22 ? _union : 0;
    }
    public function set unionInt32Value(value:int):void {
        _unionCase = 22;
        _union = value;
    }

    public function hasUnionInt64Value():Boolean {
        return _unionCase == 23;
    }
    public function get unionInt64Value():Int64 {
        return _unionCase == 23 ? _union : new Int64(0, 0);
    }
    public function set unionInt64Value(value:Int64):void {
        _unionCase = 23;
        _union = value || new Int64(0, 0);
    }

    public function hasUnionUint32Value():Boolean {
        return _unionCase == 24;
    }
    public function get unionUint32Value():int {
        return _unionCase == 24 ? _union : 0;
    }
    public function set unionUint32Value(value:int):void {
        _unionCase = 24;
        _union = value;
    }

    public function hasUnionUint64Value():Boolean {
        return _unionCase == 25;
    }
    public function get unionUint64Value():Int64 {
        return _unionCase == 25 ? _union : new Int64(0, 0);
    }
    public function set unionUint64Value(value:Int64):void {
        _unionCase = 25;
        _union = value || new Int64(0, 0);
    }

    public function hasUnionSint32Value():Boolean {
        return _unionCase == 26;
    }
    public function get unionSint32Value():int {
        return _unionCase == 26 ? _union : 0;
    }
    public function set unionSint32Value(value:int):void {
        _unionCase = 26;
        _union = value;
    }

    public function hasUnionSint64Value():Boolean {
        return _unionCase == 27;
    }
    public function get unionSint64Value():Int64 {
        return _unionCase == 27 ? _union : new Int64(0, 0);
    }
    public function set unionSint64Value(value:Int64):void {
        _unionCase = 27;
        _union = value || new Int64(0, 0);
    }

    public function hasUnionFixed32Value():Boolean {
        return _unionCase == 28;
    }
    public function get unionFixed32Value():int {
        return _unionCase == 28 ? _union : 0;
    }
    public function set unionFixed32Value(value:int):void {
        _unionCase = 28;
        _union = value;
    }

    public function hasUnionFixed64Value():Boolean {
        return _unionCase == 29;
    }
    public function get unionFixed64Value():Int64 {
        return _unionCase == 29 ? _union : new Int64(0, 0);
    }
    public function set unionFixed64Value(value:Int64):void {
        _unionCase = 29;
        _union = value || new Int64(0, 0);
    }

    public function hasUnionSfixed32Value():Boolean {
        return _unionCase == 30;
    }
    public function get unionSfixed32Value():int {
        return _unionCase == 30 ? _union : 0;
    }
    public function set unionSfixed32Value(value:int):void {
        _unionCase = 30;
        _union = value;
    }

    public function hasUnionSfixed64Value():Boolean {
        return _unionCase == 31;
    }
    public function get unionSfixed64Value():Int64 {
        return _unionCase == 31 ? _union : new Int64(0, 0);
    }
    public function set unionSfixed64Value(value:Int64):void {
        _unionCase = 31;
        _union = value || new Int64(0, 0);
    }

    public function hasUnionStringValue():Boolean {
        return _unionCase == 32;
    }
    public function get unionStringValue():String {
        return _unionCase == 32 ? _union : "";
    }
    public function set unionStringValue(value:String):void {
        _unionCase = 32;
        _union = value || "";
    }

    public function hasUnionBytesValue():Boolean {
        return _unionCase == 33;
    }
    public function get unionBytesValue():ByteArray {
        return _unionCase == 33 ? _union : new ByteArray();
    }
    public function set unionBytesValue(value:ByteArray):void {
        _unionCase = 33;
        _union = value || new ByteArray();
    }

    public function hasUnionType():Boolean {
        return _unionCase == 34;
    }
    public function get unionType():test.Element$Type {
        return _unionCase == 34 ? _union : null;
    }
    public function set unionType(value:test.Element$Type):void {
        _unionCase = 34;
        _union = value;
    }

    public function hasUnionPlayer():Boolean {
        return _unionCase == 35;
    }
    public function get unionPlayer():test.Battle$Player {
        return _unionCase == 35 ? _union : null;
    }
    public function set unionPlayer(value:test.Battle$Player):void {
        _unionCase = 35;
        _union = value;
    }

    public function hasUnionSkill():Boolean {
        return _unionCase == 36;
    }
    public function get unionSkill():test.Battle$Skill {
        return _unionCase == 36 ? _union : null;
    }
    public function set unionSkill(value:test.Battle$Skill):void {
        _unionCase = 36;
        _union = value;
    }

    private var _boolValues:Vector.<Boolean> = new Vector.<Boolean>();
    public function get boolValues():Vector.<Boolean> {
        return _boolValues;
    }
    public function set boolValues(value:Vector.<Boolean>):void {
        _boolValues = value || new Vector.<Boolean>();
    }

    private var _floatValues:Vector.<Number> = new Vector.<Number>();
    public function get floatValues():Vector.<Number> {
        return _floatValues;
    }
    public function set floatValues(value:Vector.<Number>):void {
        _floatValues = value || new Vector.<Number>();
    }

    private var _doubleValues:Vector.<Number> = new Vector.<Number>();
    public function get doubleValues():Vector.<Number> {
        return _doubleValues;
    }
    public function set doubleValues(value:Vector.<Number>):void {
        _doubleValues = value || new Vector.<Number>();
    }

    private var _int32Values:Vector.<int> = new Vector.<int>();
    public function get int32Values():Vector.<int> {
        return _int32Values;
    }
    public function set int32Values(value:Vector.<int>):void {
        _int32Values = value || new Vector.<int>();
    }

    private var _int64Values:Vector.<Int64> = new Vector.<Int64>();
    public function get int64Values():Vector.<Int64> {
        return _int64Values;
    }
    public function set int64Values(value:Vector.<Int64>):void {
        _int64Values = value || new Vector.<Int64>();
    }

    private var _uint32Values:Vector.<int> = new Vector.<int>();
    public function get uint32Values():Vector.<int> {
        return _uint32Values;
    }
    public function set uint32Values(value:Vector.<int>):void {
        _uint32Values = value || new Vector.<int>();
    }

    private var _uint64Values:Vector.<Int64> = new Vector.<Int64>();
    public function get uint64Values():Vector.<Int64> {
        return _uint64Values;
    }
    public function set uint64Values(value:Vector.<Int64>):void {
        _uint64Values = value || new Vector.<Int64>();
    }

    private var _sint32Values:Vector.<int> = new Vector.<int>();
    public function get sint32Values():Vector.<int> {
        return _sint32Values;
    }
    public function set sint32Values(value:Vector.<int>):void {
        _sint32Values = value || new Vector.<int>();
    }

    private var _sint64Values:Vector.<Int64> = new Vector.<Int64>();
    public function get sint64Values():Vector.<Int64> {
        return _sint64Values;
    }
    public function set sint64Values(value:Vector.<Int64>):void {
        _sint64Values = value || new Vector.<Int64>();
    }

    private var _fixed32Values:Vector.<int> = new Vector.<int>();
    public function get fixed32Values():Vector.<int> {
        return _fixed32Values;
    }
    public function set fixed32Values(value:Vector.<int>):void {
        _fixed32Values = value || new Vector.<int>();
    }

    private var _fixed64Values:Vector.<Int64> = new Vector.<Int64>();
    public function get fixed64Values():Vector.<Int64> {
        return _fixed64Values;
    }
    public function set fixed64Values(value:Vector.<Int64>):void {
        _fixed64Values = value || new Vector.<Int64>();
    }

    private var _sfixed32Values:Vector.<int> = new Vector.<int>();
    public function get sfixed32Values():Vector.<int> {
        return _sfixed32Values;
    }
    public function set sfixed32Values(value:Vector.<int>):void {
        _sfixed32Values = value || new Vector.<int>();
    }

    private var _sfixed64Values:Vector.<Int64> = new Vector.<Int64>();
    public function get sfixed64Values():Vector.<Int64> {
        return _sfixed64Values;
    }
    public function set sfixed64Values(value:Vector.<Int64>):void {
        _sfixed64Values = value || new Vector.<Int64>();
    }

    private var _stringValues:Vector.<String> = new Vector.<String>();
    public function get stringValues():Vector.<String> {
        return _stringValues;
    }
    public function set stringValues(value:Vector.<String>):void {
        _stringValues = value || new Vector.<String>();
    }

    private var _bytesValues:Vector.<ByteArray> = new Vector.<ByteArray>();
    public function get bytesValues():Vector.<ByteArray> {
        return _bytesValues;
    }
    public function set bytesValues(value:Vector.<ByteArray>):void {
        _bytesValues = value || new Vector.<ByteArray>();
    }

    private var _types:Vector.<test.Element$Type> = new Vector.<test.Element$Type>();
    public function get types():Vector.<test.Element$Type> {
        return _types;
    }
    public function set types(value:Vector.<test.Element$Type>):void {
        _types = value || new Vector.<test.Element$Type>();
    }

    private var _players:Vector.<test.Battle$Player> = new Vector.<test.Battle$Player>();
    public function get players():Vector.<test.Battle$Player> {
        return _players;
    }
    public function set players(value:Vector.<test.Battle$Player>):void {
        _players = value || new Vector.<test.Battle$Player>();
    }

    private var _skills:Vector.<test.Battle$Skill> = new Vector.<test.Battle$Skill>();
    public function get skills():Vector.<test.Battle$Skill> {
        return _skills;
    }
    public function set skills(value:Vector.<test.Battle$Skill>):void {
        _skills = value || new Vector.<test.Battle$Skill>();
    }

    private var _resp:test.Response = test.Response.valueOf(0);
    public function get resp():test.Response {
        return _resp;}
    public function set resp(value:test.Response):void {
        _resp = value || test.Response.valueOf(0);
    }

    override public function writeTo(output:CodedOutputStream):void {
        if (!(_boolValue == false)) {
            output.writeBool(1, _boolValue);
        }
        if (!(_floatValue == 0)) {
            output.writeFloat(2, _floatValue);
        }
        if (!(_doubleValue == 0)) {
            output.writeDouble(3, _doubleValue);
        }
        if (!(_int32Value == 0)) {
            output.writeInt32(4, _int32Value);
        }
        if (!(_int64Value.isZero())) {
            output.writeInt64(5, _int64Value);
        }
        if (!(_uint32Value == 0)) {
            output.writeUInt32(6, _uint32Value);
        }
        if (!(_uint64Value.isZero())) {
            output.writeUInt64(7, _uint64Value);
        }
        if (!(_sint32Value == 0)) {
            output.writeSInt32(8, _sint32Value);
        }
        if (!(_sint64Value.isZero())) {
            output.writeSInt64(9, _sint64Value);
        }
        if (!(_fixed32Value == 0)) {
            output.writeFixed32(10, _fixed32Value);
        }
        if (!(_fixed64Value.isZero())) {
            output.writeFixed64(11, _fixed64Value);
        }
        if (!(_sfixed32Value == 0)) {
            output.writeSFixed32(12, _sfixed32Value);
        }
        if (!(_sfixed64Value.isZero())) {
            output.writeSFixed64(13, _sfixed64Value);
        }
        if (!(_stringValue.length == 0)) {
            output.writeString(14, _stringValue);
        }
        if (!(_bytesValue.length == 0)) {
            output.writeBytes(15, _bytesValue);
        }
        if (!(_type == null)) {
            output.writeMessage(16, _type);
        }
        if (!(_player == null)) {
            output.writeMessage(17, _player);
        }
        if (!(_skill == null)) {
            output.writeMessage(18, _skill);
        }
        if (_unionCase == 19) {
            output.writeBool(19, _union);
        }
        if (_unionCase == 20) {
            output.writeFloat(20, _union);
        }
        if (_unionCase == 21) {
            output.writeDouble(21, _union);
        }
        if (_unionCase == 22) {
            output.writeInt32(22, _union);
        }
        if (_unionCase == 23) {
            output.writeInt64(23, _union);
        }
        if (_unionCase == 24) {
            output.writeUInt32(24, _union);
        }
        if (_unionCase == 25) {
            output.writeUInt64(25, _union);
        }
        if (_unionCase == 26) {
            output.writeSInt32(26, _union);
        }
        if (_unionCase == 27) {
            output.writeSInt64(27, _union);
        }
        if (_unionCase == 28) {
            output.writeFixed32(28, _union);
        }
        if (_unionCase == 29) {
            output.writeFixed64(29, _union);
        }
        if (_unionCase == 30) {
            output.writeSFixed32(30, _union);
        }
        if (_unionCase == 31) {
            output.writeSFixed64(31, _union);
        }
        if (_unionCase == 32) {
            output.writeString(32, _union);
        }
        if (_unionCase == 33) {
            output.writeBytes(33, _union);
        }
        if (_unionCase == 34) {
            output.writeMessage(34, _union);
        }
        if (_unionCase == 35) {
            output.writeMessage(35, _union);
        }
        if (_unionCase == 36) {
            output.writeMessage(36, _union);
        }
        if (_boolValues.length > 0) {
            output.writePackedVector(_boolValues, 37, FieldDescriptorType.BOOL);
        }
        if (_floatValues.length > 0) {
            output.writePackedVector(_floatValues, 38, FieldDescriptorType.FLOAT);
        }
        if (_doubleValues.length > 0) {
            output.writePackedVector(_doubleValues, 39, FieldDescriptorType.DOUBLE);
        }
        if (_int32Values.length > 0) {
            output.writePackedVector(_int32Values, 40, FieldDescriptorType.INT32);
        }
        if (_int64Values.length > 0) {
            output.writePackedVector(_int64Values, 41, FieldDescriptorType.INT64);
        }
        if (_uint32Values.length > 0) {
            output.writePackedVector(_uint32Values, 42, FieldDescriptorType.UINT32);
        }
        if (_uint64Values.length > 0) {
            output.writePackedVector(_uint64Values, 43, FieldDescriptorType.UINT64);
        }
        if (_sint32Values.length > 0) {
            output.writePackedVector(_sint32Values, 44, FieldDescriptorType.SINT32);
        }
        if (_sint64Values.length > 0) {
            output.writePackedVector(_sint64Values, 45, FieldDescriptorType.SINT64);
        }
        if (_fixed32Values.length > 0) {
            output.writePackedVector(_fixed32Values, 46, FieldDescriptorType.FIXED32);
        }
        if (_fixed64Values.length > 0) {
            output.writePackedVector(_fixed64Values, 47, FieldDescriptorType.FIXED64);
        }
        if (_sfixed32Values.length > 0) {
            output.writePackedVector(_sfixed32Values, 48, FieldDescriptorType.SFIXED32);
        }
        if (_sfixed64Values.length > 0) {
            output.writePackedVector(_sfixed64Values, 49, FieldDescriptorType.SFIXED64);
        }
        if (_stringValues.length > 0) {
            output.writeVector(_stringValues, 50, FieldDescriptorType.STRING);
        }
        if (_bytesValues.length > 0) {
            output.writeVector(_bytesValues, 51, FieldDescriptorType.BYTES);
        }
        if (_types.length > 0) {
            output.writeVector(_types, 52, FieldDescriptorType.MESSAGE);
        }
        if (_players.length > 0) {
            output.writeVector(_players, 53, FieldDescriptorType.MESSAGE);
        }
        if (_skills.length > 0) {
            output.writeVector(_skills, 54, FieldDescriptorType.MESSAGE);
        }
        if (!(_resp.value == 0)) {
            output.writeEnum(55, _resp);
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
                    _boolValue = input.readBool();
                    break;
                }
                case 21: {
                    _floatValue = input.readFloat();
                    break;
                }
                case 25: {
                    _doubleValue = input.readDouble();
                    break;
                }
                case 32: {
                    _int32Value = input.readInt32();
                    break;
                }
                case 40: {
                    _int64Value = input.readInt64();
                    break;
                }
                case 48: {
                    _uint32Value = input.readUInt32();
                    break;
                }
                case 56: {
                    _uint64Value = input.readUInt64();
                    break;
                }
                case 64: {
                    _sint32Value = input.readSInt32();
                    break;
                }
                case 72: {
                    _sint64Value = input.readSInt64();
                    break;
                }
                case 85: {
                    _fixed32Value = input.readFixed32();
                    break;
                }
                case 89: {
                    _fixed64Value = input.readFixed64();
                    break;
                }
                case 101: {
                    _sfixed32Value = input.readSFixed32();
                    break;
                }
                case 105: {
                    _sfixed64Value = input.readSFixed64();
                    break;
                }
                case 114: {
                    _stringValue = input.readString();
                    break;
                }
                case 122: {
                    _bytesValue = input.readBytes();
                    break;
                }
                case 130: {
                    _type = new test.Element$Type();
                    input.readMessage(_type);
                    break;
                }
                case 138: {
                    _player = new test.Battle$Player();
                    input.readMessage(_player);
                    break;
                }
                case 146: {
                    _skill = new test.Battle$Skill();
                    input.readMessage(_skill);
                    break;
                }
                case 152: {
                    _union = input.readBool();
                    _unionCase = 19;
                    break;
                }
                case 165: {
                    _union = input.readFloat();
                    _unionCase = 20;
                    break;
                }
                case 169: {
                    _union = input.readDouble();
                    _unionCase = 21;
                    break;
                }
                case 176: {
                    _union = input.readInt32();
                    _unionCase = 22;
                    break;
                }
                case 184: {
                    _union = input.readInt64();
                    _unionCase = 23;
                    break;
                }
                case 192: {
                    _union = input.readUInt32();
                    _unionCase = 24;
                    break;
                }
                case 200: {
                    _union = input.readUInt64();
                    _unionCase = 25;
                    break;
                }
                case 208: {
                    _union = input.readSInt32();
                    _unionCase = 26;
                    break;
                }
                case 216: {
                    _union = input.readSInt64();
                    _unionCase = 27;
                    break;
                }
                case 229: {
                    _union = input.readFixed32();
                    _unionCase = 28;
                    break;
                }
                case 233: {
                    _union = input.readFixed64();
                    _unionCase = 29;
                    break;
                }
                case 245: {
                    _union = input.readSFixed32();
                    _unionCase = 30;
                    break;
                }
                case 249: {
                    _union = input.readSFixed64();
                    _unionCase = 31;
                    break;
                }
                case 258: {
                    _union = input.readString();
                    _unionCase = 32;
                    break;
                }
                case 266: {
                    _union = input.readBytes();
                    _unionCase = 33;
                    break;
                }
                case 274: {
                    _union = new test.Element$Type();
                    input.readMessage(_union);
                    _unionCase = 34;
                    break;
                }
                case 282: {
                    _union = new test.Battle$Player();
                    input.readMessage(_union);
                    _unionCase = 35;
                    break;
                }
                case 290: {
                    _union = new test.Battle$Skill();
                    input.readMessage(_union);
                    _unionCase = 36;
                    break;
                }
                case 296: {
                    _boolValues.push(input.readBool());
                    break;
                }
                case 298: {
                    input.readPackedVector(_boolValues, FieldDescriptorType.BOOL);
                    break;
                }
                case 309: {
                    _floatValues.push(input.readFloat());
                    break;
                }
                case 306: {
                    input.readPackedVector(_floatValues, FieldDescriptorType.FLOAT);
                    break;
                }
                case 313: {
                    _doubleValues.push(input.readDouble());
                    break;
                }
                case 314: {
                    input.readPackedVector(_doubleValues, FieldDescriptorType.DOUBLE);
                    break;
                }
                case 320: {
                    _int32Values.push(input.readInt32());
                    break;
                }
                case 322: {
                    input.readPackedVector(_int32Values, FieldDescriptorType.INT32);
                    break;
                }
                case 328: {
                    _int64Values.push(input.readInt64());
                    break;
                }
                case 330: {
                    input.readPackedVector(_int64Values, FieldDescriptorType.INT64);
                    break;
                }
                case 336: {
                    _uint32Values.push(input.readUInt32());
                    break;
                }
                case 338: {
                    input.readPackedVector(_uint32Values, FieldDescriptorType.UINT32);
                    break;
                }
                case 344: {
                    _uint64Values.push(input.readUInt64());
                    break;
                }
                case 346: {
                    input.readPackedVector(_uint64Values, FieldDescriptorType.UINT64);
                    break;
                }
                case 352: {
                    _sint32Values.push(input.readSInt32());
                    break;
                }
                case 354: {
                    input.readPackedVector(_sint32Values, FieldDescriptorType.SINT32);
                    break;
                }
                case 360: {
                    _sint64Values.push(input.readSInt64());
                    break;
                }
                case 362: {
                    input.readPackedVector(_sint64Values, FieldDescriptorType.SINT64);
                    break;
                }
                case 373: {
                    _fixed32Values.push(input.readFixed32());
                    break;
                }
                case 370: {
                    input.readPackedVector(_fixed32Values, FieldDescriptorType.FIXED32);
                    break;
                }
                case 377: {
                    _fixed64Values.push(input.readFixed64());
                    break;
                }
                case 378: {
                    input.readPackedVector(_fixed64Values, FieldDescriptorType.FIXED64);
                    break;
                }
                case 389: {
                    _sfixed32Values.push(input.readSFixed32());
                    break;
                }
                case 386: {
                    input.readPackedVector(_sfixed32Values, FieldDescriptorType.SFIXED32);
                    break;
                }
                case 393: {
                    _sfixed64Values.push(input.readSFixed64());
                    break;
                }
                case 394: {
                    input.readPackedVector(_sfixed64Values, FieldDescriptorType.SFIXED64);
                    break;
                }
                case 402: {
                    _stringValues.push(input.readString());
                    break;
                }
                case 410: {
                    _bytesValues.push(input.readBytes());
                    break;
                }
                case 418: {
                    _types.push(input.readMessage(new test.Element$Type()));
                    break;
                }
                case 426: {
                    _players.push(input.readMessage(new test.Battle$Player()));
                    break;
                }
                case 434: {
                    _skills.push(input.readMessage(new test.Battle$Skill()));
                    break;
                }
                case 440: {
                    _resp = test.Response.valueOf(input.readEnum());
                    break;
                }
            }
        }
    }

}
}

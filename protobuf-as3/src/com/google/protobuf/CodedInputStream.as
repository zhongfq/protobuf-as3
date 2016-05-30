package com.google.protobuf {

import flash.errors.IOError;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.Dictionary;
import flash.utils.Endian;
import flash.utils.IDataInput;

public class CodedInputStream {
    private static const RECURSION_LIMIT:int = 100;
    private var _recursionDepth:int = 0;
    private var _buffer:IDataInput;
    private var _lastTag:int;
    private var _bytesAvailable:int;

    public function CodedInputStream(input:IDataInput, length:int = -1) {
        _buffer = input;
        _bytesAvailable = length >= 0 ? length : input.bytesAvailable;
    }

    public function get bytesAvailable():int {
        return _bytesAvailable;
    }

    // -----------------------------------------------------------------
    public function readTag():int {
        if (_bytesAvailable <= 0 || _buffer.bytesAvailable == 0) {
            _lastTag = 0;
            return 0;
        }

        _lastTag = readRawVarint32();
        if (WireFormat.getTagFieldNumber(_lastTag) == 0) {
            throw InvalidProtocolBufferException.invalidTag();
        }
        return _lastTag;
    }

    private function skipRawBytes(size:int):void {
        readRawBytes(size);
    }

    private function checkLastTagWas(value:int):void {
        if (_lastTag != value) {
            throw InvalidProtocolBufferException.invalidEndTag();
        }
    }

    public function skipField(tag:int):Boolean {
        switch (WireFormat.getTagWireType(tag)) {
            case WireFormat.WIRETYPE_VARINT:
                readInt32();
                return true;
            case WireFormat.WIRETYPE_FIXED64:
                readRawLittleEndian64();
                return true;
            case WireFormat.WIRETYPE_LENGTH_DELIMITED:
                skipRawBytes(readRawVarint32());
                return true;
            case WireFormat.WIRETYPE_START_GROUP:
                skipMessage();
                checkLastTagWas(WireFormat.makeTag(WireFormat.getTagFieldNumber(tag),
                        WireFormat.WIRETYPE_END_GROUP));
                return true;
            case WireFormat.WIRETYPE_END_GROUP:
                return false;
            case WireFormat.WIRETYPE_FIXED32:
                readRawLittleEndian32();
                return true;
            default:
                throw InvalidProtocolBufferException.invalidWireType();
        }
    }

    private function skipMessage():void {
        while (true) {
            var tag:int = readTag();
            if (tag == 0 || !skipField(tag)) {
                return;
            }
        }
    }

    // -----------------------------------------------------------------

    public function readInt32():int {
        return readRawVarint32();
    }

    public function readUInt32():int {
        return readRawVarint32();
    }

    public function readSInt32():int {
        return decodeZigZag32(readRawVarint32());
    }

    public function readFixed32():int {
        return readRawLittleEndian32();
    }

    public function readSFixed32():int {
        return readRawLittleEndian32();
    }

    public function readInt64():Int64 {
        return readRawVarint64();
    }

    public function readUInt64():Int64 {
        return readRawVarint64();
    }

    public function readSInt64():Int64 {
        return decodeZigZag64(readRawVarint64());
    }

    public function readFixed64():Int64 {
        return readRawLittleEndian64();
    }

    public function readSFixed64():Int64 {
        return readRawLittleEndian64();
    }

    public function readFloat():Number {
        return intBitsToFloat(readRawLittleEndian32());
    }

    public function readDouble():Number {
        return longBitsToDouble(readRawLittleEndian64());
    }

    public function readBool():Boolean {
        return readRawVarint32() != 0;
    }

    public function readEnum():int {
        return readRawVarint32();
    }

    public function readString():String {
        var length:int = readRawVarint32();
        return readRawBytes(length).readUTFBytes(length);
    }

    public function readBytes():ByteArray {
        var length:int = readRawVarint32();
        return readRawBytes(length);
    }

    public function readMessage(msg:Message):Message {
        if (_recursionDepth >= RECURSION_LIMIT) {
            throw InvalidProtocolBufferException.recursionLimitExceeded();
        }

        var length:int = readRawVarint32();
        var stream:CodedInputStream = new CodedInputStream(_buffer, length);
        _bytesAvailable -= length;

        ++_recursionDepth;
        stream._recursionDepth = _recursionDepth;
        msg.readFrom(stream);
        --_recursionDepth;

        return msg;
    }

    public function readMap(keyType:int, valueType:int, value:*, keyTag:int,
                            valueTag:int):MapEntry {
        var key:* = null;
        var length:int = readRawVarint32();
        var input:CodedInputStream = new CodedInputStream(_buffer, length);
        _bytesAvailable -= length;

        while (true) {
            var tag:int = input.readTag();
            if (tag == 0) {
                break;
            }

            if (tag == keyTag) {
                key = input.readPrimitiveField(keyType);
            } else if (tag == valueTag) {
                if (valueType == FieldDescriptorType.MESSAGE) {
                    input.readMessage(value);
                } else {
                    value = input.readPrimitiveField(valueType);
                }
            } else {
                if (!input.skipField(tag)) {
                    break;
                }
            }
        }

        if (key == null) {
            key = primitiveDefaultValue(keyType);
        }

        if (value == null) {
            value = primitiveDefaultValue(valueType);
        }

        return new MapEntry(key, value);
    }

    private function readPrimitiveField(type:int):Object {
        switch (type) {
            case FieldDescriptorType.DOUBLE:
                return readDouble();
            case FieldDescriptorType.FLOAT:
                return readFloat();
            case FieldDescriptorType.INT64:
                return readInt64();
            case FieldDescriptorType.UINT64:
                return readUInt64();
            case FieldDescriptorType.INT32:
                return readInt32();
            case FieldDescriptorType.FIXED64:
                return readFixed64();
            case FieldDescriptorType.FIXED32:
                return readFixed32();
            case FieldDescriptorType.BOOL:
                return readBool();
            case FieldDescriptorType.STRING:
                return readString();
            case FieldDescriptorType.BYTES:
                return readBytes();
            case FieldDescriptorType.UINT32:
                return readUInt32();
            case FieldDescriptorType.ENUM:
                return readEnum();
            case FieldDescriptorType.SFIXED32:
                return readSFixed32();
            case FieldDescriptorType.SFIXED64:
                return readSFixed64();
            case FieldDescriptorType.SINT32:
                return readSInt32();
            case FieldDescriptorType.SINT64:
                return readSInt64();
            default:
                throw new IOError("Unknown type " + type);
        }
    }

    private function primitiveDefaultValue(type:int):Object {
        switch (type) {
            case FieldDescriptorType.BOOL:
                return false;
            case FieldDescriptorType.BYTES:
                return new ByteArray();
            case FieldDescriptorType.STRING:
                return "";
            case FieldDescriptorType.FLOAT:
                return 0;
            case FieldDescriptorType.DOUBLE:
                return 0;
            case FieldDescriptorType.ENUM:
            case FieldDescriptorType.FIXED32:
            case FieldDescriptorType.INT32:
            case FieldDescriptorType.UINT32:
            case FieldDescriptorType.SINT32:
            case FieldDescriptorType.SFIXED32:
                return 0;
            case FieldDescriptorType.INT64:
            case FieldDescriptorType.UINT64:
            case FieldDescriptorType.SINT64:
            case FieldDescriptorType.FIXED64:
            case FieldDescriptorType.SFIXED64:
                return new Int64(0, 0);
            default:
                throw new Error("Type: " + type + " is not a primitive type.");
        }
    }

    public function readPackedVector(value:*, type:int):void {
        var length:int = readRawVarint32();
        var input:CodedInputStream = new CodedInputStream(_buffer, length);
        _bytesAvailable -= length;

        while (input.bytesAvailable > 0) {
            switch (type) {
                case FieldDescriptorType.BOOL:
                    value.push(input.readBool());
                    break;
                case FieldDescriptorType.ENUM:
                    value.push(input.readEnum());
                    break;
                case FieldDescriptorType.FLOAT:
                    value.push(input.readFloat());
                    break;
                case FieldDescriptorType.DOUBLE:
                    value.push(input.readDouble());
                    break;
                case FieldDescriptorType.INT32:
                    value.push(input.readInt32());
                    break;
                case FieldDescriptorType.UINT32:
                    value.push(input.readUInt32());
                    break;
                case FieldDescriptorType.FIXED32:
                    value.push(input.readFixed32());
                    break;
                case FieldDescriptorType.SINT32:
                    value.push(input.readSInt32());
                    break;
                case FieldDescriptorType.SFIXED32:
                    value.push(input.readSFixed32());
                    break;
                case FieldDescriptorType.INT64:
                    value.push(input.readInt64());
                    break;
                case FieldDescriptorType.UINT64:
                    value.push(input.readUInt64());
                    break;
                case FieldDescriptorType.FIXED64:
                    value.push(input.readFixed64());
                    break;
                case FieldDescriptorType.SINT64:
                    value.push(input.readSInt64());
                    break;
                case FieldDescriptorType.SFIXED64:
                    value.push(input.readSFixed64());
                    break;
                default:
                    throw new Error("Unknown type: " + type);
            }
        }
    }

    // -----------------------------------------------------------------
    private function readRawByte():int {
        if (_bytesAvailable <= 0) {
            throw InvalidProtocolBufferException.truncatedMessage();
        }

        _bytesAvailable--;

        return _buffer.readByte();
    }

    private function readRawBytes(length:int):ByteArray {
        if (length < 0) {
            throw InvalidProtocolBufferException.negativeSize();
        }

        if (length > _bytesAvailable) {
            throw InvalidProtocolBufferException.truncatedMessage();
        }

        var bytes:ByteArray = new ByteArray();

        if (length != 0) {
            _bytesAvailable -= length;
            _buffer.readBytes(bytes, 0, length);
        }

        return bytes;
    }

    private function readRawVarint32():int {
        var tmp:int = readRawByte();
        if (tmp >= 0) {
            return tmp;
        }
        var result:int = tmp & 0x7f;
        if ((tmp = readRawByte()) >= 0) {
            result |= tmp << 7;
        } else {
            result |= (tmp & 0x7f) << 7;
            if ((tmp = readRawByte()) >= 0) {
                result |= tmp << 14;
            } else {
                result |= (tmp & 0x7f) << 14;
                if ((tmp = readRawByte()) >= 0) {
                    result |= tmp << 21;
                } else {
                    result |= (tmp & 0x7f) << 21;
                    result |= (tmp = readRawByte()) << 28;
                    if (tmp < 0) {
                        // Discard upper 32 bits.
                        for (var i:int = 0; i < 5; i++) {
                            if (readRawByte() >= 0) {
                                return result;
                            }
                        }
                        throw InvalidProtocolBufferException.malformedVarint();
                    }
                }
            }
        }
        return result;
    }

    private function readRawLittleEndian32():int {
        var b1:int = readRawByte();
        var b2:int = readRawByte();
        var b3:int = readRawByte();
        var b4:int = readRawByte();
        return (b1 & 0xff) | ((b2 & 0xff) << 8) | ((b3 & 0xff) << 16) | ((b4 & 0xff) << 24);
    }

    private function readRawVarint64():Int64 {
        var shift:int = 0;
        var result:Int64 = new Int64(0, 0);
        while (shift < 64) {
            var b:int = readRawByte();
            // result |= (long)(b & 0x7F) << shift;
            result = result.or(new Int64(0, b & 0x7F).shiftLeft(shift));
            if ((b & 0x80) == 0) {
                return result;
            }
            shift += 7;
        }
        throw InvalidProtocolBufferException.malformedVarint();
    }

    private function readRawLittleEndian64():Int64 {
        var low:int = readRawLittleEndian32();
        var high:int = readRawLittleEndian32();

        return new Int64(high, low);
    }

    private static function decodeZigZag32(n:int):int {
        return (n >>> 1) ^ -(n & 1);
    }

    private static function decodeZigZag64(n:Int64):Int64 {
        //return (n >>> 1) ^ -(n & 1);
        return n.shiftRight(1).xor(new Int64(-(n.low & 1), -(n.low & 1)));
    }

    private static function intBitsToFloat(value:int):Number {
        var bytes:ByteArray = new ByteArray();
        bytes.endian = Endian.LITTLE_ENDIAN;
        bytes.writeInt(value);
        bytes.position = 0;

        return bytes.readFloat();
    }

    private static function longBitsToDouble(value:Int64):Number {
        var bytes:ByteArray = new ByteArray();
        bytes.endian = Endian.LITTLE_ENDIAN;
        bytes.writeInt(value.low);
        bytes.writeInt(value.high);
        bytes.position = 0;

        return bytes.readDouble();
    }
}
}

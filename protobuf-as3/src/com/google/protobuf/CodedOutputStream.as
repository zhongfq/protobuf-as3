package com.google.protobuf {
import flash.events.Event;
import flash.utils.ByteArray;
import flash.utils.Dictionary;
import flash.utils.Endian;
import flash.utils.IDataOutput;

public class CodedOutputStream {
    private var _buffer:IDataOutput;

    public function CodedOutputStream(output:IDataOutput) {
        _buffer = output;
    }

    //-------------------------------------------------------------------------

    public function writeTag(fieldNumber:int, wireType:int):void {
        writeRawVarint32(WireFormat.makeTag(fieldNumber, wireType));
    }

    public function writeInt32(fieldNumber:int, value:int):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_VARINT);
        writeInt32NoTag(value);
    }

    public function writeUInt32(fieldNumber:int, value:int):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_VARINT);
        writeUInt32NoTag(value);
    }

    public function writeSInt32(fieldNumber:int, value:int):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_VARINT);
        writeSInt32NoTag(value);
    }

    public function writeFixed32(fieldNumber:int, value:int):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_FIXED32);
        writeFixed32NoTag(value);
    }

    public function writeSFixed32(fieldNumber:int, value:int):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_FIXED32);
        writeSFixed32NoTag(value);
    }

    public function writeInt64(fieldNumber:int, value:Int64):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_VARINT);
        writeInt64NoTag(value);
    }

    public function writeUInt64(fieldNumber:int, value:Int64):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_VARINT);
        writeUInt64NoTag(value);
    }

    public function writeSInt64(fieldNumber:int, value:Int64):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_VARINT);
        writeSInt64NoTag(value);
    }

    public function writeFixed64(fieldNumber:int, value:Int64):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_FIXED64);
        writeFixed64NoTag(value);
    }

    public function writeSFixed64(fieldNumber:int, value:Int64):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_FIXED64);
        writeSFixed64NoTag(value);
    }

    public function writeFloat(fieldNumber:int, value:Number):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_FIXED32);
        writeFloatNoTag(value);
    }

    public function writeDouble(fieldNumber:int, value:Number):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_FIXED64);
        writeDoubleNoTag(value);
    }

    public function writeBool(fieldNumber:int, value:Boolean):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_VARINT);
        writeBoolNoTag(value);
    }

    public function writeEnum(fieldNumber:int, value:Enum):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_VARINT);
        writeEnumNoTag(value);
    }

    public function writeString(fieldNumber:int, value:String):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_LENGTH_DELIMITED);
        writeStringNoTag(value);
    }

    public function writeBytes(fieldNumber:int, value:ByteArray):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_LENGTH_DELIMITED);
        writeBytesNoTag(value);
    }

    public function writeMessage(fieldNumber:int, value:Message):void {
        writeTag(fieldNumber, WireFormat.WIRETYPE_LENGTH_DELIMITED);
        writeMessageNoTag(value);
    }

    public function writeMap(entries:Vector.<MapEntry>, filedNumber:int, keyType:int, valueType:int):void {
        for each(var entry:MapEntry in entries) {
            if (entry.value != null && entry.key != null) {
                var bytes:ByteArray = new ByteArray();
                var output:CodedOutputStream = new CodedOutputStream(bytes);
                output.writeField(1, keyType, entry.key);
                output.writeField(2, valueType, entry.value);

                writeTag(filedNumber, WireFormat.WIRETYPE_LENGTH_DELIMITED);
                writeRawVarint32(bytes.length);
                writeRawBytes(bytes);
            }
        }
    }

    public function writeVector(value:*, number:int, type:int):void {
        for (var i:int = 0; i < value.length; i++) {
            if (value[i] != null) {
                writeField(number, type, value[i]);
            }
        }
    }

    public function writePackedVector(value:*, number:int, type:int):void {
        var bytes:ByteArray = new ByteArray();
        var output:CodedOutputStream = new CodedOutputStream(bytes);
        for (var i:int = 0; i < value.length; i++) {
            if (value[i] == null) {
                continue;
            }
            switch (type) {
                case FieldDescriptorType.DOUBLE:
                    output.writeDoubleNoTag(value[i]);
                    break;
                case FieldDescriptorType.FLOAT:
                    output.writeFloatNoTag(value[i]);
                    break;
                case FieldDescriptorType.INT64:
                    output.writeInt64NoTag(value[i]);
                    break;
                case FieldDescriptorType.UINT64:
                    output.writeUInt64NoTag(value[i]);
                    break;
                case FieldDescriptorType.INT32:
                    output.writeInt32NoTag(value[i]);
                    break;
                case FieldDescriptorType.FIXED64:
                    output.writeFixed64NoTag(value[i]);
                    break;
                case FieldDescriptorType.FIXED32:
                    output.writeFixed32NoTag(value[i]);
                    break;
                case FieldDescriptorType.BOOL:
                    output.writeBoolNoTag(value[i]);
                    break;
                case FieldDescriptorType.UINT32:
                    output.writeUInt32NoTag(value[i]);
                    break;
                case FieldDescriptorType.ENUM:
                    output.writeEnumNoTag(value[i]);
                    break;
                case FieldDescriptorType.SFIXED32:
                    output.writeSFixed32NoTag(value[i]);
                    break;
                case FieldDescriptorType.SFIXED64:
                    output.writeSFixed64NoTag(value[i]);
                    break;
                case FieldDescriptorType.SINT32:
                    output.writeSInt32NoTag(value[i]);
                    break;
                case FieldDescriptorType.SINT64:
                    output.writeSInt64NoTag(value[i]);
                    break;
                default:
                    throw new Error("Unknown type: " + type);
            }
        }

        writeTag(number, WireFormat.WIRETYPE_LENGTH_DELIMITED);
        writeRawVarint32(bytes.length);
        writeRawBytes(bytes);
    }

    // ------------------------------------------------------------------------

    private function writeField(number:int, type:int, value:Object):void {
        switch (type) {
            case FieldDescriptorType.DOUBLE:
                writeDouble(number, value as Number);
                break;
            case FieldDescriptorType.FLOAT:
                writeFloat(number, value as Number);
                break;
            case FieldDescriptorType.INT64:
                writeInt64(number, value as Int64);
                break;
            case FieldDescriptorType.UINT64:
                writeUInt64(number, value as Int64);
                break;
            case FieldDescriptorType.INT32:
                writeInt32(number, value as int);
                break;
            case FieldDescriptorType.FIXED64:
                writeFixed64(number, value as Int64);
                break;
            case FieldDescriptorType.FIXED32:
                writeFixed32(number, value as int);
                break;
            case FieldDescriptorType.BOOL:
                writeBool(number, value as Boolean);
                break;
            case FieldDescriptorType.STRING:
                writeString(number, value as String);
                break;
            case FieldDescriptorType.BYTES:
                writeBytes(number, value as ByteArray);
                break;
            case FieldDescriptorType.UINT32:
                writeUInt32(number, value as int);
                break;
            case FieldDescriptorType.ENUM:
                writeEnum(number, value as Enum);
                break;
            case FieldDescriptorType.SFIXED32:
                writeSFixed32(number, value as int);
                break;
            case FieldDescriptorType.SFIXED64:
                writeSFixed64(number, value as Int64);
                break;
            case FieldDescriptorType.SINT32:
                writeSInt32(number, value as int);
                break;
            case FieldDescriptorType.SINT64:
                writeSInt64(number, value as Int64);
                break;
            case FieldDescriptorType.MESSAGE:
                writeMessage(number, value as Message);
                break;
            default:
                throw new Error("Unknown type: " + type);
        }
    }

    private function writeInt32NoTag(value:int):void {
        if (value >= 0) {
            writeRawVarint32(value);
        } else {
            writeRawVarint64(new Int64(~0, value));
        }
    }

    private function writeUInt32NoTag(value:int):void {
        writeRawVarint32(value);
    }

    private function writeSInt32NoTag(value:int):void {
        writeRawVarint32(encodeZigZag32(value));
    }

    private function writeFixed32NoTag(value:int):void {
        writeRawLittleEndian32(value);
    }

    private function writeSFixed32NoTag(value:int):void {
        writeRawLittleEndian32(value);
    }

    private function writeInt64NoTag(value:Int64):void {
        writeRawVarint64(value);
    }

    private function writeUInt64NoTag(value:Int64):void {
        writeRawVarint64(value);
    }

    private function writeSInt64NoTag(value:Int64):void {
        writeRawVarint64(encodeZigZag64(value));
    }

    private function writeFixed64NoTag(value:Int64):void {
        writeRawLittleEndian64(value);
    }

    private function writeSFixed64NoTag(value:Int64):void {
        writeRawLittleEndian64(value);
    }

    private function writeFloatNoTag(value:Number):void {
        writeRawLittleEndian32(floatToRawIntBits(value));
    }

    private function writeDoubleNoTag(value:Number):void {
        writeRawLittleEndian64(doubleToRawLongBits(value));
    }

    private function writeBoolNoTag(value:Boolean):void {
        writeRawByte(value ? 1 : 0);
    }

    private function writeEnumNoTag(value:Enum):void {
        writeRawVarint32(value.value);
    }

    private function writeStringNoTag(value:String):void {
        var bytes:ByteArray = new ByteArray();
        bytes.writeUTFBytes(value);
        writeBytesNoTag(bytes);
    }

    private function writeBytesNoTag(value:ByteArray):void {
        writeRawVarint32(value.length);
        writeRawBytes(value);
    }

    private function writeMessageNoTag(value:Message):void {
        var bytes:ByteArray = new ByteArray();
        value.writeTo(new CodedOutputStream(bytes));
        writeBytesNoTag(bytes);
    }

    // ------------------------------------------------------------------------

    private function writeRawByte(value:int):void {
        _buffer.writeByte(value);
    }

    private function writeRawBytes(value:ByteArray):void {
        _buffer.writeBytes(value, 0, value.length);
    }

    private function writeRawVarint32(value:int):void {
        while (true) {
            if ((value & ~0x7F) == 0) {
                writeRawByte(value);
                return;
            } else {
                writeRawByte((value & 0x7F) | 0x80);
                value >>>= 7;
            }
        }
    }

    private function writeRawLittleEndian32(value:int):void {
        writeRawByte((value) & 0xFF);
        writeRawByte((value >>> 8) & 0xFF);
        writeRawByte((value >>> 16) & 0xFF);
        writeRawByte((value >>> 24) & 0xFF);
    }

    private function writeRawVarint64(value:Int64):void {
        while (true) {
            if (value.high == 0 && ((value.low & ~0x7F) == 0)) {
                writeRawByte(value.low);
                return;
            } else {
                writeRawByte((value.low & 0x7F) | 0x80);
                value = value.shiftRight(7);
            }
        }
    }

    private function writeRawLittleEndian64(value:Int64):void {
        writeRawByte((value.low >>> 0) & 0xFF);
        writeRawByte((value.low >>> 8) & 0xFF);
        writeRawByte((value.low >>> 16) & 0xFF);
        writeRawByte((value.low >>> 24) & 0xFF);
        writeRawByte((value.high >>> 0) & 0xFF);
        writeRawByte((value.high >>> 8) & 0xFF);
        writeRawByte((value.high >>> 16) & 0xFF);
        writeRawByte((value.high >>> 24) & 0xFF);
    }

    private static function encodeZigZag32(n:int):int {
        // Note:  the right-shift must be arithmetic
        return (n << 1) ^ (n >> 31);
    }

    private static function encodeZigZag64(n:Int64):Int64 {
        // Note:  the right-shift must be arithmetic
        // return (n << 1) ^ (n >> 63);
        return n.shiftLeft(1).xor(n.shiftRight(63));
    }

    private static function floatToRawIntBits(value:Number):int {
        var bytes:ByteArray = new ByteArray();
        bytes.endian = Endian.LITTLE_ENDIAN;
        bytes.writeFloat(value);
        bytes.position = 0;

        return bytes.readInt();
    }

    private static function doubleToRawLongBits(value:Number):Int64 {
        var bytes:ByteArray = new ByteArray();
        bytes.endian = Endian.LITTLE_ENDIAN;
        bytes.writeDouble(value);
        bytes.position = 0;

        var low:int = bytes.readInt();
        var high:int = bytes.readInt();

        return new Int64(high, low);
    }
}
}

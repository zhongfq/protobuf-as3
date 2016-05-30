package com.google.protobuf {
public class WireFormat {
    public static const WIRETYPE_VARINT:int = 0;
    public static const WIRETYPE_FIXED64:int = 1;
    public static const WIRETYPE_LENGTH_DELIMITED:int = 2;
    public static const WIRETYPE_START_GROUP:int = 3;
    public static const WIRETYPE_END_GROUP:int = 4;
    public static const WIRETYPE_FIXED32:int = 5;

    internal static const TAG_TYPE_BITS:int = 3;
    internal static const TAG_TYPE_MASK:int = (1 << TAG_TYPE_BITS) - 1;

    public static function getTagWireType(tag:int):int {
        return tag & TAG_TYPE_MASK;
    }

    public static function getTagFieldNumber(tag:int):int {
        return tag >> TAG_TYPE_BITS;
    }

    internal static function makeTag(fieldNumber:int, wireType:int):int {
        return (fieldNumber << TAG_TYPE_BITS) | wireType;
    }
}
}

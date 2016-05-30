package com.google.protobuf {
public class Enum {
    private var _value:int;
    public function Enum(value:int) {
        _value = value;
    }

    public function get value():int {
        return _value;
    }
}
}

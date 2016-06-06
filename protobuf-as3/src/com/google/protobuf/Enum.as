package com.google.protobuf {
public class Enum {
    private var _value:int;
    private var _name:String;

    public function Enum(name:String, value:int) {
        _name = name;
        _value = value;
    }

    public function get value():int {
        return _value;
    }

    public function get name():String {
        return _name;
    }

    public function toString():String {
        return "(name=" + _name + ", value=" + value + ")";
    }
}
}

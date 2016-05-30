package com.google.protobuf {
public class MapEntry {
    private var _key:*;
    private var _value:*;
    public function MapEntry(key:*, value:*) {
        _key = key;
        _value = value;
    }

    public function get key():* {
        return _key;
    }

    public function set key(value:*):void {
        _key = value;
    }

    public function get value():* {
        return _value;
    }

    public function set value(value:*):void {
        _value = value;
    }
}
}

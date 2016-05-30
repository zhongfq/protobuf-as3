package com.google.protobuf {
public class Int64 {
    private var _high:int;
    private var _low:uint;

    public function Int64(high:int = 0, low:uint = 0) {
        _high = high;
        _low = low;
    }

    public function get low():uint {
        return _low;
    }

    public function set low(value:uint):void {
        _low = value;
    }

    public function get high():int {
        return _high;
    }

    public function set high(value:int):void {
        _high = value;
    }

    public function isZero():Boolean {
        return _high == 0 && _low == 0;
    }

    public function toString():String {
        var high:String = "00000000" + uint(_high).toString(16);
        var low:String = "00000000" + uint(_low).toString(16);

        return "0x" + high.substr(high.length - 8) + low.substr(low.length - 8);
    }

    public function equal(other:Int64):Boolean {
        return other._high == _high && other._low == _low;
    }

    public function shiftRight(bit:int):Int64 {
        var high:int = _high;
        var low:uint = _low;

        if (bit >= 64) {
            high = 0;
            low = 0;
        } else if (bit >= 32) {
            bit -= 32;
            low = high >>> bit;
            high = 0;
        } else if (bit > 0) {
            low >>>= bit;
            low |= (high & ((1 << bit) - 1)) << (32 - bit);
            high >>>= bit;
        }

        return new Int64(high, low);
    }

    public function shiftLeft(bit:int):Int64 {
        var high:int = _high;
        var low:uint = _low;

        if (bit >= 64) {
            high = 0;
            low = 0;
        } else if (bit >= 32) {
            bit -= 32;
            high = low << bit;
            low = 0;
        } else if (bit > 0) {
            high <<= bit;
            high |= low >>> (32 - bit);
            low <<= bit;
        }

        return new Int64(high, low);
    }

    public function xor(other:Int64):Int64 {
        return new Int64(_high ^ other._high, _low ^ other.low);
    }

    public function and(other:Int64):Int64 {
        return new Int64(_high & other._high, _low & other.low);
    }

    public function or(other:Int64):Int64 {
        return new Int64(_high | other._high, _low | other.low);
    }
}
}

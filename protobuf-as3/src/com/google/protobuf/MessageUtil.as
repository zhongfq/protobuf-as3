package com.google.protobuf {

import flash.utils.ByteArray;

public class MessageUtil {
    public static function clone(message:Message):* {
        var bytes:ByteArray = new ByteArray();
        message.writeTo(new CodedOutputStream(bytes));

        var newMsg:Message = new message['constructor']();
        bytes.position = 0;
        newMsg.readFrom(new CodedInputStream(bytes));
        return newMsg;
    }
}
}

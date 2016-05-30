package com.google.protobuf.compiler.as3;

import com.google.protobuf.DescriptorProtos.DescriptorProto;
import com.google.protobuf.DescriptorProtos.FieldDescriptorProto;
import com.google.protobuf.WireFormat;

import java.util.Map;

public class Util {
    public static void printError(String fmt, Object... args) {
        System.err.println(String.format(fmt, args));
        System.err.println();
        System.err.flush();
    }

    public static String makeCapitalizedName(String name) {
        return name.substring(0, 1).toUpperCase() + name.substring(1);
    }

    public static String getCapitalizedType(FieldDescriptorProto descriptor) {
        switch (descriptor.getType()) {
            case TYPE_DOUBLE:
                return "Double";
            case TYPE_FLOAT:
                return "Float";
            case TYPE_INT64:
                return "Int64";
            case TYPE_UINT64:
                return "UInt64";
            case TYPE_INT32:
                return "Int32";
            case TYPE_FIXED64:
                return "Fixed64";
            case TYPE_FIXED32:
                return "Fixed32";
            case TYPE_BOOL:
                return "Bool";
            case TYPE_STRING:
                return "String";
            case TYPE_MESSAGE:
                return "Message";
            case TYPE_BYTES:
                return "Bytes";
            case TYPE_UINT32:
                return "UInt32";
            case TYPE_ENUM:
                return "Enum";
            case TYPE_SFIXED32:
                return "SFixed32";
            case TYPE_SFIXED64:
                return "SFixed64";
            case TYPE_SINT32:
                return "SInt32";
            case TYPE_SINT64:
                return "SInt64";
        }

        return null;
    }

    public static String getASFieldType(FieldDescriptorProto descriptor) {
        switch (descriptor.getType()) {
            case TYPE_DOUBLE:
                return "FieldDescriptorType.DOUBLE";
            case TYPE_FLOAT:
                return "FieldDescriptorType.FLOAT";
            case TYPE_INT64:
                return "FieldDescriptorType.INT64";
            case TYPE_UINT64:
                return "FieldDescriptorType.UINT64";
            case TYPE_INT32:
                return "FieldDescriptorType.INT32";
            case TYPE_FIXED64:
                return "FieldDescriptorType.FIXED64";
            case TYPE_FIXED32:
                return "FieldDescriptorType.FIXED32";
            case TYPE_BOOL:
                return "FieldDescriptorType.BOOL";
            case TYPE_STRING:
                return "FieldDescriptorType.STRING";
            case TYPE_GROUP:
                return "FieldDescriptorType.GROUP";
            case TYPE_MESSAGE:
                return "FieldDescriptorType.MESSAGE";
            case TYPE_BYTES:
                return "FieldDescriptorType.BYTES";
            case TYPE_UINT32:
                return "FieldDescriptorType.UINT32";
            case TYPE_ENUM:
                return "FieldDescriptorType.ENUM";
            case TYPE_SFIXED32:
                return "FieldDescriptorType.SFIXED32";
            case TYPE_SFIXED64:
                return "FieldDescriptorType.SFIXED64";
            case TYPE_SINT32:
                return "FieldDescriptorType.SINT32";
            case TYPE_SINT64:
                return "FieldDescriptorType.SINT64";
        }

        return "";
    }

    public static String getASClass(FieldDescriptorProto descriptor) {
        switch (descriptor.getType()) {
            case TYPE_DOUBLE:
            case TYPE_FLOAT:
                return "Number";
            case TYPE_INT64:
            case TYPE_UINT64:
            case TYPE_FIXED64:
            case TYPE_SFIXED64:
            case TYPE_SINT64:
                return "Int64";
            case TYPE_INT32:
            case TYPE_FIXED32:
            case TYPE_UINT32:
            case TYPE_SFIXED32:
            case TYPE_SINT32:
                return "int";
            case TYPE_BOOL:
                return "Boolean";
            case TYPE_STRING:
                return "String";
            case TYPE_MESSAGE:
                return "Message";
            case TYPE_BYTES:
                return "ByteArray";
            case TYPE_ENUM:
                return "int";
        }

        return null;
    }

    public static String getASClass(FieldDescriptorProto descriptor, Map<String, String> classRef) {
        if (isMessage(descriptor)) {
            return classRef.get(descriptor.getTypeName());
        } else {
            return getASClass(descriptor);
        }
    }

    public static String getASImportClass(FieldDescriptorProto descriptor, Map<String, String> classRef) {
        switch (descriptor.getType()) {
            case TYPE_MESSAGE:
                return classRef.get(descriptor.getTypeName());
            case TYPE_BYTES:
                return "flash.utils.ByteArray";
        }
        return null;
    }

    public static String getASDefaultValue(FieldDescriptorProto descriptor) {
        switch (descriptor.getType()) {
            case TYPE_DOUBLE:
            case TYPE_FLOAT:
                return "0";
            case TYPE_INT64:
            case TYPE_UINT64:
            case TYPE_FIXED64:
            case TYPE_SFIXED64:
            case TYPE_SINT64:
                return "new Int64(0, 0)";
            case TYPE_INT32:
            case TYPE_FIXED32:
            case TYPE_UINT32:
            case TYPE_SFIXED32:
            case TYPE_SINT32:
                return "0";
            case TYPE_BOOL:
                return "false";
            case TYPE_STRING:
                return "\"\"";
            case TYPE_MESSAGE:
                return "null";
            case TYPE_BYTES:
                return "new ByteArray()";
            case TYPE_ENUM:
                return "0";
        }

        return null;
    }

    public static boolean isMapEntry(DescriptorProto descriptor) {
        return descriptor != null && descriptor.hasOptions() && descriptor.getOptions().getMapEntry();
    }

    public static boolean isMessage(FieldDescriptorProto descriptor) {
        return descriptor.getType() == FieldDescriptorProto.Type.TYPE_MESSAGE;
    }

    public static String makeScope(String parent, String name) {
        if (parent.length() > 0) {
            return parent + "." + name;
        } else {
            return name;
        }
    }

    public static String makeClassName(String scope, String name) {
        if (scope.length() > 0) {
            return scope + "." + name;
        } else {
            return name;
        }
    }

    public static String makeQualifiedClassName(String packageName, String scope, String name) {
        if (packageName.length() > 0) {
            return "." + packageName + "." + makeClassName(scope, name);
        } else {
            return "." + makeClassName(scope, name);
        }
    }

    public static String makeASClassName(String scope, String name) {
        if (scope.length() > 0) {
            return scope.replace('.', '$') + "$" + name;
        } else {
            return name;
        }
    }

    public static String makeASQualifiedClassName(String packageName, String scope, String name) {
        if (packageName.length() > 0) {
            return packageName + "." + makeASClassName(scope, name);
        } else {
            return makeASClassName(scope, name);
        }
    }

    public static int makeTag(FieldDescriptorProto descriptor) {
        switch (descriptor.getType()) {
            case TYPE_STRING:
            case TYPE_GROUP:
            case TYPE_BYTES:
            case TYPE_MESSAGE:
                return descriptor.getNumber() << 3 | WireFormat.WIRETYPE_LENGTH_DELIMITED;
            case TYPE_SFIXED32:
            case TYPE_FLOAT:
            case TYPE_FIXED32:
                return descriptor.getNumber() << 3 | WireFormat.WIRETYPE_FIXED32;
            case TYPE_SFIXED64:
            case TYPE_FIXED64:
            case TYPE_DOUBLE:
                return descriptor.getNumber() << 3 | WireFormat.WIRETYPE_FIXED64;
            case TYPE_SINT32:
            case TYPE_SINT64:
            case TYPE_INT64:
            case TYPE_UINT64:
            case TYPE_INT32:
            case TYPE_BOOL:
            case TYPE_UINT32:
            case TYPE_ENUM:
                //noinspection PointlessBitwiseExpression
                return descriptor.getNumber() << 3 | WireFormat.WIRETYPE_VARINT;
        }

        System.err.println("unknow type: " + descriptor.getType());
        System.err.println(descriptor.toString());
        System.err.flush();

        return 0;
    }

    public static String makeCompareDefaultValueExp(FieldDescriptorProto descriptor) {
        switch (descriptor.getType()) {
            case TYPE_DOUBLE:
            case TYPE_FLOAT:
            case TYPE_INT32:
            case TYPE_SINT32:
            case TYPE_FIXED32:
            case TYPE_UINT32:
            case TYPE_SFIXED32:
                return " == 0";
            case TYPE_ENUM:
                return ".value == 0";
            case TYPE_BOOL:
                return " == false";
            case TYPE_STRING:
                return ".length == 0";
            case TYPE_GROUP:
            case TYPE_MESSAGE:
                return " == null";
            case TYPE_BYTES:
                return ".length == 0";
            case TYPE_SINT64:
            case TYPE_SFIXED64:
            case TYPE_FIXED64:
            case TYPE_INT64:
            case TYPE_UINT64:
                return ".isZero()";
        }

        Util.printError("unknown type: %d\n%s", descriptor.getType(), descriptor.toString());

        return "";
    }

    public static boolean isTypePackable(FieldDescriptorProto descriptor) {
        FieldDescriptorProto.Type type = descriptor.getType();
        return type != FieldDescriptorProto.Type.TYPE_MESSAGE &&
                type != FieldDescriptorProto.Type.TYPE_GROUP &&
                type != FieldDescriptorProto.Type.TYPE_STRING &&
                type != FieldDescriptorProto.Type.TYPE_BYTES;
    }
}

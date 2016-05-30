package com.google.protobuf.compiler.as3;

import com.google.protobuf.DescriptorProtos.DescriptorProto;
import com.google.protobuf.DescriptorProtos.FieldDescriptorProto;
import com.google.protobuf.WireFormat;

import java.util.HashMap;
import java.util.Map;

public class FieldGenerator {

    protected FieldDescriptorProto _descriptor;
    protected HashMap<String, String> _variables = new HashMap<>();

    public FieldGenerator(FieldDescriptorProto descriptor) {
        _descriptor = descriptor;

        _variables.put("number", String.valueOf(_descriptor.getNumber()));
        _variables.put("default_value", Util.getASDefaultValue(descriptor));
        _variables.put("type", Util.getASClass(descriptor));
        _variables.put("name", descriptor.getJsonName());
        _variables.put("capitalized_name", Util.makeCapitalizedName(descriptor.getJsonName()));
        _variables.put("capitalized_type", Util.getCapitalizedType(descriptor));
        _variables.put("tag", String.valueOf(Util.makeTag(descriptor)));
        _variables.put("is_default", Util.makeCompareDefaultValueExp(descriptor));
        _variables.put("field_type", Util.getASFieldType(descriptor));

        //string bytes int64属于标量，不能为null
        String type = Util.getASClass(_descriptor);
        if ("String".equals(type) || "Int64".equals(type) || "ByteArray".equals(type)) {
            _variables.put("assign", "value || " + _variables.get("default_value"));
        } else {
            _variables.put("assign", "value");
        }
    }

    public void generateAccessorCode(Printer printer) {

    }

    public void generateWriteToCode(Printer printer) {

    }

    public void generateReadFromCode(Printer printer) {

    }

    public static class PrimitiveFieldGenerator extends FieldGenerator {
        public PrimitiveFieldGenerator(FieldDescriptorProto descriptor) {
            super(descriptor);
        }

        @Override
        public void generateAccessorCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "private var _#name#:#type# = #default_value#;\n" +
                    "public function get #name#():#type# {\n" +
                    "    return _#name#;\n" +
                    "}\n" +
                    "public function set #name#(value:#type#):void {\n" +
                    "    _#name# = #assign#;\n" +
                    "}");
        }

        @Override
        public void generateWriteToCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "if (!(_#name##is_default#)) {\n" +
                    "    output.write#capitalized_type#(#number#, _#name#);\n" +
                    "}");
        }

        @Override
        public void generateReadFromCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "case #tag#: {\n" +
                    "    _#name# = input.read#capitalized_type#();\n" +
                    "    break;\n" +
                    "}");
        }
    }

    public static class PrimitiveOneofFieldGenerator extends PrimitiveFieldGenerator {
        public PrimitiveOneofFieldGenerator(FieldDescriptorProto descriptor, String oneof) {
            super(descriptor);

            _variables.put("oneof_name", oneof);
            _variables.put("oneof_case", oneof + "Case");
            _variables.put("oneof_capitalized_name", Util.makeCapitalizedName(oneof));
        }

        @Override
        public void generateAccessorCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "public function has#capitalized_name#():Boolean {\n" +
                    "    return _#oneof_case# == #number#;\n" +
                    "}");

            printer.writeln(_variables, "" +
                    "public function get #name#():#type# {\n" +
                    "    return _#oneof_case# == #number# ? _#oneof_name# : #default_value#;\n" +
                    "}");

            printer.writeln(_variables, "" +
                    "public function set #name#(value:#type#):void {\n" +
                    "    _#oneof_case# = #number#;\n" +
                    "    _#oneof_name# = #assign#;\n" +
                    "}");
        }

        @Override
        public void generateWriteToCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "if (_#oneof_case# == #number#) {\n" +
                    "    output.write#capitalized_type#(#number#, _#oneof_name#);\n" +
                    "}");
        }

        @Override
        public void generateReadFromCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "case #tag#: {\n" +
                    "    _#oneof_name# = input.read#capitalized_type#();\n" +
                    "    _#oneof_case# = #number#;\n" +
                    "    break;\n" +
                    "}");
        }
    }

    public static class RepeatedPrimitiveFieldGenerator extends PrimitiveFieldGenerator {
        public RepeatedPrimitiveFieldGenerator(FieldDescriptorProto descriptor) {
            super(descriptor);

            _variables.put("count", _descriptor.getJsonName() + "Count");
            _variables.put("packed_tag", String.valueOf(_descriptor.getNumber() << 3
                    | WireFormat.WIRETYPE_LENGTH_DELIMITED));
        }

        @Override
        public void generateAccessorCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "private var _#name#:Vector.<#type#> = new Vector.<#type#>();\n" +
                    "public function get #name#():Vector.<#type#> {\n" +
                    "    return _#name#;\n" +
                    "}\n" +
                    "public function set #name#(value:Vector.<#type#>):void {\n" +
                    "    _#name# = value || new Vector.<#type#>();\n" +
                    "}");
        }

        @Override
        public void generateWriteToCode(Printer printer) {
            if (Util.isTypePackable(_descriptor)) {
                printer.writeln(_variables, "" +
                        "if (_#name#.length > 0) {\n" +
                        "    output.writePackedVector(_#name#, #number#, #field_type#);\n" +
                        "}");
            } else {
                printer.writeln(_variables, "" +
                        "if (_#name#.length > 0) {\n" +
                        "    output.writeVector(_#name#, #number#, #field_type#);\n" +
                        "}");
            }
        }

        @Override
        public void generateReadFromCode(Printer printer) {
            // packed = false
            printer.writeln(_variables, "" +
                    "case #tag#: {\n" +
                    "    _#name#.push(input.read#capitalized_type#());\n" +
                    "    break;\n" +
                    "}");

            // packed = true
            if (Util.isTypePackable(_descriptor)) {
                printer.writeln(_variables, "" +
                        "case #packed_tag#: {\n" +
                        "    input.readPackedVector(_#name#, #field_type#);\n" +
                        "    break;\n" +
                        "}");
            }
        }
    }

    public static class EnumFieldGenerator extends FieldGenerator {
        public EnumFieldGenerator(FieldDescriptorProto descriptor,
                                  Map<String, String> classRef) {
            super(descriptor);

            _variables.put("type", classRef.get(descriptor.getTypeName()));
            _variables.put("default_value", classRef.get(descriptor.getTypeName()) + ".valueOf(0)");
            _variables.put("assign", "value || " + _variables.get("default_value"));
        }

        @Override
        public void generateAccessorCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "private var _#name#:#type# = #default_value#;\n" +
                    "public function get #name#():#type# {\n" +
                    "    return _#name#;" +
                    "}\n" +
                    "public function set #name#(value:#type#):void {\n" +
                    "    _#name# = #assign#;\n" +
                    "}");
        }

        @Override
        public void generateWriteToCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "if (!(_#name##is_default#)) {\n" +
                    "    output.writeEnum(#number#, _#name#);\n" +
                    "}");
        }

        @Override
        public void generateReadFromCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "case #tag#: {\n" +
                    "    _#name# = #type#.valueOf(input.readEnum());\n" +
                    "    break;\n" +
                    "}");
        }
    }

    public static class EnumOneofFieldGenerator extends EnumFieldGenerator {
        public EnumOneofFieldGenerator(FieldDescriptorProto descriptor,
                                       Map<String, String> classRef,
                                       String oneof) {
            super(descriptor, classRef);

            _variables.put("oneof_name", oneof);
            _variables.put("oneof_case", oneof + "Case");
            _variables.put("oneof_capitalized_name", Util.makeCapitalizedName(oneof));
        }

        @Override
        public void generateAccessorCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "public function has#capitalized_name#():Boolean {\n" +
                    "    return _#oneof_case# == #number#;\n" +
                    "}");

            printer.writeln(_variables, "" +
                    "public function get #name#():#type# {\n" +
                    "    return _#oneof_case# == #number# ? _#oneof_name# : #default_value#;\n" +
                    "}");

            printer.writeln(_variables, "" +
                    "public function set #name#(value:#type#):void {\n" +
                    "    _#oneof_case# = #number#;\n" +
                    "    _#oneof_name# = #assign#;\n" +
                    "}");
        }

        @Override
        public void generateWriteToCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "if (_#oneof_case# == #number#) {\n" +
                    "    output.writeEnum(#number#, _#oneof_name#);\n" +
                    "}");
        }

        @Override
        public void generateReadFromCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "case #tag#: {\n" +
                    "    _#oneof_name# = #type#.valueOf(input.readEnum());\n" +
                    "    _#oneof_case# = #number#;\n" +
                    "    break;\n" +
                    "}");
        }
    }

    public static class RepeatedEnumFieldGenerator extends EnumFieldGenerator {
        public RepeatedEnumFieldGenerator(FieldDescriptorProto descriptor,
                                          Map<String, String> classRef) {
            super(descriptor, classRef);

            _variables.put("count", _descriptor.getJsonName() + "Count");
            _variables.put("packed_tag", String.valueOf(_descriptor.getNumber() << 3
                    | WireFormat.WIRETYPE_LENGTH_DELIMITED));
        }

        @Override
        public void generateAccessorCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "private var _#name#:Vector.<#type#> = new Vector.<#type#>();\n" +
                    "public function get #name#():Vector.<#type#> {\n" +
                    "    return _#name#;\n" +
                    "}\n" +
                    "public function set #name#(value:Vector.<#type#>):void {\n" +
                    "    _#name# = value || new Vector.<#type#>();\n" +
                    "}");
        }

        @Override
        public void generateWriteToCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "if (_#name#.length > 0) {\n" +
                    "    output.writePackedVector(_#name#, #number#, #field_type#);\n" +
                    "}");
        }

        @Override
        public void generateReadFromCode(Printer printer) {
            // packed = false
            printer.writeln(_variables, "" +
                    "case #tag#: {\n" +
                    "    _#name#.push(#type#.valueOf(input.readEnum()));\n" +
                    "    break;\n" +
                    "}");

            // packed = true
            printer.writeln(_variables, "" +
                    "case #packed_tag#: {\n" +
                    "    var #name#Values:Vector.<int> = new Vector.<int>();\n" +
                    "    input.readPackedVector(#name#Values, #field_type#);\n" +
                    "    _#name# = #type#.toEnums(#name#Values);\n" +
                    "    break;\n" +
                    "}");
        }
    }

    public static class MessageFieldGenerator extends FieldGenerator {
        public MessageFieldGenerator(FieldDescriptorProto descriptor,
                                     Map<String, String> classRef) {
            super(descriptor);

            _variables.put("type", classRef.get(descriptor.getTypeName()));
        }

        @Override
        public void generateAccessorCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "private var _#name#:#type# = #default_value#;\n" +
                    "public function get #name#():#type# {\n" +
                    "    return _#name#;\n" +
                    "}\n" +
                    "public function set #name#(value:#type#):void {\n" +
                    "    _#name# = value;\n" +
                    "}");
        }

        @Override
        public void generateWriteToCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "if (!(_#name##is_default#)) {\n" +
                    "    output.writeMessage(#number#, _#name#);\n" +
                    "}");
        }

        @Override
        public void generateReadFromCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "case #tag#: {\n" +
                    "    _#name# = new #type#();\n" +
                    "    input.readMessage(_#name#);\n" +
                    "    break;\n" +
                    "}");
        }
    }

    public static class MessageOneofFieldGenerator extends MessageFieldGenerator {
        public MessageOneofFieldGenerator(FieldDescriptorProto descriptor,
                                          Map<String, String> classRef,
                                          String oneof) {
            super(descriptor, classRef);

            _variables.put("oneof_name", oneof);
            _variables.put("oneof_case", oneof + "Case");
            _variables.put("oneof_capitalized_name", Util.makeCapitalizedName(oneof));
        }

        @Override
        public void generateAccessorCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "public function has#capitalized_name#():Boolean {\n" +
                    "    return _#oneof_case# == #number#;\n" +
                    "}");

            printer.writeln(_variables, "" +
                    "public function get #name#():#type# {\n" +
                    "    return _#oneof_case# == #number# ? _#oneof_name# : #default_value#;\n" +
                    "}");

            printer.writeln(_variables, "" +
                    "public function set #name#(value:#type#):void {\n" +
                    "    _#oneof_case# = #number#;\n" +
                    "    _#oneof_name# = value;\n" +
                    "}");
        }

        @Override
        public void generateWriteToCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "if (_#oneof_case# == #number#) {\n" +
                    "    output.writeMessage(#number#, _#oneof_name#);\n" +
                    "}");
        }

        @Override
        public void generateReadFromCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "case #tag#: {\n" +
                    "    _#oneof_name# = new #type#();\n" +
                    "    input.readMessage(_#oneof_name#);\n" +
                    "    _#oneof_case# = #number#;\n" +
                    "    break;\n" +
                    "}");
        }
    }

    public static class RepeatedMessageFieldGenerator extends MessageFieldGenerator {
        public RepeatedMessageFieldGenerator(FieldDescriptorProto descriptor,
                                             Map<String, String> classRef) {
            super(descriptor, classRef);
        }

        @Override
        public void generateAccessorCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "private var _#name#:Vector.<#type#> = new Vector.<#type#>();\n" +
                    "public function get #name#():Vector.<#type#> {\n" +
                    "    return _#name#;\n" +
                    "}\n" +
                    "public function set #name#(value:Vector.<#type#>):void {\n" +
                    "    _#name# = value || new Vector.<#type#>();\n" +
                    "}");
        }

        @Override
        public void generateWriteToCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "if (_#name#.length > 0) {\n" +
                    "    output.writeVector(_#name#, #number#, #field_type#);\n" +
                    "}");
        }

        @Override
        public void generateReadFromCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "case #tag#: {\n" +
                    "    _#name#.push(input.readMessage(new #type#()));\n" +
                    "    break;\n" +
                    "}");
        }
    }

    public static class MapFieldGenerator extends FieldGenerator {
        public MapFieldGenerator(FieldDescriptorProto descriptor,
                                 DescriptorProto mapDescriptor,
                                 String scope,
                                 Map<String, String> classRef) {
            super(descriptor);

            FieldDescriptorProto.Type valueType = FieldDescriptorProto.Type.TYPE_BOOL;

            for (FieldDescriptorProto keyOrValue : mapDescriptor.getFieldList()) {
                if (keyOrValue.getNumber() == 1) {
                    _variables.put("key_field_type", Util.getASFieldType(keyOrValue));
                    _variables.put("key_type", Util.getASClass(keyOrValue));
                    _variables.put("key_tag", String.valueOf(Util.makeTag(keyOrValue)));
                } else if (keyOrValue.getNumber() == 2) {
                    _variables.put("value_field_type", Util.getASFieldType(keyOrValue));
                    _variables.put("value_type", Util.getASClass(keyOrValue, classRef));
                    _variables.put("value_tag", String.valueOf(Util.makeTag(keyOrValue)));
                    valueType = keyOrValue.getType();
                }
            }

            _variables.put("map_class", Util.makeASClassName(scope, mapDescriptor.getName()));
            if (valueType == FieldDescriptorProto.Type.TYPE_MESSAGE) {
                _variables.put("new_type", "new " + _variables.get("value_type") + "()");
            } else {
                _variables.put("new_type", "null");
            }
        }

        @Override
        public void generateAccessorCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "private var _#name#:#map_class# = new #map_class#();\n" +
                    "public function get #name#():#map_class# {\n" +
                    "    return _#name#;\n" +
                    "}");
        }

        @Override
        public void generateWriteToCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "output.writeMap(_#name#.toArray(), #number#, #key_field_type#,\n" +
                    "        #value_field_type#);");
        }

        @Override
        public void generateReadFromCode(Printer printer) {
            printer.writeln(_variables, "" +
                    "case #tag#: {\n" +
                    "    var #name#Entry:MapEntry = input.readMap(#key_field_type#,\n" +
                    "            #value_field_type#, #new_type#, #key_tag#, #value_tag#);\n" +
                    "    _#name#.putValue(#name#Entry.key, #name#Entry.value);\n" +
                    "    break;\n" +
                    "}");
        }
    }
}

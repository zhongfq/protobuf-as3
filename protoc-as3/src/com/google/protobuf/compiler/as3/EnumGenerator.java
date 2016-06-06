package com.google.protobuf.compiler.as3;

import com.google.protobuf.DescriptorProtos.EnumDescriptorProto;
import com.google.protobuf.DescriptorProtos.EnumValueDescriptorProto;

import java.util.HashMap;
import java.util.Map;

public class EnumGenerator implements IGenerator {
    private EnumDescriptorProto _descriptor;
    private Map<String, String> _variables = new HashMap<>();

    public EnumGenerator(EnumDescriptorProto descriptor,
                         String packageName,
                         String scope) {
        _descriptor = descriptor;
        _variables.put("class", Util.makeASClassName(scope, descriptor.getName()));
        _variables.put("package", packageName);
    }

    @Override
    public void generate(Printer printer) {
        printer.writeln(_variables, "" +
                "package #package# {\n" +
                "import com.google.protobuf.Enum;\n" +
                "\n" +
                "public class #class# extends Enum {");

        for (EnumValueDescriptorProto field : _descriptor.getValueList()) {
            _variables.put("field_name", field.getName());
            _variables.put("field_value", String.valueOf(field.getNumber()));
            printer.writeln(_variables, "" +
                    "    public static const #field_name#:#class# = new #class#(\"#field_name#\", #field_value#);");
            if (field.getNumber() == 0) {
                _variables.put("default_field_value", field.getName());
            }
        }

        printer.writeln();
        printer.writeln(_variables, "" +
                "    public function #class#(name:String, value:int) {\n" +
                "        super(name, value);\n" +
                "    }\n" +
                "    \n" +
                "    public static function valueOf(value:int):#class# {\n" +
                "        switch (value) {\n" +
                "            default:\n" +
                "                return #default_field_value#;");
        printer.indent();
        for (EnumValueDescriptorProto field : _descriptor.getValueList()) {
            _variables.put("field_name", field.getName());
            _variables.put("field_value", String.valueOf(field.getNumber()));
            printer.writeln(_variables, "" +
                    "        case #field_value#:\n" +
                    "            return #field_name#;");
        }
        printer.outdent();
        printer.writeln(_variables, "" +
                "        }\n" +
                "    }\n" +
                "    \n" +
                "    public static function toEnums(values:Vector.<int>):Vector.<#class#> {\n" +
                "        var enums:Vector.<#class#> = new Vector.<#class#>();\n" +
                "        for each (var value:int in values) {\n" +
                "            enums.push(#class#.valueOf(value));\n" +
                "        }\n" +
                "        return enums;\n" +
                "    }\n" +
                "}\n" +
                "}");
    }
}

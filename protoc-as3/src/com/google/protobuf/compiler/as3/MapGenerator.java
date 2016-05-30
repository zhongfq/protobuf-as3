package com.google.protobuf.compiler.as3;

import com.google.protobuf.DescriptorProtos.DescriptorProto;
import com.google.protobuf.DescriptorProtos.FieldDescriptorProto;

import java.util.Arrays;
import java.util.HashMap;
import java.util.HashSet;
import java.util.Map;

public class MapGenerator implements IGenerator {
    private DescriptorProto _descriptor;
    private Map<String, String> _classRef;
    private HashMap<String, String> _variables = new HashMap<>();

    public MapGenerator(DescriptorProto descriptor,
                        Map<String, String> classRef,
                        String packageName,
                        String scope) {
        _descriptor = descriptor;
        _classRef = classRef;

        _variables.put("class", Util.makeASClassName(scope, descriptor.getName()));
        _variables.put("package", packageName);

        for (FieldDescriptorProto keyOrValue : descriptor.getFieldList()) {
            if (keyOrValue.getNumber() == 1) {
                _variables.put("key_type", Util.getASClass(keyOrValue));
            } else if (keyOrValue.getNumber() == 2) {
                _variables.put("value_type", Util.getASClass(keyOrValue, classRef));
            }
        }
    }

    @Override
    public void generate(Printer printer) {
        printer.writeln(_variables, "" +
                "package #package# {");

        // import class
        generateImportClass(printer);
        printer.writeln();

        // class
        printer.writeln(_variables, "" +
                "internal class #class# {\n" +
                "    private var _dict:Dictionary = new Dictionary();\n" +
                "    \n" +
                "    public function #class#() {\n" +
                "    }\n" +
                "    \n" +
                "    public function putValue(key:#key_type#, value:#value_type#):void {\n" +
                "        _dict[key] = value;\n" +
                "    }\n" +
                "    \n" +
                "    public function getValue(key:#key_type#):#value_type# {\n" +
                "        return _dict[key];\n" +
                "    }\n" +
                "    \n" +
                "    public function clean():void {\n" +
                "        _dict = new Dictionary();\n" +
                "    }\n" +
                "    \n" +
                "    public function toArray():Vector.<MapEntry> {\n" +
                "        var values:Vector.<MapEntry> = new Vector.<MapEntry>();\n" +
                "        for (var key:* in _dict) {\n" +
                "            if (key != null && _dict[key] != null) {\n" +
                "                values.push(new MapEntry(key, _dict[key]));\n" +
                "            }\n" +
                "        }\n" +
                "        \n" +
                "        values.sort(Array.CASEINSENSITIVE);\n" +
                "        \n" +
                "        return values;\n" +
                "    }");
        printer.writeln();

        printer.writeln("}"); // class
        printer.writeln("}"); // package
    }

    private void generateImportClass(Printer printer) {
        HashSet<String> classSet = new HashSet<>();

        for (FieldDescriptorProto field : _descriptor.getFieldList()) {
            switch (field.getType()) {
                case TYPE_MESSAGE:
                case TYPE_ENUM:
                    classSet.add(_classRef.get(field.getTypeName()));
                    break;
                case TYPE_BYTES:
                    classSet.add("flash.utils.ByteArray");
                    break;
            }
        }

        classSet.add("com.google.protobuf.*");
        classSet.add("flash.utils.Dictionary");
        classSet.remove(null);

        String[] imports = classSet.toArray(new String[classSet.size()]);
        Arrays.sort(imports);

        for (String clazz : imports) {
            if (clazz != null) {
                printer.writeln("import %s;", clazz);
            }
        }
    }
}

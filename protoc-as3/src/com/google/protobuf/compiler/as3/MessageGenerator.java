package com.google.protobuf.compiler.as3;

import com.google.protobuf.DescriptorProtos.DescriptorProto;
import com.google.protobuf.DescriptorProtos.FieldDescriptorProto;
import com.google.protobuf.DescriptorProtos.OneofDescriptorProto;
import com.google.protobuf.compiler.as3.FieldGenerator.*;

import java.util.*;

public class MessageGenerator implements IGenerator {
    private DescriptorProto _descriptor;
    private Map<String, String> _classRef;
    private String _scope;
    private HashMap<String, DescriptorProto> _nestedTypes = new HashMap<>();
    private ArrayList<FieldGenerator> _fieldGenerators = new ArrayList<>();
    private HashMap<String, String> _variables = new HashMap<>();

    public MessageGenerator(DescriptorProto descriptor,
                            Map<String, String> classRef,
                            String packageName,
                            String scope) {
        _descriptor = descriptor;
        _classRef = classRef;

        _variables.put("class", Util.makeASClassName(scope, descriptor.getName()));
        _variables.put("package", packageName);

        _scope = Util.makeScope(scope, descriptor.getName());
        for (DescriptorProto nestedType : _descriptor.getNestedTypeList()) {
            String qcn = Util.makeQualifiedClassName(packageName, _scope, nestedType.getName());
            _nestedTypes.put(qcn, nestedType);
        }


        makeFieldGenerators();
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
                "public class #class# extends Message {");
        printer.indent();

        // constructor
        printer.writeln(_variables, "" +
                "public function #class#() {\n" +
                "}");
        printer.writeln();

        // oneof
        for (OneofDescriptorProto oneof : _descriptor.getOneofDeclList()) {
            HashMap<String, String> variables = new HashMap<>();
            variables.put("oneof_name", oneof.getName());
            variables.put("oneof_capitalized_name", Util.makeCapitalizedName(oneof.getName()));
            variables.put("oneof_case", oneof.getName() + "Case");

            printer.writeln(variables, "" +
                    "private var _#oneof_case#:int = 0;\n" +
                    "private var _#oneof_name#:* = null;\n" +
                    "public function get #oneof_case#():int {\n" +
                    "    return _#oneof_case#;\n" +
                    "}\n" +
                    "public function clean#oneof_capitalized_name#():void {\n" +
                    "    _#oneof_case# = 0;\n" +
                    "    _#oneof_name# = null;\n" +
                    "}");
            printer.writeln();
        }

        // accessor
        for (FieldGenerator field : _fieldGenerators) {
            field.generateAccessorCode(printer);
            printer.writeln();
        }

        // write to
        printer.writeln(_variables, "" +
                "override public function writeTo(output:CodedOutputStream):void {");
        printer.indent();
        for (FieldGenerator field : _fieldGenerators) {
            field.generateWriteToCode(printer);
        }
        printer.outdent();
        printer.writeln();
        printer.writeln(_variables, "" +
                "    super.writeTo(output);\n" +
                "}");
        printer.writeln();

        // read from
        printer.writeln(_variables, "" +
                "override public function readFrom(input:CodedInputStream):void {\n" +
                "    while(true) {\n" +
                "        var tag:int = input.readTag();\n" +
                "        switch(tag) {\n" +
                "            case 0: {\n" +
                "                return;\n" +
                "            }\n" +
                "            default: {\n" +
                "                if (!input.skipField(tag)) {\n" +
                "                    return;\n" +
                "                }\n" +
                "                break;\n" +
                "            }");
        printer.indent().indent().indent();
        for (FieldGenerator field : _fieldGenerators) {
            field.generateReadFromCode(printer);
        }
        printer.outdent().outdent().outdent();
        printer.writeln(_variables, "" +
                "        }\n" +
                "    }\n" +
                "}");
        printer.writeln();

        printer.outdent();
        printer.writeln("}"); // class
        printer.writeln("}"); // package
    }

    private void generateImportClass(Printer printer) {
        HashSet<String> classSet = new HashSet<>();

        for (FieldDescriptorProto field : _descriptor.getFieldList()) {
            switch (field.getType()) {
                case TYPE_MESSAGE:
                    DescriptorProto entry = _nestedTypes.get(field.getTypeName());
                    if (Util.isMapEntry(entry)) {
                        for (FieldDescriptorProto keyOrValue : entry.getFieldList()) {
                            classSet.add(Util.getASImportClass(keyOrValue, _classRef));
                        }
                    } else {
                        classSet.add(_classRef.get(field.getTypeName()));
                    }
                    break;
                case TYPE_ENUM:
                    classSet.add(_classRef.get(field.getTypeName()));
                    break;
                case TYPE_BYTES:
                    classSet.add("flash.utils.ByteArray");
                    break;
            }
        }

        classSet.add("com.google.protobuf.*");
        classSet.remove(null);

        String[] imports = classSet.toArray(new String[classSet.size()]);
        Arrays.sort(imports);

        for (String clazz : imports) {
            if (clazz != null) {
                printer.writeln("import %s;", clazz);
            }
        }
    }


    private void makeFieldGenerators() {
        for (FieldDescriptorProto field : _descriptor.getFieldList()) {
            if (field.getLabel() == FieldDescriptorProto.Label.LABEL_REPEATED) {
                switch (field.getType()) {
                    case TYPE_MESSAGE:
                        DescriptorProto mapDescriptor = _nestedTypes.get(field.getTypeName());
                        if (Util.isMapEntry(mapDescriptor)) {
                            _fieldGenerators.add(new MapFieldGenerator(field,
                                    mapDescriptor, _scope, _classRef));
                        } else {
                            _fieldGenerators.add(new RepeatedMessageFieldGenerator(field,
                                    _classRef));
                        }
                        break;
                    case TYPE_ENUM:
                        _fieldGenerators.add(new RepeatedEnumFieldGenerator(field, _classRef));
                        break;
                    default:
                        _fieldGenerators.add(new RepeatedPrimitiveFieldGenerator(field));
                        break;
                }
            } else if (field.hasOneofIndex()) {
                String oneof = _descriptor.getOneofDecl(field.getOneofIndex()).getName();
                switch (field.getType()) {
                    case TYPE_MESSAGE:
                        _fieldGenerators.add(new MessageOneofFieldGenerator(field,
                                _classRef, oneof));
                        break;
                    case TYPE_ENUM:
                        _fieldGenerators.add(new EnumOneofFieldGenerator(field, _classRef, oneof));
                        break;
                    default:
                        _fieldGenerators.add(new PrimitiveOneofFieldGenerator(field, oneof));
                        break;
                }
            } else {
                switch (field.getType()) {
                    case TYPE_MESSAGE:
                        _fieldGenerators.add(new MessageFieldGenerator(field, _classRef));
                        break;
                    case TYPE_ENUM:
                        _fieldGenerators.add(new EnumFieldGenerator(field, _classRef));
                        break;
                    default:
                        _fieldGenerators.add(new PrimitiveFieldGenerator(field));
                        break;
                }
            }
        }
    }
}

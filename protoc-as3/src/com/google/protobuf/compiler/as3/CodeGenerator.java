package com.google.protobuf.compiler.as3;

import com.google.protobuf.DescriptorProtos.DescriptorProto;
import com.google.protobuf.DescriptorProtos.EnumDescriptorProto;
import com.google.protobuf.DescriptorProtos.FileDescriptorProto;
import com.google.protobuf.compiler.PluginProtos.CodeGeneratorRequest;
import com.google.protobuf.compiler.PluginProtos.CodeGeneratorResponse;

import java.io.FileOutputStream;
import java.util.HashMap;
import java.util.Map;

public class CodeGenerator {

    public static void main(String[] args) {
        new CodeGenerator();
    }

    private HashMap<String, String> _classRef = new HashMap<>();
    private HashMap<String, IGenerator> _fileToGenerate = new HashMap<>();

    public CodeGenerator() {
        try {
            //writeToFile();
            //CodeGeneratorRequest request = CodeGeneratorRequest.parseFrom(new FileInputStream("E:\\ttsz\\client\\protobuf-as3\\tools\\protobuf.test"));
            CodeGeneratorRequest request = CodeGeneratorRequest.parseFrom(System.in);
            CodeGeneratorResponse.Builder response = CodeGeneratorResponse.newBuilder();

            for (FileDescriptorProto proto : request.getProtoFileList()) {
                buildClassRefs(proto);
            }

            for (FileDescriptorProto proto : request.getProtoFileList()) {
                if (request.getFileToGenerateList().contains(proto.getName())) {
                    if ("proto3".equals(proto.getSyntax())) {
                        buildMessageGenerators(proto);
                    } else {
                        throw new Exception("need syntax=\"proto3\": " + proto.getName());
                    }
                }
            }

            for (Map.Entry<String, IGenerator> entry : _fileToGenerate.entrySet()) {
                Printer printer = new Printer(0);
                entry.getValue().generate(printer);

                CodeGeneratorResponse.File.Builder file = CodeGeneratorResponse.File.newBuilder();
                file.setName(entry.getKey().replace('.', '/') + ".as");
                file.setContent(printer.toString());
                response.addFile(file);
            }

            response.build().writeTo(System.out);
            System.out.flush();
        } catch (Exception e) {
            e.printStackTrace();
        }
    }

    private void writeToFile() {
        try {
            CodeGeneratorRequest request1 = CodeGeneratorRequest.parseFrom(System.in);
            FileOutputStream os = new FileOutputStream("protobuf.test");
            request1.writeTo(new FileOutputStream("protobuf.test"));
            System.err.println("success xxxxxx");
        } catch (Throwable e) {
            e.printStackTrace();
        }
    }

    private void buildClassRefs(FileDescriptorProto fileProto) {
        String packageName = fileProto.getPackage();

        for (DescriptorProto proto : fileProto.getMessageTypeList()) {
            addClassRef(packageName, "", proto);
        }

        for (EnumDescriptorProto proto : fileProto.getEnumTypeList()) {
            addEnumRef(packageName, "", proto);
        }
    }

    private void addClassRef(String packageName, String scope, DescriptorProto descriptor) {
        String name = descriptor.getName();
        if (Util.isMapEntry(descriptor)) {
            _classRef.put(
                    Util.makeQualifiedClassName(packageName, scope, name),
                    Util.makeASQualifiedClassName(packageName, scope, name));
        } else {
            _classRef.put(
                    Util.makeQualifiedClassName(packageName, scope, name),
                    Util.makeASQualifiedClassName(packageName, scope, name));

            for (DescriptorProto nested : descriptor.getNestedTypeList()) {
                addClassRef(packageName, Util.makeScope(scope, name), nested);
            }

            for (EnumDescriptorProto nested : descriptor.getEnumTypeList()) {
                addEnumRef(packageName, Util.makeScope(scope, name), nested);
            }
        }
    }

    private void addEnumRef(String packageName, String scope, EnumDescriptorProto descriptor) {
        String name = descriptor.getName();
        _classRef.put(
                Util.makeQualifiedClassName(packageName, scope, name),
                Util.makeASQualifiedClassName(packageName, scope, name));
    }

    private void buildMessageGenerators(FileDescriptorProto fileProto) {
        String packageName = fileProto.getPackage();

        for (DescriptorProto descriptor : fileProto.getMessageTypeList()) {
            addMessageGenerator(packageName, "", descriptor);
        }

        for (EnumDescriptorProto descriptor : fileProto.getEnumTypeList()) {
            _fileToGenerate.put(
                    Util.makeASQualifiedClassName(packageName, "", descriptor.getName()),
                    new EnumGenerator(descriptor, packageName, ""));
        }
    }

    private void addMessageGenerator(String packageName, String scope, DescriptorProto descriptor) {
        String name = descriptor.getName();
        if (descriptor.hasOptions() && descriptor.getOptions().getMapEntry()) {
            _fileToGenerate.put(
                    Util.makeASQualifiedClassName(packageName, scope, name),
                    new MapGenerator(descriptor, _classRef, packageName, scope));
        } else {
            _fileToGenerate.put(
                    Util.makeASQualifiedClassName(packageName, scope, name),
                    new MessageGenerator(descriptor, _classRef, packageName, scope));

            scope = Util.makeScope(scope, name);

            for (DescriptorProto nestedProto : descriptor.getNestedTypeList()) {
                addMessageGenerator(packageName, scope, nestedProto);
            }

            for (EnumDescriptorProto nestedEnum : descriptor.getEnumTypeList()) {
                _fileToGenerate.put(
                        Util.makeASQualifiedClassName(packageName, scope, nestedEnum.getName()),
                        new EnumGenerator(nestedEnum, packageName, scope));
            }
        }
    }
}

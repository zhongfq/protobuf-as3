package com.google.protobuf.compiler.as3;

import java.util.Map;

public class Printer {
    private int _indent;
    private StringBuilder _content;

    public Printer(int indent) {
        _indent = indent;
        _content = new StringBuilder();
    }

    private void appendSpace(int number) {
        for (int i = 0; i < number; i++) {
            _content.append(' ');
        }
    }

    public Printer indent() {
        _indent += 4;

        return this;
    }

    public Printer outdent() {
        _indent -= 4;

        return this;
    }

    public void writeln(Map<String, String> variables, String fmt) {
        appendSpace(_indent);
        int start = -1;
        int len = fmt.length();
        for (int i = 0; i < len; i++) {
            char c = fmt.charAt(i);
            if (start < 0 || c == '#') {
                if (c == '\n') {
                    _content.append(c);
                    appendSpace(_indent);
                } else if (c == '#') {
                    if (start == -1) {
                        start = i + 1;
                    } else {
                        String name = variables.get(fmt.substring(start, i));
                        if (name != null) {
                            _content.append(name);
                        } else {
                            Util.printError("no variable: %s\n%s", fmt.substring(start, i), fmt);
                        }

                        start = -1;
                    }
                } else {
                    _content.append(c);
                }
            }
        }
        _content.append('\n');

        if (start != -1) {
            Util.printError("invalid variable format: %s\n%s", fmt.substring(start), fmt);
        }
    }

    public void writeln(String fmt, Object... args) {
        appendSpace(_indent);
        _content.append(String.format(fmt, args));
        _content.append('\n');
    }

    public void writeln() {
        _content.append('\n');
    }

    @Override
    public String toString() {
        return _content.toString();
    }
}

#!/bin/bash

./protoc --java_out=../test-java/src/ --plugin=protoc-gen-as3="protoc-as3" --as3_out=../test-as3/src/ ./protos/*.proto
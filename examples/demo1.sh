#!/bin/sh
# Program:
#        Demo 代码

cd `dirname $0`

source ../utility.sh

arg1=$(arg arg1 "default1" "变量1" "a1 a2")
arg2=$(arg arg2 "default2" "变量2" "a3 a4")
opt1=$(opt opt1 "选项1")

args_check

echo arg1 is $arg1

echo arg2 is $arg2

echo opt1 is $opt1

#shell 脚本工具包
## 使用方法
```
source utility.sh
```
## arg 函数

**参数说明**
```
arg 变量名 默认值 描述 可选项
```

**使用方法**
```
#test1.sh
k1=$(arg k1 "default" "变量k1" "v1 v2")
```

传入 k1 参数使用如下方法
> ./test1.sh --k1=v1

**说明**
如果设置了可选项参数，如果用户没有传入变量，程序会将可选项展示出来让用户进行选择

## opt 函数

**参数说明**
```
ops 变量名 描述
```

**使用方法**
```
#test2.sh
withtest=$(opt test "变量k2")

if [[ $withtest != 0 ]];then
# do something
fi
```

**传入参数**
> ./test2.sh --test

**说明**
如果传入参数，withtest 值为1，否则为0

## args_check 函数
此函数用来检测参数有没有正确传入

## help  函数
将定义的参数和描述提取出来，输出帮助信息

## success 函数 
输出成功信息

## error 函数
输出错误信息

## warn 函数
输出警告信息

## 说明
此工具支持 help 参数

## examples/demo1.sh 执行结果

```
./examples/demo1.sh 

请选择 [arg1]:  1:a1    2:a2  _1
请选择 [arg2]:  1:a3    2:a4  _1

arg1 is a1
arg2 is a3
opt1 is 0


./examples/demo1.sh help

--arg1
  变量1
  a1 a2
--arg2
  变量2
  a3 a4
opt1
  选项1
```

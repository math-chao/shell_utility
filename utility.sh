#!/bin/sh
# Function:
#       shell 脚本工具函数
# Created by zhangyachao in 2019-12-17
# 

global_params=$*

#需要用的外部文件
help=/tmp/sh-$$-help.txt
args=/tmp/sh-$$-args.txt
opts=/tmp/sh-$$-opts.txt
flag=/tmp/sh-$$-flag.txt

function clean()
{
    local files=(
        $help
        $args
        $opts
        $flag
    )
    local file
    for file in ${files[*]};do
        if [[ -f $file ]];then
            rm -rf $file
        fi
    done
}

clean

# 解析参数
# 参数格式为 --name=value
# 
for argument in $*; do
    if [[ $(expr substr ${argument} 1 2) == "--" && $(expr index ${argument} =) != "0" ]];then
        length=${#argument}
        argument=$(expr substr ${argument} 3 $length)
        name=$(echo $argument | cut -d= -f 1)
        v=$(echo $argument | cut -d= -f 2)
        declare $name=$v
    fi
done

# 定义脚本需要的参数，并输出用户输入的参数
# args 参数名 默认值 参数说明 参数值范围
# eg name=$(args name "" "参数 name" "name1 name2")
# 用户输入参数合适为 --name=value
# 对于拥有取值范围的参数，如果用户没有正确输入，会提示用户并让用户选择正确的参数
#
function arg()
{
    local name=$1
    local default=$2
    local desc=$3
    local options=$4

    if [[ $(eval echo '$'$name) == "" && ${default} != "" ]];then
        declare $name=$default
    fi

    echo $name:$options >> $args
    echo "--$name" >> ${help}
    echo "  $desc" >> ${help}
    if [[ $options != "" ]];then
        echo "  $options" >> ${help}
    fi


    declare -a arr
    local val=$(eval echo '$'$name)
    if [[ $(echo $global_params | grep help) == "" && $options != "" && ($val == "" || $( echo $options | grep $val ) == "") ]];then
        declare -i i=1
        msg="请选择 [$name]:"
        for vv in  $options;do
            msg="$msg  $i:$vv  "
            arr[$i]=$vv
            i=$i+1
        done
        read -p "${msg}_" num
        echo ${arr[$num]}
    else
        echo $val
    fi
}

# 定义脚本需要的选项
# 格式 opt name 选项说明
# eg withoption=$(opt with-option "选项with-option")
# 当用户输入参数含有 with-option 关键字, withoption 为 1；否则为 0
#
function opt()
{
    local name=$1
    local desc=$2

    echo "$name" >> ${help}
    echo "  $desc" >> ${help}
    echo $name >> $opts
    if [[ $(echo ${global_params} | grep $name) != "" ]];then
        echo 1
    else
        echo 0
    fi
}


# 参数检测
# 检测用户是否正确输入了定义的参数
#
function args_check()
{
    if [[ $(echo $global_params | grep help) != "" ]];then
        help
        exit
    fi

    if [[ -f $args ]];then
         cat $args | while read line
         do
             local name=${line%%:*}
             local options=${line#*:}
             local val=$(eval echo '$'${name})
             if [[ ${val} == "" || ($options != "" && $(echo $options | grep $val) == "") ]];then
                 error "args [$name] is not correct!"
                 echo 1 > ${flag}
             fi
         done

         if [[ -f $flag && $(cat ${flag}) == "1" ]];then
             echo ""
             usage || help
             clean
             exit
         fi
    fi

}

#帮助函数
#搜集定义参数和选项信息，并提示用户
#
function help()
{
    if [[ -f $help ]];then
        echo ""
        cat ${help}
        echo ""
    fi
    clean;
}

#输出成功信息信息
function success()
{
    echo -e "\033[32m $1 \033[0m"
}

#输出错误信息
function error()
{
    echo -e "\033[41;37m $1 \033[0m"
}

#输出警告信息
function warn()
{
    echo -e "\033[43;30m $1 \033[0m"
}

#输出普通信息
function info()
{
    echo -e "\033[37m $1 \033[0m"
}


#######################
# Name：GiaoShell
# 主要功能：
# 1、自动在前面加sudo
# 2、打开游戏界面（俄罗斯方块或者斗地主）     
# 3、展示段子
#######################

# 定义帮助文档
if [[ ${#} -ge 1&&${1} = "--help" ]]
then
    echo "Usage: giao [OPTION]"
    echo "Use it by which you can take the leisure and act as sudoer"
    echo ""
    echo "Mandatory arguments to long options are mandatory for short options too."
    echo "   none              add sudo forward"
    echo "  -game num          choose one game"
    echo "  -siri              display jokes"
fi


function getHistory(){
    homeDir=`echo $HOME`
    fileName=`echo $HISTFILE`
    whichShell=`echo $SHELL`
    tmp=$(echo $whichShell|grep "bash")  # 得到什么shell  bash就返回真\zsh返回假\别的shell暂不支持
    status=$?
    if [ $status -eq 0 ] 
    then
        # 直接采用bash_history
        echo ${homeDir}"/.bash_history"
        return 0
    fi
    tmp=$(echo $whichShell|grep "zsh") 
    status=$?
    if [ $status -eq 0 ] 
    then
        # 两个都需要测试下
        tmp=`ls ${homeDir}"/.zsh_history"`
        status=$?
        if [ $status -eq 0 ]
        then
            echo ${homeDir}"/.zsh_history"
            return 0
        fi
        tmp=`ls ${homeDir}"/.zhistory"`
        status=$? 
        if [ $status -eq 0 ]
        then
            echo ${homeDir}"/.zhistory"
            return 0
        fi
        return 1
    fi
    return 1
}

# 在某个命令行前面加sudo
function addSudo(){
    #首先得到filename  然后从文件中拿出最后一个就行了
    histFile=`getHistory`
    endLine=`tail -n 2 $histFile|head -n 1|awk -F ';' ' {print $NF}'`
    
    newCommand="sudo "${endLine}
    echo $newCommand
}

# 打开游戏
function addGame(){
    echo "测试"    
}

# 趣闻一句
function addJokes(){
    random=`echo $RANDOM`
    file=`cat config`
    cnt=0
    obj=0
    for i in $file
    do
        len=`echo $i|wc -L`
        if [ $len -eq 0 ]
        then
            continue
        fi 
        cnt=$[ $cnt+1 ]
    done
    for i in $file
    do
        len=`echo $i|wc -L`
        if [ $len -eq 0 ]
        then 
            continue
        fi
        if [ $obj -eq $[ $random%$cnt ] ]
        then
            echo $i
            return 0
        fi      
        obj=$[ $obj+1 ]
    done
    return 1
}

if [ $# -eq 0 ]
then 
    addSudo
fi
if [ $# -eq 1 ]
then
    if [[ ${1} == "s"||${1} == "-s" ]]
    then 
        addJokes
    elif [[ ${1} == "g"||${1} == "-g" ]]
    then
        # 这边还需要加一些东西
        addGame
    fi
fi

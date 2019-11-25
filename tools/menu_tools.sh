#!/bin/bash
# 工具箱入口
# @author: qufengfu@gmail.com

echo "1.安装阿里Arthas"
echo "0.返回上级菜单"
echo "q.退出"
echo ""

has_unzip(){
  if ! [ -x "$(command -v unzip)" ]; then
    echo 'false'
  else
    echo 'true'
  fi
}

read -p "请输入功能序号:" num

if [[ $num == 'q' ]]; then
  echo "Goodbye"
elif [ $num -eq '0' ];then
  cd ..
  source ./jtoolkit.sh
elif [ $num -eq '1' ];then
  if [ ! -d "arthas" ]; then

    has_it=`has_unzip`
    if [[ $has_it == 'false' ]]; then
      #根据进程关键字获取pid
      sudo yum install unzip -y
    fi
    has_it=`has_unzip`
    if [[ $has_it == 'false' ]]; then
      echo 'unzip未安装，无法解压安装文件，请先安装unzip'
    else
      echo "正在下载arthas......"
      sudo wget  http://3.106.11.105:8083/tool/download/arthas-3.1.4-bin.zip >> /dev/null 2>&1
      sudo mkdir arthas
      sudo unzip arthas-3.1.4-bin.zip -d arthas >> /dev/null 2>&1
      sudo rm -f arthas-3.1.4-bin.zip >> /dev/null 2>&1
      sudo wget  http://3.106.11.105:8083/tool/download/jvm/tools.jar
      sudo wget  http://3.106.11.105:8083/tool/download/jvm/jmap
      sudo wget  http://3.106.11.105:8083/tool/download/jvm/jstack
      JAVA=/usr/local/iGET/SRE/jre
      mv tools.jar ${JAVA}/lib
	  mv jmap ${JAVA}/bin
	  mv jstack ${JAVA}/bin
	  chmod 777 ${JAVA}/lib/tools.jar
	  chmod 777 ${JAVA}/bin/jmap
	  chmod 777 ${JAVA}/bin/jstack

      chmod 777 arthas -R
      read -p "请输入Java进程的所属用户:" user

      #获取用户所在组
      group=`id -gn $user`

      #修改属主
      sudo chown $user:$group -R arthas >> /dev/null 2>&1
    fi
  fi
  #cd arthas
  current_pid=`ps aux |grep "java"|grep "$process_keyword"|grep -v "grep"|awk '{ print $2}'`
  sudo -u $user -EH java -jar arthas/arthas-boot.jar ${current_pid}
  #source ./menu_load.sh
fi

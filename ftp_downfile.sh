#!/bin/bash
# --------------------------------------------------------------------#
# Copyright (C), 1998-2014, Tenda Tech. Co., Ltd.
# FileName: ftp_downfile.sh
# Author:   qudeyong
# Version:  V1.0
# Date:     2014-05-06
# Description:  主要用于使用ftp下载文件 
#
# History:
#   <author>  <time>   <version >   <desc>
# --------------------------------------------------------------------#
help()
{
  Usage="Usage: 主要是用于从服务器上使用FTP下载文件 \n\
Options:\n\
	[--ip ipaddr] \t\t\t-- 需要连接的服务器IP地址\n \
	[--port num] \t\t\t-- 设置服务器监听端口值，默认21\n \
	[--user username] \t\t-- 登陆FTP服务器的用户名,默认ftp \n \
	[--passwd password] \t\t-- 登陆FTP服务器的密码,默认ftp \n \
	[--mode passive] \t\t-- 默认为被动模式,0表示被动模式,若1则为主动模式 \n \
	[--file filename] \t\t-- 需要下载的文件名\n \
	[--outdir dirpath] \t\t-- 下载的文件存放目录,默认/tmp/ftp \n \
	[--sip source ip address] \t\t-- 默认使用的源ip地址 \n \
	[--help | -h] \t\t\t-- 显示帮助信息 \n \
	"
    echo -e $Usage
}

PORT=21
USER=ftp
PASSWD=ftp
MODE=0
FTP=/var/tendatest/TDT/bin/wget
OUTDIR=/tmp/ftp
SIP=0

argv=`getopt -a -o o:,h -l ip:,port:,sip:,user:,passwd:,mode:,outdir:,file:,help -- $@`
if [ "$?" != "0" ]
then
    help
    exit 127 
fi
eval set -- $argv
while true
	do
    case "$1" in
        --port)
            PORT=$2
            shift 2
            ;;
	    --file)
            FILENAME=$2
            shift 2
            ;;  
        --mode)
            MODE=$2
            shift 2
            ;;  
        --passwd)
            PASSWD=$2
            shift 2
            ;;  
        --user)
            USER=$2
            shift 2
            ;;  
        --outdir)
            OUTDIR=$2
            shift 2
            ;;  
        --ip)
            IP=$2
            shift 2
            ;;  
        --sip)
            SIP=$2
            shift 2
            ;;  
        -h | --help)
            help
            exit 0
            shift
            ;;  
        --) 
			break
            ;;  
    esac
done
mkdir -p $OUTDIR
rm -rf $OUTDIR/${FILENAME}
if [ $SIP -eq 0 ]
then
	SIP=""
else
	SIP="--bind-address=${SIP}"
fi

if [ $MODE -eq 1 ]
then
	$FTP  --no-passive-ftp --ftp-user=$USER --ftp-password=$PASSWD ftp://$IP:${PORT}/${FILENAME} $SIP -q -b -P $OUTDIR &  >/dev/null
else 
	$FTP --ftp-user=$USER --ftp-password=$PASSWD ftp://$IP:${PORT}/${FILENAME} $SIP -q -b -P $OUTDIR  & >/dev/null
fi

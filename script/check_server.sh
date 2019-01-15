#!/bin/bash
#服务器硬件环境监测
recho(){
echo -e  "\033[31m${*}\033[0m"
}
gecho(){
echo -e  "\033[32m${*}\033[0m"
}
geshi(){
echo ""
}
geshi
geshi
geshi
geshi
geshi
echo -e "------------当前服务器硬件信息---------------------"
geshi
geshi
geshi
lscpu | awk '/^CPU\(s/{print "CPU逻辑处理器数是:",$2}'
geshi
cpumode=`lscpu | awk -F : '/^Model name/{print "CPU型号是:",$2}'`
geshi
echo 系统版本为：`cat /etc/redhat-release`
geshi
socket=`lscpu | awk -F : '/Socket\(s\):/{print $2}' | sed -n 's/ *//p'`
echo "${socket}个$cpumode "
geshi
sdasize=`lsblk | awk '/sda |vda /{print $4}'`
lsscsi | grep SSD > /dev/null
if [ $? -eq 0 ] ; then
    gecho  硬盘类型为SSD
    geshi
else
   recho   硬盘类型不是SSD
   geshi
fi
echo "总磁盘容量$sdasize"
geshi
for i in `cat /etc/fstab | awk '/^[^#]/{print $2}'`
do 
   let mountpoint_num++ 
done
if [ $mountpoint_num -gt 3 ];then
 recho  分区个数为 $mountpoint_num 分别是
geshi
    for i in `cat /etc/fstab | awk '/^[^#]/{print $2}'`
   do
      recho $i 
   done
   echo
else 
 gecho  分区个数为 $mountpoint_num 分别是
geshi
    for i in `cat /etc/fstab | awk '/^[^#]/{print $2}'`
   do
      gecho $i 
   done
   echo
fi
echo 其中分区类型是LVM的有:`lsblk | awk '/lvm/{print $NF}'`
echo 根分区大小为  : `df -h | awk '/\/$/{print $2}'`
geshi
echo BOOT分区大小为: `df -h | awk '/boot/{print $2}'`
echo swap分区大小为: `lsblk | awk '/SWAP/{print $4}'`
echo 内存容量为:`free -h  | awk '/Mem:/{print $2}'`
geshi
echo 网卡名称和IP分别为：
rpm -q net-tools &>/dev/null || yum -y install net-tools $>/dev/null
ifcg=`ip a s | awk '/^[0-9]/{print $2}'`
for i in $ifcg
do
ifnew=${i%%:}
echo $i `ifconfig $ifnew | grep 'inet '`
done
geshi
echo 系统时区为`timedatectl | grep 'Time zone'`
geshi
echo "当前系统时间为:`date`" 
geshi
geshi
geshi
geshi

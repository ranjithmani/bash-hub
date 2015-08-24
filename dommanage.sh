#!/bin/bash

#Script to manage KVM guest under Redhat cluster 
#Call this script from  Redhat cluster resource manager 

#To start a VM
start() {
LOG=/var/log/cluster/vmlog
date >> $LOG
echo -n $"Starting VMs: "
(virsh start <vm-name-from virsh list>) &>> $LOG
RETVAL=$?
}

#To stop a VM
stop() {
LOG=/var/log/cluster/vmlog
(virsh list |grep <vm-name-from virsh list> )
if [ $? == 0 ]
then
date >> $LOG
echo -n $"Stopping Vms: " >> $LOG
(virsh shutdown <vm-name-from virsh list>) &>> $LOG
(virsh destroy <vm-name-from virsh list>) &>> $LOG
RETVAL=$?
exit 0
else
echo "<vm-name-from virsh list> is already down" >> $LOG
exit 0
fi
}

#To check the status of a VM
status() {
LOG=/var/log/cluster/vmlog
date >> $LOG
echo -n $"Checking Status of VMs: "
(virsh list |grep <vm-name-from virsh list>)  &>> $LOG
RETVAL=$?
}

#See How we called them 

case "$1" in
START|start)
start
;;
STOP|stop)
stop
;;
RESTART|restart)
stop
start
;;
MONITOR|monitor|STATUS|status)
status
;;
*)
echo $"Usage: $prog {start|stop|monitor|status}"
RETVAL=2
esac

exit $RETVAL

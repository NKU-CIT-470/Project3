#!/bin/bash
#Project 3 CIT470
#Monit Server testing

echo "Install required packages for testing" && yum -y install stress && echo "Packages installed."

#Kill SSH Test
kill_ssh_test () { echo "Testing SSH..." && systemctl stop sshd && sleep 120 && monit summary | grep ssh }

#Kill NFS-Server Test
kill_nfs_test () { echo "Testing NFS server..." && systemctl stop nfs && sleep 120 && monit summary | grep nfs && echo "NFS-Server testing complete!" }

#Kill LDAP-Server Test
kill_ldap_test () { echo "Testing LDAP server..." && systemctl stop slapd && sleep 120 && monit summary | grep slapd && echo "LDAP-Server testing complete!" }

#Kill syslog test
kill_syslog_test () { echo "Testing syslog..." && systemctl stop rsyslog && sleep 120 && monit summary | grep rsyslog }

#Test to overload CPU with stress tool
overload_cpu_test () { echo "Testing CPU usage..." && stress --vm-bytes 256MB --cpu 100 --timeout 60s >& 1 >> /var/log/server-testing.log && monit summary | grep localhost && echo "CPU and MEM testing complete!" }

#Test to overload Mem with stress tool
overload_mem_test () { echo "Testing memory usage..." && stress --vm 1 --vm-bytes  3500M --timeout 45s >& 1 >> /var/log/server-testing.log && monit summary | grep localhost && echo "Mem testing complete!" }

#Test hard drive
hard_drive_test () { echo "Testing disk usage.." && dd if=/dev/zero of=/dev/diskhog bs=1M count=100000 >&1 >> /var/log/server-testing.log && sleep 60 && monit summary | grep Home && monit summary | grep Root && monit summary | grep Var && rm /dev/diskhog -f >& 1 >> /var/log/server-testing.log && echo "Disk usage testing complete!" }

# Run tests
kill_ssh_test && kill_nfs_test && kill_ldap_test && kill_syslog_test && overload_cpu_test && overload_mem_test && hard_drive_test

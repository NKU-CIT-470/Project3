#!/bin/bash
#Project 3 CIT470
#Monit Client testing

echo "Install required packages for testing..." && yum -y install stress && echo "Packages installed."

#Kill SSH Test
kill_ssh_test () { echo "Testing SSH..." && systemctl stop sshd && sleep 120 && monit summary | grep ssh }

#Kill NFS-Client Test
kill_nfs_test () { echo "Testing NFS client..." && systemctl stop nfs && sleep 120 && monit summary | grep nfs && echo "NFS-Client testing complete!" }

#Kill LDAP-Client Test
kill_ldap_test () { echo "Testing LDAP client..." && systemctl stop nslcd && sleep 120 && monit summary | grep nslcd && echo "LDAP-Client testing complete!" }

#Kill syslog Test
kill_syslog_test () { echo "Testing syslog..." && systemctl stop rsyslog && sleep 120 && monit summary | grep rsyslog }

#Test to overload CPU with stress tool
overload_cpu_test () { echo "Testing CPU usage..." && stress --vm-bytes 256M --cpu 100 --timeout 60s >& 1 >> /var/log/client-testing.log && monit summary | grep localhost && echo "CPU testing complete!" }

#Test to overload Mem with stress tool
overload_mem_test () { echo "Testing memory usage..." && stress --vm 1 --vm-bytes  3500M --timeout 45s >& 1 >> /var/log/client-testing.log && monit summary | grep localhost && echo "Mem testing complete!" }

#Test dir and fs
dir_fs_test () { echo "Testing disk usage.." && dd if=/dev/zero of=/dev/diskhog bs=1M count=100000 2>&1 >> /var/log/client-testing.log && sleep 60 && monit summary | grep Home && monit summary | grep Root && monit summary | grep Var && rm /dev/diskhog -f >& 1 >> /var/log/client-testing.log && echo "Disk usage testing complete!" }

# Run tests
kill_ssh_test && kill_nfs_test && kill_ldap_test && kill_syslog_test && overload_cpu_test && overload_mem_test && dir_fs_test

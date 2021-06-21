#!/bin/bash
#Project 3 CIT470
#Monit Server testing

echo "Install required packages for testing" && yum -y install stress && echo "Packages installed."

#Kill SSH Test
kill_ssh_test () { echo "Testing SSH..." && systemctl stop sshd && sleep 120 && monit summary | grep ssh && echo "SSH Testing complete!"
}

#Kill NFS-Server Test
kill_nfs_test () { echo "Testing NFS server..." && systemctl stop nfs nfslock && sleep 120 && monit summary | grep NFS && echo "NFS-Server testing complete!"
}

#Kill LDAP-Server Test
kill_ldap_test () { echo "Testing LDAP server..." && systemctl stop slapd && sleep 120 && monit summary | grep LDAP && echo "LDAP-Server testing complete!"
}

#Kill syslog test
kill_syslog_test () { echo "Testing syslog..." && systemctl stop rsyslog && sleep 120 && monit summary | grep syslog && echo "syslog testing complete!"
}

#Test to overload CPU with stress tool
overload_cpu_test () { echo "Testing CPU usage..." && stress --vm-bytes 256M --cpu 100 --timeout 60s >& 1 >> /var/log/server-testing.log && monit summary | grep localhost && echo "CPU testing complete!"
}

#Test to overload Mem with stress tool
overload_mem_test () { echo "Testing memory usage..." && stress --vm 1 --vm-bytes  3500M --timeout 45s >& 1 >> /var/log/server-testing.log && monit summary | grep localhost && echo "Mem testing complete!"
}

#Test directory and filesystem
dir_fs_test () { echo "Testing disk usage.." && dd if=/dev/zero of=/dev/diskhog bs=1M count=1850 >&1 >> /var/log/server-testing.log && sleep 60 && rm /dev/diskhog -f >& 1 >> /var/log/server-testing.log
echo "Cleaning up disk testing" && sleep 60 && monit summary | grep home && monit summary | grep root && monit summary | grep dev && rm /dev/diskhog -f >& 1 >> /var/log/server-testing.log && echo "Disk usage testing complete!"
}
# test to see if overwrite works# Run tests
kill_ssh_test && kill_nfs_test && kill_ldap_test && kill_syslog_test && overload_mem_test && overload_cpu_test && dir_fs_test

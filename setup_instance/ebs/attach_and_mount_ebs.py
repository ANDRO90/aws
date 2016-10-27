#setup boto system-wide  --> /etc/boto.cfg
#[Credentials]
#aws_access_key_id = <your_access_key_here>
#aws_secret_access_key = <your_secret_key_here>

import subprocess
import sys
import boto
import boto.ec2
import time

args = sys.argv

#the first argument is always the script name
instance_id = args[1]
partition = args[2]
mount_point = args[3]
size = int(args[4])

region = "us-west-2"

conn = boto.ec2.connect_to_region(region)

reservations = conn.get_all_instances(instance_ids=[instance_id])
ins = reservations[0].instances[0]

vol = conn.create_volume(size, ins.placement, volume_type="gp2")

time.sleep(60)

vol.attach(ins.id, partition)

time.sleep(60)
#then mount it in bash
#sudo mkfs -t ext4 /dev/xvdb
#sudo mkdir /ebs
#sudo mount -t ext4 /dev/xvdb /ebs

c1 = "sudo mkfs -t -ext4 " + partition
c2 = "sudo mkdir " + mount_point
c3 = "sudo mount -t ext4 " + partition + " " + mount_point

p1 = subprocess.Popen(c1.split(), stdout=subprocess.PIPE)
#o1, e1 = p2.communicate()
time.sleep(10)
p2 = subprocess.Popen(c2.split(), stdout=subprocess.PIPE)
#o2, e2 = p2.communicate()
time.sleep(10)
p3 = subprocess.Popen(c3.split(), stdout=subprocess.PIPE)
#o3, e3 = p3.communicate()

#example: python attach_and_mount_ebs.py "i-0458fc8cea941b294" "/dev/xvdc" "/ebs1" 80


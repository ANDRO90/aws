import subprocess
import sys
import boto
import boto.ec2
import time

args = sys.argv

#the first argument is always the script name
availability_zone = args[1]
instance_id = args[2]
volume_id = args[3]
partition = args[4]
mount_point = args[5]

region = "us-west-2"

conn = boto.ec2.connect_to_region(region)

reservations = conn.get_all_instances(instance_ids=[instance_id])
ins = reservations[0].instances[0]

volumes = conn.get_all_volumes(volume_ids=[volume_id])
vol = volumes[0]

vol.attach(ins.id, partition)

#then mount it in bash
#sudo mkdir /ebs
#sudo mount -t ext4 /dev/xvdb /ebs

time.sleep(60)

c2 = "sudo mkdir " + mount_point
c3 = "sudo mount -t ext4 " + partition + " " + mount_point
p2 = subprocess.Popen(c2.split(), stdout=subprocess.PIPE)
#o2, e2 = p2.communicate()
time.sleep(10)
p3 = subprocess.Popen(c3.split(), stdout=subprocess.PIPE)
#o3, e3 = p3.communicate()
time.sleep(10)


#if we are attaching a volume created from a snapshot for expanding the volume, we also need to run the following command
c4 = "sudo resize2fs " + partition
p4 = subprocess.Popen(c4.split(), stdout=subprocess.PIPE)
#o4, e4 = p4.communicate()

#example: python attach_and_mount_existent_volume.py "us-west-2b" "i-0458fc8cea941b294" "vol-099af0d92cc378f33" "/dev/xvdb" "/ebs"
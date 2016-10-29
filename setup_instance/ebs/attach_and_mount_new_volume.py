import subprocess
import sys
import boto
import boto.ec2
import time

def attach_and_mount_new_volume(region, instance_id, volume_type, size, partition='', mount_point='')
    conn = boto.ec2.connect_to_region(region)

    reservations = conn.get_all_instances(instance_ids=[instance_id])
    ins = reservations[0].instances[0]

    vol = conn.create_volume(size, ins.placement, volume_type=volume_type)

    time.sleep(60)
    print('volume created!')

    vol.attach(ins.id, partition)

    time.sleep(60)
    print('volume attached!')

    if partition != '':
        mount_new_file_system(partition, mount_point)
    
def mount_new_file_system(partition, mount_point)
    # sudo mkfs -t ext4 <partition>
    # sudo mkdir <mount_point>
    # sudo mount -t ext4 <partition> <mount_point>

    c1 = "sudo mkfs -t -ext4 " + partition
    p1 = subprocess.Popen(c1.split(), stdout=subprocess.PIPE)
    #o1, e1 = p2.communicate()

    time.sleep(10)
    print('file system created!')

    c2 = "sudo mkdir " + mount_point
    p2 = subprocess.Popen(c2.split(), stdout=subprocess.PIPE)
    #o2, e2 = p2.communicate()

    time.sleep(10)

    c3 = "sudo mount -t ext4 " + partition + " " + mount_point
    p3 = subprocess.Popen(c3.split(), stdout=subprocess.PIPE)
    #o3, e3 = p3.communicate()
    
    time.sleep(10)
    print('volume mounted!')


if __name__ == '__main__':
	args = sys.argv
    # the first argument is always the script name
    region = args[1]
    instance_id = args[2]
    volume_type = args[3]
    size = int(args[4])
    partition = args[5]
    mount_point = args[6]
    
    attach_and_mount_new_volume(region, instance_id, volume_type, size, partition, mount_point)


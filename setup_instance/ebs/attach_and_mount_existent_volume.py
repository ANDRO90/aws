import subprocess
import sys
import boto
import boto.ec2
import time

def attach_and_mount_existent_volume(region, availability_zone, instance_id, volume_id, partition='', mount_point='', extension=False)
    conn = boto.ec2.connect_to_region(region)

    reservations = conn.get_all_instances(instance_ids=[instance_id])
    ins = reservations[0].instances[0]

    volumes = conn.get_all_volumes(volume_ids=[volume_id])
    vol = volumes[0]

    vol.attach(ins.id, partition)

    # wait for the request to be processed
    time.sleep(60)
    print('volume attached!')

    if partition != '':
        mount_existent_file_system(partition, mount_point, extension)


def mount_existent_file_system(partition, mount_point, extension):
    # sudo mkdir <mount_point>
    # sudo mount -t ext4 <partition> <mount_point>

    c2 = "sudo mkdir " + mount_point
    p2 = subprocess.Popen(c2.split(), stdout=subprocess.PIPE)
    #o2, e2 = p2.communicate()
    
    time.sleep(10)

    c3 = "sudo mount -t ext4 " + partition + " " + mount_point
    p3 = subprocess.Popen(c3.split(), stdout=subprocess.PIPE)
    #o3, e3 = p3.communicate()
    
    time.sleep(10)
    print('volume mounted!')

    if extension:
        # we are attaching a volume created from a snapshot for expanding the space, therefore we also need to run the following command
        c4 = "sudo resize2fs " + partition
        p4 = subprocess.Popen(c4.split(), stdout=subprocess.PIPE)
        #o4, e4 = p4.communicate()
        
        time.sleep(10)
        print('file system expanded!')


if __name__ == '__main__':
	args = sys.argv
	# the first argument is always the script name
	region = args[1]
	availability_zone = args[2]
	instance_id = args[3]
	volume_id = args[4]
	partition = args[5]
	mount_point = args[6]
	extension = args[7]
	attach_and_mount_existent_volume(region, availability_zone, instance_id, volume_id, partition, mount_point, extension)


import boto
import boto.ec2
import sys
import time

def detach_volume(volume_id, region):
	conn = boto.ec2.connect_to_region(region)

	conn.detach_volume(volume_id)

    # wait for the request to be processed
    time.sleep(60)
	print('volume detached!')


if __name__ == '__main__':
	args = sys.argv
	# the first argument is always the script name
	volume_id = argv[1]
	region = argv[2]
	detach_volume(volume_id, region)

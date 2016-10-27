import boto
import boto.ec2

region = "us-west-2"
volume_id = "vol-002b7178d9cca3c3c"

conn = boto.ec2.connect_to_region(region)

conn.detach_volume(volume_id)
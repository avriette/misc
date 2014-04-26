#!/bin/sh

export AWS_DEFAULT_REGION=us-east-1
export AWS_AVAILABILITY_ZONE=us-east-1d
DEBUG=1

# Debugging utility
log () {
	[[ $DEBUG ]] && print_stderr $*
}
print_stderr () {
	echo $0[$$]: $* > /dev/stderr
}

# set -x

## Task 1
# determine latest ubuntu lts ami id

#  So, as it happens, the schema returned by aws ec2 describe-images doesn't
#  actually include the date the ami was created, any specific keys re the OS
#  version, and the naming ontology is really poor (it's all freeform rather
#  than organised in any way). Therefore it would seem to not be
#  programmatically possible to 'ascertain' the latest-n-greatest e.g., ubuntu
#  LTS image. So we hard-code this here.
UBUNTU_LTS_AMI_ID="ami-358c955c" # note this is 32-bit

## Task 3
# launch an m1.small instance

log "creating keypair"
aws ec2 import-key-pair \
	--key-name jane_key \
	--public-key-material "$(cat ~/.ssh/id_rsa.pub)"

log "creating security group"
aws ec2 create-security-group \
	--group-name optoro_ssh_22_inbound \
	--description "port 22 inbound is open"

log "creating security group port 22 inbound rule"
aws ec2 authorize-security-group-ingress \
	--group-name optoro_ssh_22_inbound \
	--protocol tcp \
	--port 22 \
	--cidr 173.8.15.238/32  # that's home

log "spinning up new instance"
aws ec2 run-instances \
	--image-id ami-358c955c \
	--key-name jane_key \
	--instance-type m1.small \
	--security-groups optoro_ssh_22_inbound | grep InstanceId | cut -d' ' -f 2 | cut -d, -f 1 | while read instance_id ; do
		log "pulling public dns info from instance id ${instance_id}"
		aws ec2 describe-instances --instance-ids $instance_id | grep PublicDnsName | cut -d' ' -f 2 | cut -d, -f 1 | while read public_hostname ; do
			log "shelling into ${public_hostname} to frob"
			ssh -i $SSH_KEY ubuntu@${public_hostname} 'curl https://s3.amazonaws.com/optoro-corp/opsrsrc/optoro | sudo dd of=/usr/local/bin/optoro'
			ssh -i $SSH_KEY ubuntu@${public_hostname} 'sudo chmod 755 /usr/local/bin/optoro'
			# we assume this is safe to run as root. seems kinda necessary, right?
			ssh -i $SSH_KEY ubuntu@${public_hostname} 'sudo /usr/local/bin/optoro'
		done # public_hostname
	done # instance_id


### END
##
#
# log https://www.youtube.com/watch?v=gBzJGckMYO4
exit 0;

# This is basically just a multiline comment.
NOTES=<<NOTES

# For some reason awscli will not allow me to use us-east-1d, but us-east
# works. I assume that this throws it into one of us-east-1{a,b,c,d}, but
# that's mildly annoying if it doesn't allow me to specify a specific
# sub-region for the node.
haram:joshsz jane$ aws ec2 describe-images
Service ec2 not available in region us-east-1d
haram:joshsz jane$ AWS_DEFAULT_REGION=us-east-1 aws ec2 describe-regions
{
    "Regions": [
        {
            "Endpoint": "ec2.eu-west-1.amazonaws.com", 
            "RegionName": "eu-west-1"
        }, 
        {
            "Endpoint": "ec2.sa-east-1.amazonaws.com", 
            "RegionName": "sa-east-1"
        }, 
        {
            "Endpoint": "ec2.us-east-1.amazonaws.com", 
            "RegionName": "us-east-1"
        }, 
        {
            "Endpoint": "ec2.ap-northeast-1.amazonaws.com", 
            "RegionName": "ap-northeast-1"
        }, 
        {
            "Endpoint": "ec2.us-west-2.amazonaws.com", 
            "RegionName": "us-west-2"
        }, 
        {
            "Endpoint": "ec2.us-west-1.amazonaws.com", 
            "RegionName": "us-west-1"
        }, 
        {
            "Endpoint": "ec2.ap-southeast-1.amazonaws.com", 
            "RegionName": "ap-southeast-1"
        }, 
        {
            "Endpoint": "ec2.ap-southeast-2.amazonaws.com", 
            "RegionName": "ap-southeast-2"
        }
    ]
}

# It takes about one minute, fifteen seconds to pull down the list of images
# from ec2.
EXPECTED_FINISH=$(date -r `perl -le 'print time() + 75'`)
log "Grabbing list of AMIs, expecting to finish at ${EXPECTED_FINISH}"
aws ec2 describe-images | # your json parsing goes here.
haram:joshsz jane$ aws ec2 import-key-pair --key-name josh_key --public-key-material "$(cat ./id_rsa.pub)"
{
    "KeyName": "josh_key", 
    "KeyFingerprint": "7e:8d:e4:55:89:90:7b:a1:f6:2d:5b:0b:6c:21:54:65"
}
haram:joshsz jane$ aws ec2 create-security-group --group-name optoro_ssh_22_inbound --description "port 22 inbound is open"
{
    "return": "true", 
    "GroupId": "sg-7e5a9814"
}
haram:joshsz jane$ aws ec2 authorize-security-group-ingress --group-name optoro_ssh_22_inbound --protocol tcp --port 22
{
    "return": "true"
}
haram:joshsz jane$ aws ec2 run-instances --image-id ami-358c955c --key-name josh_key --instance-type m1.small --security-groups optoro_ssh_22_inbound
{
    "OwnerId": "937944802865", 
    "ReservationId": "r-d6e7e2aa", 
    "Groups": [
        {
            "GroupName": "optoro_ssh_22_inbound", 
            "GroupId": "sg-7e5a9814"
        }
    ], 
    "Instances": [
        {
            "Monitoring": {
                "State": "disabled"
            }, 
            "PublicDnsName": null, 
            "KernelId": "aki-8f9dcae6", 
            "State": {
                "Code": 0, 
                "Name": "pending"
            }, 
            "EbsOptimized": false, 
            "LaunchTime": "2014-04-26T16:45:35.000Z", 
            "ProductCodes": [], 
            "StateTransitionReason": null, 
            "InstanceId": "i-6ff93d3f", 
            "ImageId": "ami-358c955c", 
            "PrivateDnsName": null, 
            "KeyName": "josh_key", 
            "SecurityGroups": [
                {
                    "GroupName": "optoro_ssh_22_inbound", 
                    "GroupId": "sg-7e5a9814"
                }
            ], 
            "ClientToken": null, 
            "InstanceType": "m1.small", 
            "NetworkInterfaces": [], 
            "Placement": {
                "Tenancy": "default", 
                "GroupName": null, 
                "AvailabilityZone": "us-east-1a"
            }, 
            "Hypervisor": "xen", 
            "BlockDeviceMappings": [], 
            "Architecture": "i386", 
            "StateReason": {
                "Message": "pending", 
                "Code": "pending"
            }, 
            "RootDeviceName": "/dev/sda1", 
            "VirtualizationType": "paravirtual", 
            "RootDeviceType": "ebs", 
            "AmiLaunchIndex": 0
        }
    ]
}
haram:joshsz jane$ aws ec2 describe-instances --instance-ids i-6ff93d3f
{
    "Reservations": [
        {
            "OwnerId": "937944802865", 
            "ReservationId": "r-d6e7e2aa", 
            "Groups": [
                {
                    "GroupName": "optoro_ssh_22_inbound", 
                    "GroupId": "sg-7e5a9814"
                }
            ], 
            "Instances": [
                {
                    "Monitoring": {
                        "State": "disabled"
                    }, 
                    "PublicDnsName": "ec2-50-16-28-70.compute-1.amazonaws.com", 
                    "RootDeviceType": "ebs", 
                    "State": {
                        "Code": 16, 
                        "Name": "running"
                    }, 
                    "EbsOptimized": false, 
                    "LaunchTime": "2014-04-26T16:45:35.000Z", 
                    "PublicIpAddress": "50.16.28.70", 
                    "PrivateIpAddress": "10.193.34.111", 
                    "ProductCodes": [], 
                    "StateTransitionReason": null, 
                    "InstanceId": "i-6ff93d3f", 
                    "ImageId": "ami-358c955c", 
                    "PrivateDnsName": "domU-12-31-39-0F-21-81.compute-1.internal", 
                    "KeyName": "josh_key", 
                    "SecurityGroups": [
                        {
                            "GroupName": "optoro_ssh_22_inbound", 
                            "GroupId": "sg-7e5a9814"
                        }
                    ], 
                    "ClientToken": null, 
                    "InstanceType": "m1.small", 
                    "NetworkInterfaces": [], 
                    "Placement": {
                        "Tenancy": "default", 
                        "GroupName": null, 
                        "AvailabilityZone": "us-east-1a"
                    }, 
                    "Hypervisor": "xen", 
                    "BlockDeviceMappings": [
                        {
                            "DeviceName": "/dev/sda1", 
                            "Ebs": {
                                "Status": "attached", 
                                "DeleteOnTermination": true, 
                                "VolumeId": "vol-3716f67e", 
                                "AttachTime": "2014-04-26T16:45:39.000Z"
                            }
                        }
                    ], 
                    "Architecture": "i386", 
                    "KernelId": "aki-8f9dcae6", 
                    "RootDeviceName": "/dev/sda1", 
                    "VirtualizationType": "paravirtual", 
                    "AmiLaunchIndex": 0
                }
            ]
        }
    ]
}
NOTES
# back to executing, but this is the end.
# jane@cpan.org // vim:tw=78:ts=2:noet

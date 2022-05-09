# Set up Traffic Security using Security Groups and Network Access Control Lists
---
## Part 1: Create your VPC and Set up two Instances
---
>***Open the AWS console at [aws.amazon.con](https://skillstorm.awsapps.com/start)***
>
>***Step 1:*** Create a VPC in the North Virginia Region ([VPC Lab](https://github.com/bdgomey/AWS_Labs/blob/master/Networking/create_VPC.md)) 
>
>***Step 2:*** Create an EC2 instance in your newly built VPC
>
>**Remember**: You will have to select your own VPC in the **"Configure Instance Details"** Step.  
>
>**1**: Network - Select your network you created
>
>**2**: Subnet - Select your public Subnet
>
>**3**: Auto-assign Public IP - Ensure you see "Enable"  if you do not, select the dropdown box and enable the Public IP
>![configure](images/ec2_config.gif)
>
>***Step 3:*** Create an EC2 instance in Us-East-2 in the default VPC.  Follow the [EC2 lab](https://github.com/bdgomey/AWS_Labs/blob/master/Compute/SSH_to_instance.md) if you need help.
>
>***Step 4:*** go to your instance and select the security group attached to it. 
>![Select NSG](images/select_NSG.png)
>
>***Step 5:*** Make sure that you have both SSH and ICMP traffic allowed in your security group like below:
>![NSG](images/NSG.png)
>SSH into both instances once complete
>
>Ping both instances to see if they can communicate with one another
>
>>**Command**=  ping **PublicIP**
>
>**Common errors:** Wrong VPC in N. Virginia, Wrong subnet (must select public subnet), did not auto assign public IP address in your instance details step.   
---
## Part 2: Set up Network Access Control Lists
>***Step 1:*** Set up the listener on your US-East-2 instance.  Run the following command in the terminal hosting the instance in Ohio and leave it running: 
>
>>sudo tcpdump -i eth0 icmp and icmp[icmptype]=icmp-echo
>>
>>Ping your Ohio instance to see if the listener works
>![ping](images/ping.gif)
>
>***Step 2:*** Next: Go to the VPC Dashboard
>
>***Step 3:*** Select your Access Control List
>![ACL](images/ACL.png)
>
>![ACL-Select](images/acl-select.png)
>
>***Step 4:*** Select **Edit Inbound Rules**
>
>***Step 5*** Change rule number 100 to 105 
>>add an additional rule:  Give that one rule number 100 
>>
>>Type: **ICMP** 
>>
>>Source: **0.0.0.0/0**
>>
>>and finally make sure you select **Deny** in the last block. 
>![inbound](images/inbound.png)
>>Save Changes
>
>***Step 6:*** Try to ping your ohio instance. You should see the listener receive the ping, but you will not get a return ping on your primary instance.  
>
>![Ping_NACL](images/ping_nacl.gif)
>
># Ensure to clean up your environment
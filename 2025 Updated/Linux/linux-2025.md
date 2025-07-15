LINUX QA - HPL

1. What is a Cron Job?
A cron job is an automated scheduled task that runs commands or scripts at specified intervals on Unix/Linux systems. The cron service checks schedules and runs jobs in the background.

sudo chmod ugo=x create_dir_every2min.sh
sudo chmod u=rwx,g=rx,o=rx create_dir_every2min.sh


* * * * * /path/to/command arg1 arg2
| | | | |
| | | | +----- Day of the week (0 - 7) (Sunday is 0 or 7)
| | | +------- Month (1 - 12)
| | +--------- Day of the month (1 - 31)
| +----------- Hour (0 - 23)
+------------- Minute (0 - 59)


1. Minute (0-59)
The exact minute within the hour.
Example:
0 = at the start of the hour
30 = at 30 minutes past the hour
* = every minute

2. Hour (0-23)
The hour in 24-hour format.
Example:
0 = midnight
14 = 2 PM
* = every hour

3. Day of Month (1-31)
The day of the month.
Example:
1 = 1st of the month
15 = 15th
* = every day

4. Month (1-12)
The month of the year.
Example:
1 = January
12 = December
* = every month

5. Day of Week (0-7)
The day of the week.
0 or 7 = Sunday
1 = Monday
6 = Saturday
* = every day

-------------------------------------------------------------------------------------------------------------

2. If file not writable how to troubleshoot the issue?

1. File Permissions
ls -l filename
-rw-r--r-- 1 ubuntu ubuntu 0 May 27 16:05 myfile.txt
If you do not see w in your user’s section, you cannot write.

2. File Ownership
-rw-r--r-- 1 ubuntu ubuntu 0 May 27 16:05 myfile.txt
            ^      ^
          owner   group
If the owner is not you, you might not have write access.
If you are not the owner or part of the group, you may need to use sudo or ask the owner to give you permissions.

3. Change Permissions (if needed)
If you are the owner and want to allow yourself to write, run:
chmod u+w filename
chmod changes permissions.
u+w means “add write permission for the user (owner)”.

4. Check if the Filesystem is Read-Only
Sometimes, you can’t write because the whole disk or mount is read-only.
Check with:
mount | grep ro,
If you see your disk or partition is mounted as ro (read-only), you need to remount as rw (read-write), or fix disk issues.

5. Check Disk Space
If the disk is full, you can’t write anything—even if you have permission.
Check free space:
df -h

6. Directory Write Access
You need write permission to the directory to create or delete files in it.
Check with:
ls -ld directoryname

------------------------------------------------------------------------------------------------------------

3. Top commands / when it will be used?
top shows running processes, CPU, memory usage in real-time.
Useful for monitoring system performance and finding resource hogs.
Start by typing: top
Alternative: htop (if installed, prettier UI).

CPU usage (how busy your processor is)
Memory usage (how much RAM is free or used)
List of running processes (what’s running, who owns it, how much resource each uses)
System uptime (how long since the system started)
Load averages (overall CPU demand over time)
Swap usage (if you’re using virtual memory)

Why is it useful?
To monitor system performance in real time.
To find and kill processes that are using too many resources.
To troubleshoot if your system is slow or not responding.

One line - The top command displays a real-time, updating summary of all running processes, showing resource usage and helping you monitor and manage system performance.

The top command displays real-time CPU and memory usage for each process, listing all running processes on the system. It allows users to monitor system performance and also provides options to manage or terminate processes as needed.

1. Kill a Process from the top Command
1. enter top
2. Find the PID (Process ID) of the process you want to kill.
It’s shown in the leftmost column.
3. Press k on your keyboard.
4. Enter the PID of the process you want to kill and press Enter.
5. When asked for the signal, just press Enter to use the default signal (15 for "terminate").

2. Kill a Process Using the kill Command
Kill the process:
kill <PID>
kill 1234

If it doesn’t stop, force kill with -9:
kill -9 <PID>
kill -9 1234

-------------------------------------------------------------------------------------------------------------

4. What are all ports currently active/currently available? What is the command?

Following are the command
1. ss -tulpn
ss - socket statistics 
t - show TCP sockets
u - show UDP sockets
l - show Listening sockets
p - show process using sockets
n - show numerical addereses


2. netstat -tulpn
netstat - nwtwork statistics
t - show TCP sockets
u - show UDP sockets'
l - show only Listening port
p - show the process id
n - Show IP addresses and port numbers in numeric form (do not resolve hostnames/service names).

If remove "l" then it show outbound also 
outbound = state establish
inbound = state listen

sudo ss -tun state established

-------------------------------------------------------------------------------------------------------------

du -sh - shows the directory usage
root@ip-10-3-39-199:/# du -sh /home/ubuntu/guacamole
8.0K    /home/ubuntu/guacamole

df -h - File system usage (entire disk/partition)

In simple words:
du → How much space "this directory" is using.
df → How much space "the whole partition" has available.

-------------------------------------------------------------------------------------------------------------

5. Log file does not get updated/written - what types of issues - how to troubleshoot?

1. Check disk space: df -h
If disk is full, the application cannot write to log file.
df -h

2. Check file permissions: ls -l logfile
ls -l /path/to/logfile

Output - -rw-r--r-- 1 root root 1024 Jun 9 10:00 /var/log/myapp.log
Does the user running the app have write permission?
For example:
If app runs as myuser, but file is owned by root and only writable by root, then app cannot write.
Use chmod or chown to fix permissions.

3. Check process writing logs: ps -ef | grep processname

ps -ef - Show all processes in full detailed format
ps - Process status
e - everything
f - full format

ps -ef | grep myapp

Common cases:
Process crashed
Process stopped
Wrong process writing logs

4. Check log rotation settings: /etc/logrotate.conf
4. Check log rotation settings: /etc/logrotate.conf

Sometimes, log rotation renames or compresses log files and creates new ones. If misconfigured, the application may continue writing to the old (rotated) file, resulting in no new logs appearing in the active log file.

To verify log rotation settings, check the contents of /etc/logrotate.conf. You may find directives like:
# See "man logrotate" for details
weekly
rotate 4
create
compress
include /etc/logrotate.d

Directive	Description
weekly	  Rotate logs on a weekly basis
rotate 4	Keep the last 4 rotated log files
create	  Create a new empty log file after rotation
compress	Compress old rotated logs to save space
include	  Include additional per-application configurations from /etc/logrotate.d/

-------------------------------------------------------------------------------------------------------------

6. How to run script during booting time?

1. Use systemd service.
a. Create the script
sudo nano /usr/local/bin/setup-nginx.sh

b. Paste these commands inside the script:
#!/bin/bash
apt update
apt install -y nginx
ufw allow 'Nginx Full'
systemctl start nginx
systemctl enable nginx

c. Make the script executable:
sudo chmod +x /usr/local/bin/setup-nginx.sh

d. Create the systemd service file - Create a service file:
sudo nano /etc/systemd/system/setup-nginx.service

e. Add the following content:
[Unit]
Description=Setup and start Nginx at boot
After=network.target

[Service]
Type=oneshot
ExecStart=/usr/local/bin/setup-nginx.sh
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target

f. Enable and start the service
sudo systemctl daemon-reload
sudo systemctl enable setup-nginx.service
sudo systemctl start setup-nginx.service

2. Add to crontab with @reboot
The @reboot keyword in cron schedules a command to run once at every system boot.

a. Edit the crontab for your user:
crontab -e

b. Add a line like:
@reboot /path/to/yourscript.sh

-------------------------------------------------------------------------------------------------------------

7. What is soft link and hard link in Linux?
A soft link is like a shortcut that points to the path of another file. It doesn't contain the actual file data, but instead stores the path to the original file. Because of this, if the original file is deleted or moved, the soft link becomes broken and unusable. One advantage of soft links is that they can point to files across different file systems or partitions. Soft links are created using the command ln -s target_file link_name, and when viewed with ls -l, they are identified with a leading l

hard link directly points to the inode of the file—the actual location where the file’s data is stored on disk. Unlike soft links, hard links are just another name for the same file. If the original file is deleted, the data remains accessible through any existing hard links, because the inode still exists as long as at least one link remains. However, hard links cannot span across different file systems, and they also cannot be created for directories (to prevent recursive loops). A hard link is created with the command ln target_file link_name, and it looks exactly like a regular file in the directory listing.

-------------------------------------------------------------------------------------------------------------

8. Difference between process/processor and threads in Linux

Process
A process is an independent unit of execution that has its own memory space, environment variables, and system resources.
Created using commands like fork(), exec(), or running any program (./myapp, python script.py)
Each process has its own PID (Process ID)
Processes do not share memory with each other by default

Example 
You're installing a software package (nginx) using apt, which is a process itself.

Explaination
a. Independent unit of execution
The nginx process runs independently.
It doesn’t depend on other programs to keep running.
Example:
Even if you close the terminal, the nginx process keeps running in the background.

b. Own memory space
The nginx process gets its own memory from the system to use for caching, serving files, handling requests, etc.
This memory is not shared with other processes like mysql or apache.
Think of it like nginx has its own "workspace" (RAM) that no one else touches.

c. Environment variables
nginx might use environment variables (like paths, configurations, or port numbers).
These are values the system gives to the process when it starts.
Example:
It might read a variable like $NGINX_CONF_PATH to know where the config file is.


2. Processor
A processor (also called CPU) is a physical or virtual computing unit that executes instructions from processes and threads.
Your system might have multiple processors (cores)
Each core can handle one or more threads at a time
You can check processor info using:
lscpu

CPU(s):              8
Thread(s) per core:  2
Core(s) per socket:  4

# Real-Life Use Case:
Google Chrome is a good example:
Each tab is a separate process (so one crashing tab doesn’t affect others)
Each tab may use multiple threads to load images, run scripts, etc.
These processes run on available processors (CPUs)

3. Thread
A thread is the smallest unit of execution and exists inside a process. Threads share memory and resources of the parent process.
Threads are useful for multitasking within the same application
Much lighter than processes, with faster creation time
Created in C/C++ using pthread_create() or in Python using threading module
Example:
If you're using a web server like nginx or Apache, it may create multiple threads to handle multiple user requests simultaneously.
ps -eLf | grep <pid>

-------------------------------------------------------------------------------------------------------------

9. What is read, write, execute permissions in Linux?
r (read): view file content.
w (write): modify file.
x (execute): run file as program.
View permissions: ls -l
Change permissions: chmod 755 file

-------------------------------------------------------------------------------------------------------------

10.  How to lock user in Linux?
Lock: passwd -l ubuntu - this will disable login
Unlock: passwd -u ubuntu - this will enable login

Lock a user account (disables login): passwd -l ubuntu
Unlock a user account (enables login): passwd -u ubuntu

Locking a user disables password-based login by adding a ! in front of the encrypted password in /etc/shadow. Unlocking reverses this change.

-------------------------------------------------------------------------------------------------------------

11. How to check available disk space?
df -h → human-readable disk usage.
du -sh /path → directory size.

-------------------------------------------------------------------------------------------------------------

12. What are inodes and how to check inode usage?
An inode is a data structure used by Linux to store information about files and directories (like permissions, ownership, timestamps, etc.).
An inode is like an index card for every file and directory in Linux.
It stores all the metadata (details) about a file — except its name.
Every file or directory on Linux uses one inode.
Check: df -i
Each file consumes one inode.


Every file/folder = 1 inode
If you create:
1 file → uses 1 inode
1000 files → uses 1000 inodes
So, the more files and directories you create, the more inodes are used.

Yes, inode count is fixed at filesystem creation time.
When your root file system (/dev/root) was created (probably using ext4), Linux decided:
Let’s create 917,504 inodes to support that many files.
You cannot increase the number of inodes after creation unless you reformat the filesystem (which erases all data).

Example for better understanding
If you create a lot of tiny files (like logs, mail, or cache files), you might run out of inodes even if disk space is available.

In that case:
Disk space is free ✅
But no more files can be created ❌
Because all inodes are used up

-------------------------------------------------------------------------------------------------------------

-------------------------------------------------------------------------------------------------------------
LINUX QA - ALL

1. How to check schedule jobs
crontab -l
If cron job did not work how would you check
check system time
crontab entry
check /var/log/messages

-------------------------------------------------------------------------------------------------------------

2. To check services
sudo systemctl status jenkins
sudo systemctl start jenkins
sudo systemctl restart jenkins
sudo systemctl stop jenkins

-------------------------------------------------------------------------------------------------------------

3. To see free disk
df -h = Disk Free/Filesystem in Human readable format
df -k = Show in kilobyte
df -m = Show in megbyte
df -BG = Show in gigabyte
du -sh /home/ubuntu = Disk Usage of Summary of specified directory rather than all in Human redable format
du -h /home/ubuntu = Same as above

-------------------------------------------------------------------------------------------------------------

4. What is Bit and Bytes?

Bit (b): A bit is the smallest unit of digital information and can have a value of either 0 or 1. It represents the basic unit of data in computing and telecommunication.

Byte (B): A byte consists of 8 bits. It is the fundamental unit of digital storage in computing. Bytes are used to measure the size of files, programs, and other data. For example, a text file might be 500 bytes in size.

Kilobyte (KB): 1 Kilobyte is equal to 1024 bytes
Megabyte (MB): 1 Megabyte is equal to 1024 kilobytes
Gigabyte (GB): 1 Gigabyte is equal to 1024 megabytes
Terabyte (TB): 1 Terabyte is equal to 1024 gigabytes
Petabyte (PB): 1 Petabyte is equal to 1024 terabytes

-------------------------------------------------------------------------------------------------------------

5. Find Folders?
To find folders
find /path/to/search -type d -name "folder_name"
find /etc -type d -name "sshd" = d directory 
find / -type f -name "filename.txt"
find /home/ubuntu -type f -name "1.txt" = f file

-------------------------------------------------------------------------------------------------------------

6. How to check cpu usage for a process

ps aux = To see detail view of process

top = To see utilization and monitoring

PID (Process ID): This column displays a unique identifier assigned to each process by the operating system. Every process running on the system has a PID, which is used to identify and manage it.
USER: This column shows the username of the user who launched the process. It helps identify which users are running which processes on the system.
PR (Priority): The priority of the process determines its importance in the system's scheduling algorithm. Processes with higher priorities are given more CPU time. Lower values indicate higher priority.
NI (Nice value): The nice value is used to adjust the priority of a process. It ranges from -20 to 19, with lower values indicating higher priority. Processes with higher nice values are less likely to get CPU time, allowing them to run in the background without affecting foreground tasks.
VIRT (Virtual Memory Usage): This column displays the total virtual memory used by the process. It includes all memory the process can access, including shared libraries and memory-mapped files.
RES (Resident Memory Usage): Resident memory usage represents the portion of physical memory (RAM) currently allocated to the process and actively being used.
SHR (Shared Memory Size): This column shows the amount of shared memory used by the process. Shared memory is memory that can be accessed by multiple processes, typically used for inter-process communication.
%CPU (Percentage of CPU Usage): This column displays the percentage of CPU time consumed by the process since the last update of top. It indicates the amount of CPU resources the process is using relative to the total available CPU resources.
%MEM (Percentage of Memory Usage): This column shows the percentage of physical memory (RAM) used by the process relative to the total available memory on the system.
TIME+ (Total CPU Time): This column displays the total CPU time consumed by the process since it started. It includes both user-mode and kernel-mode CPU time.
COMMAND: This column shows the command name or full path of the executable associated with the process. It helps identify what each process is doing based on the command it's running.

Options
Quit top (q): Pressing q will quit the top command and return you to the terminal prompt.
Kill a process by specifying its PID (k): Press k and then enter the PID (Process ID) of the process you want to kill. After entering the PID, press Enter, and then confirm the action by typing y or Y and pressing Enter again.
Change the priority of a process (r): Press r and then enter the PID of the process for which you want to change the priority. After entering the PID, press Enter, and then you will be prompted to enter the new priority value. Once you've entered the new priority value, press Enter again to confirm the change.
Filter processes by a specific user (u): Press u and then enter the username of the user whose processes you want to filter. After entering the username, press Enter, and top will display only the processes associated with that user.
Sort processes by memory usage (M): Press M to sort the processes by memory usage, with the process using the most memory listed first.
Sort processes by CPU usage (P): Press P to sort the processes by CPU usage, with the process using the most CPU listed first.
Sort processes by PID (N): Press N to sort the processes by PID (Process ID), with the lowest PID listed first.
Select and toggle display of specific fields (f): Press f to bring up a menu that allows you to select and toggle the display of specific fields in the process list. Use the arrow keys to navigate the menu, press Space to select or deselect a field, and press Enter to apply your changes.

Using pgrep Command: If you know the name of the process, you can use pgrep to find the PID. For example, to find the PID of the nginx process:
pgrep process name
pgrep nginx

To see or find the particular process
ps aux | grep nginx

To get PID's
pgrep nginx
pidof nginx

To delete some process
ps aux = from here we can get PID
kill PID

-------------------------------------------------------------------------------------------------------------

7. Steps to Add User with Best Practices

a. Create User without Password (Recommended for SSH Key Login)
	sudo adduser --disabled-password yoe
	--disabled-password ensures no password-based login; SSH key-based login is enforced (better for security).
	You'll be prompted for some details like Full Name, Room Number, etc. You can skip those by pressing Enter

b. To check user details
	cat /etc/passwd | grep yoe
	id yoe
	ls /home

c. Set Up SSH Key-Based Authentication (Highly Recommended)
switch to new user
sudo su - yoe

SSH into server as admin user and setup yoe
sudo su - yoe
mkdir -p ~/.ssh
chmod 700 ~/.ssh
nano ~/.ssh/authorized_keys

Set permissions
chmod 600 ~/.ssh/authorized_keys

Test
ssh -i Distributed-key.pem yoe@<server-ip>

Optional: Set Password for yoe for sudo
sudo passwd yoe

Give yoe Admin Rights (If Needed)
sudo usermod -aG sudo yoe

-------------------------------------------------------------------------------------------------------------

7. Networking
netstat = Network Statatics
netstat -nr = netstat -n to display Numerical address and r to display kernal Routing table
Overall, netstat -nr provides a snapshot of the current routing table in the system,

netstat -putn 
-putn: These are options (flags) that modify the behavior of the netstat command:
-p: This option tells netstat to display the process ID (PID) and the name of the program that owns each socket or network connection.
-u: This option tells netstat to display UDP (User Datagram Protocol) connections.
-t: This option tells netstat to display TCP (Transmission Control Protocol) connections.
-n: This option tells netstat to display numerical addresses instead of resolving hostnames and service names. It prevents netstat from performing DNS resolution, which can speed up the command's execution.
 
netstat -putn | grep :22 = to find particulary :22 connection

-------------------------------------------------------------------------------------------------------------

8. Password authentication file
/etc/ssh/sshd_config

Sudoers file to give permission
/etc/sudoers 
user1   ALL=(ALL:ALL) ALL

SSH from another sever
Server1
adduser user1 = Create user
vim /etc/ssh/sshd_config = Yes on Password authentication
sudo systemctl restart sshd = Reload sshd

Sudoers file to give permission / 	Grant admin (sudo) rights to the user - Optional
/etc/sudoers 
user1   ALL=(ALL:ALL) ALL

Server2 or Local machine 
ssh user@Server1publicip

-------------------------------------------------------------------------------------------------------------

9. SCP
Secure Copy file and directiories between local and remote or two remote system
scp -i /path/to/private_key.pem /path/to/local/file.txt user@remote_host:/path/to/destination
scp -i mykey.pem /home/ubuntu/1.txt ubuntu@34.201.69.205:/home/ubuntu = for local to remote and remote to remote with public and private ip

Remote to Remote 
Upload pemfile on server and give read write permissions to user 
chmod u=rw
chmod go=
or chmod u=rw, go=
scp -i mykey.pem /home/ubuntu/1.txt ubuntu@34.201.69.205:/home/ubuntu

Remote to local
scp -i key.pem ubuntu@34.229.177.56:/home/ubuntu/2.txt "\c\Users\12816\Desktop\Azure"

Local to remote
scp -i key.pem "C:\Users\12816\Desktop\file.txt" ubuntu@34.229.177.56:/home/ubuntu/

-------------------------------------------------------------------------------------------------------------

10. To check pacakage installed or not

dpkg --get-selections | grep package_name = Debian Pacakge Manager

-------------------------------------------------------------------------------------------------------------

11. To check number and type of processors used by linux
cat /proc/cpuinfo
lscpu

-------------------------------------------------------------------------------------------------------------

12. To zip and unzip file

1. What is gzip
gzip is for **compressing a single file only.
It cannot compress folders directly.

To compress command
gzip myfile.txt

Output
myfile.txt.gz   ← compressed file

To decompress
gunzip myfile.txt.gz

Output
myfile.txt

2. What is tar
tar is used to combine multiple files or folders into one file (this is called archiving).
tar itself does not compress, it just collects files together.

tar cvf hp.tar hp

hp.tar   ← archive file containing all files from hp/

Part		Meaning
tar		The Linux command to create an archive
c		Create a new archive
v		Verbose mode (shows which files are being added)
f		File name of the archive
hp.tar	The name of the archive file you want to create
hp		The folder you want to archive

To extract back the folder from hp.tar
tar xvf hp.tar

Part	Meaning
x		Extract the files
v		Verbose (show what is being extracted)
f		File name to extract

3. How to Compress Folders (tar + gzip together)
You can combine tar and gzip in one step like this
To archive and compress together

tar -zcvf yois.tar.gz visha
tar -zcvf yois.tar.gz(name which we want to give .tar.gz) visha(this folder exist and want compress)

Option			Meaning
-z				Use gzip to compress
-c				Create an archive
-v				Verbose (show progress)
-f				File name to create
yois.tar.gz  	The name of the compressed archive file you want to create
visha 	 		The folder you want to compress

So this will create
yois.tar.gz   ← compressed archive file

To extract .tar.gz back
tar -zxvf yois.tar.gz

Option	Meaning
-z		Use gzip to compress
-x		Extract the files
-v		Verbose (show progress)
-f		File name to create

Summary:
Task									Command									Use -z?
Compress single file					gzip file.txt							No
Archive folder without compression		tar cvf folder.tar folder/				No
Archive and compress folder				tar -zcvf folder.tar.gz folder/			Yes
Archive and compress multiple files		tar -zcvf files.tar.gz file1 file2		Yes

-------------------------------------------------------------------------------------------------------------

13. To see all the environment variables
env
printenv

-------------------------------------------------------------------------------------------------------------

14. Which command displays memory usage including the ammount of swap space being used
free -h = Human readable

-------------------------------------------------------------------------------------------------------------

15. lsblk and df -h commnad
lsblk → Shows ALL Storage Devices
Shows both mounted and unmounted devices
Includes disks, partitions, USB drives, EBS volumes, etc.
Shows mount points (if mounted), but also lists unmounted disks

df -h → Shows ONLY Mounted File Systems
Displays only the devices that are currently mounted
Shows how much space is used and free (disk usage)

-------------------------------------------------------------------------------------------------------------

16. To see about vm
cat /etc/os-release
cat /etc/issue
uname -a

-------------------------------------------------------------------------------------------------------------

17. Pacakage management 
sudo apt-get update = To update the system, 
sudo apt-get upgrade = To upgrade the system, In upgrade it will delete older version or files and moved to new and we cannot rollback
/var/cache/apt/archives = Saved all cached files
sudo apt-get clean = Cleared all cached data of system
sudo apt-get remove nginx = Delete only software
sudo apt-get purge nginx = Delete with configuration files
sudo apt-get dist-upgrade = It perform distribution upgrade or updgrade kernal

Upgrade server
sudo apt-get update = Update server
sudo apt list --upgradable = To see the list of upgrade pacakges
sudo apt install --only-upgrade (pacakagename) = Update specific pacakage
sudo apt upgrade = Upgrade all the pacakge

-------------------------------------------------------------------------------------------------------------

18. Crontab
https://crontab.cronhub.io/ = To see cron time
crontab -l = To show all the current jobs
crontab -e = To edit or add new jobs
*	*	*	*	* 
Minutes (0-59) 
	Hour (0-23)
		Day of the month (1-31)
			Month (1-12)
				Day of the week (0-6) (Sunday=0)
Create cron job
create bash script in /home/ubuntu
file.sh >> 
#!/bin/bash

touch newfile


chmod ugo=rwx file.sh
crontab -e
40 10 * * * cd /home/ubuntu/ && ./file.sh

-------------------------------------------------------------------------------------------------------------

19. Permission
Folder
chmod ugo=rwx foldername
drwxrwxrwx 2 test test 4.0K Apr 10 09:27 1t
d = directory, rwx = Owner permission, rwx = Group permission, rwx = Other permission ((users who are not the owner or in the group))
File
chmod ugo=rwx filename
-rwxrwxrwx 1 test test 0 Apr 10 09:27 1.txt
- = file, rwx = Owner permission, rwx = Group permission, rwx = Other permission ((users who are not the owner or in the group))
u = User, g = Group, o = Other
Commands
chmod ugo=rwx 
ugo=rwx sets the permissions for the owner, group, and others to read, write, and execute.

Linux Permissions Recap
In Linux, there are 3 types of users:

Symbol	Meaning
u		user (owner of the file/folder)
g		group
o		others (everyone else)
a		 (shortcut for ugo)

1. Full Permissions to All (ugo)
chmod ugo=rwx yoish

2. Full Permission to User Only
chmod u=rwx yoish

3. Execute Only for Group
chmod g=x yoish

4. Remove All Permissions from User & Group
chmod ug-rwx yoish

5. Remove All Permissions from Others
chmod o-rwx yoish

6. Difference between "+" and "="
ls -ld yoish
drwxr-xr-x yoish
chmod o+w yoish
drwxr-xrwx yoish = Here only add "w" permission to other precious read and execute has same 

ls -ld yoish
drwxr-xr-x yoish
chmod o=w yoish
drwxr-x-w- yoish = Here existing permission read and execute replaced with only "w"

-------------------------------------------------------------------------------------------------------------

20. Ownership

Changing group works the same way for both files and folders in Linux.

1. There are 3 types of ownership:
Type		Who is it?
User (u)	The owner of the file (usually the person who created it)
Group (g)	The group that has access to the file
Others (o)	Everyone else (not owner, not group)

ls -l filename
-rwxr-xr-- 1 **yogesh devops** 123 Jul 14 10:00 example.sh

Field				Meaning
-rwxr-xr--			Permissions
1					Number of hard links
yogesh				Owner (user)
devops				Group
123					File size in bytes
Jul 14 10:00		Last modified date
example.sh			File name

-rwxr-xr-- 1 **yogesh devops** 123 Jul 14 10:00 example.sh
What does this mean?
Who					Permissions
User (yogesh)		rwx → read, write, execute
Group (devops)		r-x → read and execute (no write)
Others				r-- → read only

2. Chnage user to visha
-rwxr-xr-- 1 yogesh devops 123 Jul 14 10:00 example.sh
chown visha example.sh
-rwxr-xr-- 1 visha devops 123 Jul 14 10:00 example.sh

3. Two owner user
In Linux, a file or folder can have only ONE owner user at a time.
So, you cannot assign both yogesh and visha as owners together.

How to Share Access Between Users?
Since Linux allows only one owner, the usual way to share a file between multiple users is:
	Use a Shared Group
	Add both yogesh and visha to the same group (e.g., devops).
	Set the file's group ownership to devops.
	Give group permissions as needed.

	Step 1: Add users to the group
	sudo usermod -aG devops yogesh
	sudo usermod -aG devops visha

	Step 2: Set group ownership of the file
	chown yogesh:devops example.sh

4. Change group
-rwxr-xr-- 1 yogesh devops 123 Jul 14 10:00 example.sh
chgrp prod example.sh
-rwxr-xr-- 1 yogesh prod 123 Jul 14 10:00 example.sh

5. Change owner and group
-rwxr-xr-- 1 yogesh devops 123 Jul 14 10:00 example.sh
chown yoish:test example.sh
-rwxr-xr-- 1 yoish test 123 Jul 14 10:00 example.sh

6. sudo chown jenkins:jenbkins file.txt = It will change user and group of file.txt
sudo chown (user):(group) file.txt
sudo chgrp jenkins file.txt = It will change group of file.txt
sudo chown admin file.txt = It will change owner of file.txt

-------------------------------------------------------------------------------------------------------------

21. Remove Directory and File
rm filename
rmdir directoryname
rm -rf directoryname

Summary Table:
Task							Command
Remove a file					rm filename
Remove an empty folder			rmdir foldername
Remove folder + contents		rm -r foldername
Force remove everything			rm -rf foldername

-------------------------------------------------------------------------------------------------------------

22. Adding in users in group

1. create group
sudo addgroup jenkins = To create group which name is jenkins
sudo addgroup group_name = To create group which name is jenkins

2. List user and group
cat /etc/group = To list all the group 
cat /etc/passwd = To list all the users

3. Add a User to a Group
sudo usermod -aG group_name username
sudo usermod -aG jenkins test

What does this mean?
Part				Meaning
sudo				Run the command with admin (root) privileges
usermod				Modify a user account
-a					Append the user to the new group (keep old groups)
-G					Specify the group to add the user to
group_name			The group you are adding the user to
username			The user you are adding

4. Check User Group Membership
groups username
groups test

5. Task	Command
Create a group			sudo addgroup jenkins
List all groups			cat /etc/group
List all users			cat /etc/passwd
Add user to group		sudo usermod -aG jenkins test
Check user groups		groups test

Important:
-aG is safer because it adds the user to the group without removing them from other groups.
Without -a, you might accidentally remove the user from other groups.

-------------------------------------------------------------------------------------------------------------

What is Kernal
What is Components of Linux
What is swap space
What is alias
Environment varibale video
Ownership video = Done

Log rotation demo
Log rotation config files
/etc/logrotate.conf
/etc/logrotate.d

-------------------------------------------------------------------------------------------------------------
23. Log rotation

New Explanation
1. Log Rotation Concept
	Why log rotation?
		Logs grow continuously.
		If not managed, they fill up storage.
	Log rotation means:
		Archive old logs
		Start new empty logs
		Compress old logs to save space

2. Nginxsetup
sudo apt update
sudo apt install nginx -y
sudo systemctl start nginx
sudo systemctl enable nginx
sudo systemctl status nginx

3. Verify NGINX Installation
http://35.153.199.35
curl http://35.153.199.35 

4. Understand NGINX Log Files
By default, NGINX logs are stored in:

	Access Logs:
	/var/log/nginx/access.log

	Error Logs:
	/var/log/nginx/error.log

5. Setup Log Rotation
NGINX often comes with a pre-configured logrotate file at
/etc/logrotate.d/nginx

vim /etc/logrotate.d/nginx

		/var/log/nginx/*.log {
			daily
			missingok
			rotate 14
			compress
			delaycompress
			notifempty
			create 0640 www-data adm
			sharedscripts
			postrotate
				[ -f /var/run/nginx.pid ] && kill -USR1 $(cat /var/run/nginx.pid)
			endscript
		}

Explanation:
Option								Purpose
daily							Rotate logs daily
rotate 14						Keep 14 old log files
compress						Compress old logs
delaycompress					Delay compression by one rotation cycle
notifempty						Do not rotate empty files
create 0640 www-data adm		Create new log files with specific permissions
postrotate						Reloads NGINX to reopen log files

6. Test Log Rotation
sudo logrotate -f /etc/logrotate.d/nginx

7. Check Logs After Rotation
ls -l /var/log/nginx/

access.log.1.gz
error.log.1.gz

8. Log send to S3 Bucket
Install AWS CLI
	sudo apt install awscli -y
	aws configure
Create an S3 Bucket 
	aws s3 mb s3://ezdevopstest

9. Create script 
Script: /usr/local/bin/nginx_logs_to_s3.sh
	#!/bin/bash

	LOG_DIR="/var/log/nginx"
	S3_BUCKET="s3://ezdevops1demo2testy/nginx-logs"

	# Upload compressed logs rotated in the last 1 day
	find $LOG_DIR -name "*.gz" -mtime -1 -exec aws s3 cp {} $S3_BUCKET/ \;

chmod +x /usr/local/bin/nginx_logs_to_s3.sh

10. Cronjob
Create cron job
	crontab -e
		*/2 * * * * /usr/local/bin/nginx_logs_to_s3.sh = every two minutes

11. Test manually
/usr/local/bin/nginx_logs_to_s3.sh

12. List
aws s3 ls s3://ezdevops1demo2testy/nginx-logs/

-------------------------------------------------------------------------------------------------------------
Old Explanation		

Log file location
/var/log
cd /var/log
mkdir myapp = Create directory
cd /myapp
mkdir archive
touch 1.log
truncate -s 15M 1.log = To incraese size of any file 
truncate -s (size you want to required) (filename)
cd /etc/logrotate.d/ = Go to this 
vim myapp and paste below code
/var/log/myapp/*.log{
        daily
        size 1M
        olddir /var/log/myapp/archive
        compress
}

logrotate -d /etc/logrotate.conf = To see status 
logrotate /etc/logrotate.conf = Manual trigeering log rotation


To send logs to s3
Configure Nginx Logging:
Ensure that Nginx is configured to log in a format that's compatible with log rotation. Typically, you'll find this configuration in your Nginx configuration file (nginx.conf). An example log format configuration might look like this:
log_format main '$remote_addr - $remote_user [$time_local] "$request" '
                '$status $body_bytes_sent "$http_referer" '
                '"$http_user_agent" "$http_x_forwarded_for"';
access_log /var/log/nginx/access.log main;


Set Up Log Rotation:
Configure log rotation for Nginx so that logs are rotated daily. This can typically be done using a tool like logrotate in Unix-like systems. Create a log rotation configuration file for Nginx (e.g., /etc/logrotate.d/nginx) with the appropriate settings to rotate logs daily. An example configuration might look like this:
/var/log/nginx/access.log {
    daily
    missingok
    rotate 7
    compress
    delaycompress
    notifempty
    create 0640 nginx adm
    sharedscripts
    postrotate
        /etc/init.d/nginx reload > /dev/null
    endscript
}
Adjust the paths and options according to your setup and preferences.

Install AWS CLI:
Install the AWS Command Line Interface (CLI) if you haven't already. You can follow the instructions provided in the AWS documentation: https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-install.html

Configure AWS Credentials:
Configure AWS credentials for the user who will be executing the script to upload logs to S3. You can set up AWS credentials using the aws configure command or by setting environment variables (AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY, AWS_DEFAULT_REGION).

Write a Script to Upload Logs to S3:
Write a script that uploads rotated log files to an S3 bucket. Here's an example bash script:
#!/bin/bash

# Set variables
LOG_DIR="/var/log/nginx"
S3_BUCKET="your-s3-bucket"
DATE=$(date "+%Y-%m-%d")

# Upload rotated log files to S3
aws s3 cp "$LOG_DIR/access.log-$DATE.gz" "s3://$S3_BUCKET/nginx/access.log-$DATE.gz"
Adjust the variables LOG_DIR and S3_BUCKET according to your setup.

Schedule Script Execution:
Schedule the script to run daily using a cron job. Edit the crontab file using crontab -e and add a line like this:
0 0 * * * /path/to/upload_script.sh

This will execute the script every day at midnight.

By following these steps, Nginx logs will be rotated daily, and the rotated logs will be uploaded to your specified S3 bucket automatically.

-------------------------------------------------------------------------------------------------------------

24. Directory info
/etc/passwd:
Contains information about user accounts on the system, including usernames, user IDs (UIDs), group IDs (GIDs), home directories, and default shells.
Example entry: username:x:1000:1000:John Doe:/home/username:/bin/bash

/etc/shadow:
Stores encrypted password and password-related information for user accounts.
Accessible only by the root user and the shadow group.
Example entry: username:$6$H8X0/Lu7$ExoXqQVBlMtpSG6.J7n0DvFayZ1ldSdQHLkj3aCY1QZyCJQrvEoDP8n9TQGZ5.b...:18912:0:99999:7:::

/etc/group:
Contains information about groups on the system, including group names, GIDs, and a list of member usernames.
Example entry: groupname:x:1001:user1,user2,user3

/etc/ssh/sshd_config:
Configuration file for the OpenSSH server (sshd). Defines settings for SSH server behavior, security, and authentication.
Example settings: Port 22, PermitRootLogin no, PasswordAuthentication yes

/etc/sudoers:
Configuration file for the sudo command. Defines which users and groups are allowed to run commands as superusers and with what privileges.
Accessed and edited using the visudo command.
Example entry: john ALL=(ALL:ALL) ALL

/etc/profile:
A system-wide shell initialization file executed for login shells. Defines environment variables and sets up the user's shell environment.
System-wide configuration that affects all users.
Commonly used to set the PATH variable and define global environment settings.

/etc/hosts:
A simple text file that maps IP addresses to hostnames and is used for local DNS resolution.
Typically used for defining local hostnames and IP addresses, especially in small networks or for testing purposes.

/etc/fstab:
Configuration file that contains information about disk drives and partitions. Defines how and where filesystems should be mounted during the system boot process.
Example entry: /dev/sda1 / ext4 defaults 0 1

/etc/resolv.conf:
Configuration file for DNS resolver library. Specifies the DNS servers, domain search order, and other resolver options.
Example entry: nameserver 8.8.8.8

/etc/nologin:
A file that, when present, prevents non-root users from logging into the system. It is commonly used to temporarily disable logins during maintenance or system changes.

-------------------------------------------------------------------------------------------------------------

25. Upgrade linux server
1. Backup
BackUp Management / upgrade linux server
File-Level Backup
	Backup of /etc
	sudo tar -cvpzf /home/ubuntu/destination/backup.tar.gz --exclude={"/dev","/proc","/sys","/tmp","/run","/mnt","/media","/lost+found"} /etc
	sudo: This command is run with superuser privileges, allowing you to perform operations that require administrative permissions.
	tar: This is the command-line utility for creating and manipulating tar archives.
	-cvpzf: These are options passed to tar:
	-c: This option stands for "create," indicating that you want to create a new archive.
	-v: This option enables verbose output, providing more detailed information about the files being archived.
	-p: This option preserves file permissions and ownership when creating the archive.
	-z: This option compresses the archive using gzip.
	-f: This option specifies the name of the archive file.
	/home/ubuntu/destination/backup.tar.gz: This is the path and name of the tar archive that will be created. In this case, it will be saved as backup.tar.gz in the /home/ubuntu/destination/ directory.
	--exclude={"/dev","/proc","/sys","/tmp","/run","/mnt","/media","/lost+found"}: This option specifies directories to be excluded from the backup process. These directories are system-specific and are commonly excluded in backups as they typically contain temporary or system-specific files that are not necessary for backup purposes.
	/etc: This is the source directory that you want to archive. In this case, it's the /etc directory, which typically contains system configuration files on Unix-like operating systems.
	So, overall, this command creates a compressed tar archive (backup.tar.gz) of the /etc directory while excluding specified system directories and saves it in /home/ubuntu/destination/.

	mkdir -p /home/ubuntu/destination = To create destination folder
	
	sudo tar -cvpzf /path/to/backup.tar.gz --exclude={"/dev","/proc","/sys","/tmp","/run","/mnt","/media","/lost+found"} /
	
	sudo: This command is used to execute the subsequent command with elevated privileges. It allows the tar command to access and read files that might require superuser permissions.
	tar: This is a command-line utility used to compress and archive files and directories.
	-c: This option stands for "create." It instructs tar to create a new archive.
	-v: This option stands for "verbose." When used, tar will output the names of the files or directories being archived.
	-p: This option preserves the permissions of the files being archived. Without this option, the permissions would be set based on the umask of the user extracting the archive.
	-z: This option tells tar to compress the archive using gzip.
	-f: This option specifies the filename of the archive to create.
	/path/to/backup.tar.gz: This is the filename and path of the archive that tar will create. In this case, it's /path/to/backup.tar.gz.
	--exclude={"/dev","/proc","/sys","/tmp","/run","/mnt","/media","/lost+found"}: This option specifies directories to exclude from the backup. It uses the --exclude flag followed by a list of directories enclosed in curly braces {}. These directories are excluded because they typically contain temporary or system-specific files that are unnecessary for a backup.
	/: This is the root directory. In this command, it specifies that tar should start archiving from the root directory, meaning it will include all files and directories starting from the root of the filesystem.

	Database Backup
	mysqldump -u username -p database_name > backup.sql
	Replace username with your MySQL username, database_name with the name of the database you want to back up, and backup.sql with the desired filename for the backup file.For example, if your MySQL username is myuser and you want to back up a database named mydatabase, you would run:
	mysqldump -u myuser -p mydatabase > backup.sql
	After running the command, you'll be prompted to enter your MySQL password. Enter the password associated with the specified username and press Enter.
	The mysqldump command will dump the contents of the specified database into a SQL file named backup.sql. This file will contain SQL statements necessary to recreate the database structure and insert the data.
	Once the command completes, you'll have a backup file (backup.sql) containing the contents of your MySQL database.
	Remember to store the backup file (backup.sql) in a secure location. You can use this backup file to restore your database if needed by importing it into MySQL using the mysql command.

2. Check current version: Determine the current version of your Linux distribution. 
You can usually do this by running the following command:
root@ip-172-31-18-28:/# lsb_release -a
No LSB modules are available.
Distributor ID: Ubuntu
Description:    Ubuntu 24.04 LTS
Release:        24.04
Codename:       noble
	
3. Update packages: Before upgrading the distribution, ensure all installed packages are up to date. Run the following commands to update the package list and upgrade installed packages:
	sudo apt update
	sudo apt upgrade
	
4. Upgrade process: The method for upgrading the Linux distribution varies depending on the distribution itself. For Debian-based systems like Ubuntu, you typically use the do-release-upgrade command. For example:
	sudo do-release-upgrade
	
5. Reboot: After the upgrade process completes successfully, it's recommended to reboot the server to apply any necessary changes:
	sudo reboot
Backup process completed
************************
Rollback
	Files
	Boot into Recovery or Live Environment: If your system is currently running the upgraded version and you want to rollback, you'll need to boot into a recovery environment or a live CD/USB with a compatible version of Ubuntu.
	Prepare Disk: Mount the partition where you want to restore the backup. If necessary, you may need to format or clear the existing data on the partition.
	Extract Backup: Use the tar command to extract the backup into the target directory. Make sure to extract it to the root of the filesystem ("/").
	sudo tar -xvpzf /path/to/backup.tar.gz -C /target/directory
	Replace "/path/to/backup.tar.gz" with the path to your backup file and "/target/directory" with the mount point of the partition you want to restore to.
	Update Bootloader: If your backup includes system files or configuration changes related to the bootloader (GRUB), you may need to reinstall or update the bootloader to ensure the system boots correctly. You can do this using the grub-install command.
	Reboot: Once the extraction is complete and any necessary bootloader configuration has been updated, reboot the system. It should now boot into the previous state as per the backup.
	Verify: After rebooting, verify that the system has been rolled back to the previous state and that all necessary services and configurations are functioning correctly.
	Rolling back a system using a backup can be complex, and it's important to ensure that you have a clear understanding of the process and any potential risks involved. Additionally, make sure to back up any critical data before attempting a rollback, as it may result in data loss if not done properly. If you're unsure about any step in the process, consider seeking assistance from a professional or consulting the official documentation for your Linux distribution.

	RDS
	If you've taken a backup of your MySQL database using mysqldump, you can potentially use that backup to restore your database to its previous state. Here's a general outline of the steps you could take to rollback your MySQL database using the backup:

	Access MySQL Shell: Log in to your MySQL server using the MySQL shell. You'll need the MySQL username and password that you used when taking the backup.
	mysql -u username -p

	Drop Existing Database (Optional): If you want to completely replace the existing database with the backup, you can drop the existing database and recreate it. Be extremely cautious with this step, as it will permanently delete all data in the database.
	DROP DATABASE database_name;
	CREATE DATABASE database_name;

	Restore Database from Backup: Use the mysql command to restore the database from the backup file (backup.sql). Make sure to specify the database name if you haven't dropped and recreated the database.
	mysql -u username -p database_name < backup.sql
	Replace username with your MySQL username, database_name with the name of the database you're restoring, and backup.sql with the path to your backup file.

	Verify: After restoring the database, verify that the data has been successfully restored by querying the database.
	USE database_name;
	SHOW TABLES;

	This will display a list of tables in the restored database. You can also run other queries to ensure that the data is as expected.
	That's it! Your MySQL database should now be rolled back to the state it was in when you took the backup. Make sure to test your applications thoroughly to ensure that everything is functioning correctly after the rollback. Additionally, always ensure that you have recent backups of your data before attempting any major operations like database rollback.

-------------------------------------------------------------------------------------------------------------

26. What is Swap Memory?

Swap memory is a part of the hard disk (or SSD) that is used as virtual memory when the physical RAM (Random Access Memory) is full.
It acts as an overflow space for your RAM.

Why is Swap Needed?
If all available RAM is used, Linux starts moving inactive processes or data from RAM to Swap space.
This prevents the system from crashing due to out-of-memory errors.
It helps keep the system running but is slower than RAM because disk read/write speeds are much lower.

Where is Swap Stored?
Swap Partition: A dedicated partition on the disk.
Swap File: A special file that behaves like swap.

Commands to Check Swap
free -h   # Shows RAM and Swap usage
swapon -s # Shows active swap

How to Create Swap (Basic Steps)
sudo fallocate -l 2G /swapfile   # Create 2GB swap file
sudo chmod 600 /swapfile         # Set correct permissions
sudo mkswap /swapfile            # Make it swap
sudo swapon /swapfile            # Enable swap

-------------------------------------------------------------------------------------------------------------

27. Component of Linux

1. What is kernal
The kernel is the core program of the operating system.
It sits between your computer hardware and your software (apps, commands, etc.).
Think of it as a bridge or controller:
It receives requests from software (like a video player, browser)
And gives instructions to hardware (like CPU, RAM, Disk)

Types of Kernels (Just for Knowledge)
There are different styles of kernels:
Type				Description
Monolithic		All functions run in one big kernel (Linux uses this)
Microkernel		Only core functions in the kernel; rest outside
Hybrid			Mix of both (Windows, macOS)

The kernel is the core part of the Linux operating system.

Think of it like the "heart" or "brain" of the OS. It manages:
Memory (RAM)
CPU (processor)
File system
User programs
Hardware devices (like keyboard, mouse, disk, network)

Simply: The kernel connects software (your apps) to hardware (your computer).

2. What is a Shell in Linux?
A Shell is a program that takes your input (commands) and sends them to the kernel to perform the task.
You talk to the shell, and the shell talks to the kernel.

Imagine the kernel is a powerful machine, but it only understands a specific language.
The shell is like a translator or assistant:
You tell the shell: "I want to list all files" (ls)
The shell translates this to machine language the kernel understands
The kernel fetches the list from storage and sends the result back through the shell

There are different shells, each with some unique features
Shell	Description
bash	Most common; default on many Linux systems
sh		Very basic shell; used in scripting
zsh		Advanced; has better auto-completion, themes
fish	Friendly Interactive Shell; colorful and user-friendly

3. What is a File System in Linux?
The file system is the way Linux organizes and stores data on disk — like files, folders, devices, and system information.

It allows:
Storing
Reading
Writing

Linux uses a tree structure starting from root /
/
├── bin     → essential commands (like ls, cp, mv)
├── boot    → boot loader files (like vmlinuz, grub)
├── dev     → device files (like hard drives, USB)
├── etc     → configuration files
├── home    → user folders (like /home/vina)
├── lib     → system libraries
├── proc    → info about processes and kernel
├── tmp     → temporary files
├── usr     → user-installed programs
├── var     → logs, mail, print queues

Types of Files in Linux

Type		Example								Description
Regular file	file.txt, script.sh		Normal text or binary file
Directory		myfolder/				A folder that holds other files
Device file		/dev/sda				Represents a hardware device
Link			shortcut -> file.txt	Like a shortcut or alias
Socket/pipe		/run/docker.sock		Special files for communication

4. System Libraries
System Libraries are pre-written pieces of code that programs and even the kernel can use to perform common tasks.
They save time and effort by providing ready-made functions like:

Opening files
Reading input
Managing memory
Connecting to a network
Printing to screen

Instead of rewriting the same code every time, applications just reuse these libraries

5. User space
User Space is where YOU and your apps live.
It’s the part of Linux that lets users interact with the system, without directly touching the kernel.

Think of User Space as your playground, where you can:
Run commands
Use programs
Create files
Launch services

+----------------------+
|  User Applications   | ← You use this
+----------------------+
|        Shell         | ← Command line interface
+----------------------+
|   System Libraries   |
+----------------------+
|        Kernel        | ← Core of Linux
+----------------------+
|     Hardware (CPU, RAM, Disk)  |
+----------------------+


Component				Role
Kernel				Talks to hardware and manages everything
Shell				Lets users give commands to the system
File System			Organizes files and folders
System Libraries	Help apps communicate with kernel
User Space			Includes commands, tools, applications

-------------------------------------------------------------------------------------------------------------

28. OS
An operating system (OS) is a software program that serves as an intermediary between users and computer hardware. It manages computer hardware resources, provides a platform for running applications, and facilitates communication between hardware and software components.
Here are some key functions of an operating system:
Resource Management: The operating system manages computer hardware resources such as the CPU, memory (RAM), storage devices (hard drives, SSDs), input/output devices (keyboard, mouse, monitor), and network devices. It allocates resources efficiently among running programs to ensure optimal performance.
Process Management: The OS controls the execution of programs or processes. It creates, schedules, and terminates processes, allowing multiple programs to run simultaneously (multitasking) while ensuring fair access to system resources.
Memory Management: The operating system manages system memory (RAM) by allocating memory space to processes as needed. It also handles virtual memory, allowing processes to use more memory than physically available by swapping data between RAM and disk storage.
File System Management: The OS provides a file system that organizes and stores data on storage devices. It manages files, directories, and file access permissions, allowing users and applications to read, write, and manipulate files stored on the system.
Device Management: The operating system interacts with hardware devices such as printers, scanners, disk drives, and network interfaces through device drivers. It controls device communication, handles input/output operations, and manages device configurations.
User Interface: The OS provides a user interface through which users interact with the computer. This can be a command-line interface (CLI) where users type commands, a graphical user interface (GUI) with windows, icons, and menus, or a combination of both.
Security: Operating systems implement security measures to protect the system and user data from unauthorized access, malware, and other security threats. This includes user authentication, access control mechanisms, encryption, and antivirus software integration.
Common examples of operating systems include Microsoft Windows, macOS (formerly OS X), Linux, Unix, and Android. Each operating system has its own features, design principles, and target platforms, catering to different user needs and computing environments.

Kernel: At the core of Linux lies the kernel, which serves as the bridge between hardware and software. It manages system resources such as CPU, memory, peripherals, and provides essential functionalities like process management, memory management, device drivers, and system calls. The Linux kernel is monolithic, meaning that it runs in privileged mode and directly interacts with hardware.
It's a piece of software that acts as the middleman between your computer's hardware (like the keyboard, mouse, and processor) and the software you use (like your web browser or word processor).
Here's what the kernel does:
Hardware Management: It makes sure that different parts of your computer, like the processor, memory, and disk drives, work together smoothly.
Process Management: Think of it as a traffic controller. It manages the different programs running on your computer, making sure they don't interfere with each other and get their fair share of resources.
Memory Management: It keeps track of how much memory each program is using and allocates memory to them as needed. This helps prevent programs from crashing due to lack of memory.
Device Drivers: Your computer has various hardware devices like printers, scanners, and graphics cards. The kernel talks to these devices through special programs called device drivers, making sure they work correctly.
System Calls: Programs need to ask the kernel to do things like reading files from disk or accessing the network. These requests are called system calls, and the kernel handles them.
In short, the kernel is the core part of your computer's operating system that handles all the behind-the-scenes work, making sure everything runs smoothly and your computer does what you want it to do.

System Library:
System libraries are some predefined functions by using which any application programs or system utilities can access kernel’s features. These libraries are the foundation upon which any software can be built.
These libraries contain pre-made functions that perform common tasks, like reading files, managing memory, or connecting to the internet. Instead of writing these functions from scratch, developers can just use the ones provided by the library.
System libraries contain a collection of pre-written functions that perform common tasks. These functions can be reused by multiple programs, saving developers time and effort by avoiding the need to rewrite the same code for similar tasks in different programs.
Some of the most common system libraries are:
GNU C library: This is the C library that provides the most fundamental system for the interface and execution of C programs. This provides may in-built functions for the execution.
libpthread (POSIX Threads): This library plays important role for multithreading in Linux, it allows users for creating and managing multiple threads.
libdl (Dynamic Linker): This library is responsible for the loading and linking file at the runtime.
libm (Math Library): This library provides user with all kind of mathematical function and their execution.
Some other system libraries are: librt (Realtime Library), libcrypt (Cryptographic Library), libnss (Name Service Switch Library), libstdc++ (C++ Standard Library)


System utilities
System utilities for Linux are tools or programs that help you manage and control your computer system. They perform various tasks like monitoring system performance, managing files, configuring settings, and troubleshooting issues. Here are some common system utilities and what they do:
Terminal/Command Line: This is like the control center of your computer. You can type commands to perform tasks such as navigating files, installing software, or checking system information.
File Manager: Just like the file explorer in Windows, it helps you navigate through your files and folders, move, copy, or delete them.
Task Manager: It shows you what programs are running, how much memory and CPU they're using, and allows you to end tasks if needed to free up resources.
Disk Usage Analyzer: This tool helps you see what's taking up space on your hard drive, so you can manage your disk space more efficiently.
Package Manager: It's used for installing, updating, and removing software packages on your system. You can think of it as an app store for Linux.
System Monitor: Similar to Task Manager, it gives you an overview of your system's performance, including CPU usage, memory usage, network activity, etc.
Text Editor: A simple tool for creating and editing text files. It's useful for writing scripts, configuring system settings, or editing code.
Backup Software: Helps you create backups of your important files and settings, so you can restore them in case of data loss or system failure.
Firewall Configuration Tool: Allows you to control the incoming and outgoing network traffic to protect your system from unauthorized access.
Terminal Multiplexer: These utilities allow you to run multiple terminal sessions within a single terminal window, which can be very useful for managing multiple tasks simultaneously.
These utilities are essential for managing and maintaining a Linux system, and understanding how to use them can greatly enhance your experience with the operating system.

Raghulraj had given me task, Task is "After completing the Azure pipeline build, an automated email notification is triggered, including the log file as an attachment"
So i have done this task and related to such task i am exploring more in Azure Devops

Shell
A shell is like a command-line interface or a text-based user interface where you can interact with the operating system by typing commands. It's like a bridge between you and the computer, allowing you to tell the computer what to do.
Here's a bit more detail:
Interface: Think of the shell as a window into the guts of your operating system. Instead of clicking icons or buttons like you would in a graphical user interface (GUI), you type commands and the computer responds with text output.
Commands: You can execute various commands in the shell to perform tasks such as creating files, copying data, navigating through directories, and more. These commands are often simple words or abbreviations, like "ls" to list files or "cd" to change directories.
Scripting: Shells also support scripting, which means you can write sequences of commands into a file (called a script) and then execute that file as if it were a single command. This is powerful for automating tasks or running complex operations.
Customization: Users can customize their shell experience by configuring settings, defining aliases (shortcuts for commands), and even creating custom functions or scripts to extend the shell's capabilities.
Types of Shells: There are different types of shells available for Linux, with "Bash" (Bourne Again Shell) being one of the most common. Other popular shells include "Zsh" (Z Shell) and "Fish" (Friendly Interactive Shell). Each shell has its own features and syntax, but they all serve the same basic purpose.
Overall, the shell is a powerful tool for interacting with Linux systems, offering flexibility, efficiency, and the ability to perform a wide range of tasks from the command line

-------------------------------------------------------------------------------------------------------------

29. S3

Bucket name = my-bucket-name

1. Create S3 Bucket
aws s3 mb s3://my-new-bucket

2. List Buckets
aws s3 ls

3. List Files in a Bucket
aws s3 ls s3://my-bucket-name

4. Upload File to S3 (Single File) - Uploads myfile.txt to my-bucket-name.
aws s3 cp myfile.txt s3://my-bucket-name/

5. Upload Directory to S3 (Recursive Upload)
aws s3 cp /path/to/myfolder s3://my-bucket-name/ --recursive
Uploads the entire folder myfolder to my-bucket-name

6. Delete Bucket
aws s3 rb s3://my-bucket-name --force

7. Delete File from S3
aws s3 rm s3://my-bucket-name/myfile.txt
Deletes myfile.txt from my-bucket-name

8. Copy from s3 to local
aws s3 cp s3://ezdevops1demo2testy/nginx-logs/ /home/ubuntu/yoish/ --recursive

Explanation
s3://ezdevops1demo2testy/nginx-logs/ → Your S3 folder
/home/ubuntu/yoish/ → Destination folder on your server
--recursive → Copies all files & subfolders

9. Sync local to bucket
aws s3 sync /home/ubuntu/yoish/ s3://ezdevops1demo2testy/

Sync - Copies only new or changed files
		Skips files that are already the same

10. Sync bucket to local
aws s3 sync s3://ezdevops1demo2testy/ /home/ubuntu/yoish/

-------------------------------------------------------------------------------------------------------------





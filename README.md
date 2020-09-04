# udev-mouse
Disable Middle-click Paste feature on mouse plug-in [LINUX]

I am running 'Linux parrot 5.5.0-1parrot1-amd64 #1 SMP Parrot 5.5.17-1parrot1 (2020-04-25) x86_64 GNU/Linux'

username : john

0- unplug your mouse

1- Make sure you are at the home directory
    
    $ cd

2- run:

    $ sudo udevadm monitor

3- plug your mouse
    
    // ouput from udevadm monitor
    
    UDEV  [4504.783014] bind     /devices/pci0000:00/0000:00:14.0/usb2/2-2 (usb)
    
    // the last ACTION performed by my system is "bind", take note of yours
    
4- open another Terminal/Tab:

    $ lsusb
       
        // output
        ...
        Bus 002 Device 040: ID 18f8:0f97 [Maxxter] USB OPTICAL MOUSE // Target device
        ...

4- install xinput:

    $ sudo apt install xinput -y

5- Create your script:

    $ nano killMouse.sh && chmod +x $_

        # copy and paste
        # replace DEVICE with your device name
        # replace <username> with yours
        # file must have shebang (i.e:  #!/bin/bash || #!/bin/sh || ... )
        # -----------------
        #! /bin/bash 
        
        DEVICE="USB OPTICAL MOUSE "
        xinput set-button-map "$DEVICE" 1 0 # disables middle-click paste feature

        OUTPUT=$( xinput get-button-map "$DEVICE" )
        
        #  using '>>' treats the file as a log (appending), using '>' will overwrite whatever that was saved in that file.
        
        echo "$OUTPUT | $(date)" >> /home/john/output.txt 

        # -------------
        # save and exit


6- create your rules:

    --- XINPUT WON'T LAUNCH UNDER WAYLAND ---
    $ echo $XAUTHORITY
    
        // output
        /home/john/.Xauthority

    $ echo $DISPLAY
        
        //ouput
        :0.0

    $ nano 40-local.rules
        
        // copy & paste, make sure that you change ENV{XAUTHORITY}, ATTRS{idVendor}, ATTRS{idProduct}, /home/<username> and ACTION with your values
        // single line
        
        ENV{DISPLAY}=":0.0", ENV{XAUTHORITY}="/home/john/.Xauthority", ACTION=="bind", ATTRS{idVendor}=="18f8", ATTRS{idProduct}=="0f97", RUN+="/home/john/killMouse.sh"

7- copy your rules to /etc/udev/rules.d:
    
    $ sudo cp -rv ~/40-local.rules /etc/udev/rules.d/

8- reload udevadm rules:

    $ sudo udevadm control --reload

9- restart udev service:

    $ sudo service udev restart

    or

    $ sudo systemctl restart udev.service

10- plug in your mouse and open /home/{user}/output.txt:

    // output
    1 0 3 4 5 6 7 8 9  | Thu Aug 13 19:02:31 +01 2020
    1 0 3 4 5 6 7 8 9  | Thu Aug 13 19:02:31 +01 2020
    1 0 3 4 5 6 7 8 9  | Thu Aug 13 19:02:31 +01 2020
    1 0 3 4 5 6 7 8 9  | Thu Aug 13 19:02:31 +01 2020
    1 0 3 4 5 6 7 8 9  | Thu Aug 13 19:02:31 +01 2020
    

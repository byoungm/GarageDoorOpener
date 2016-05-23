# GarageDoorOpener

Uses Red Bear Duo and iPhone to create a garage door opener that can open / close a garage door and find out the garage door state.
A relay circuit is used betwen the garage door operator/controller and the Red Bear Duo to open / close the garage door.
A reed switch is used to detect the garage door state (open or closed).  The reed switch is connected to wall and a magnet is connected to the garage door.

# Circuit Desin
* Image to be up loaded

# Particle.io
Particle.io is used to compile and update the user FW for the Red Bear Duo.  The Particle Folder contains all the nessassary FW files written in c++

# iOS Code
The iOS code folder contains the code to run on an iPhone.  The main code is written in objective-c. CocaPods are used for 3rd Part libraries.

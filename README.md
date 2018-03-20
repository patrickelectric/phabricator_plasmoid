# phabricator-plasma-widget
A Plasma widget for visualizing Phabricator data

# Build instructions

cd /where/your/applet/is/generated
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX=MYPREFIX ..
make
make install

(MYPREFIX is where you install your Plasma setup, replace it accordingly)

Restart plasma to load the applet
(in a terminal type:
kquitapp plasmashell
and then
plasmashell)

or view it with
plasmoidviewer -a YourAppletName

# Tutorials and resources
The explanation of the template
https://techbase.kde.org/Development/Tutorials/Plasma5/QML2/GettingStarted

Plasma QML API explained
https://techbase.kde.org/Development/Tutorials/Plasma2/QML2/API

To install:
cd phabricator-plasma-widget
kpackagetool5 -t Plasma/Applet --install package

To upgrade:
kpackagetool5 -t Plasma/Applet --upgrade package

To test:
plasmawindowed org.kde.plasma.phabricator
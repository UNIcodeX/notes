NOTE: The following commands assume that your user has sudo access. If not, this can be accomplished by "usermod -G wheel {user}" without quotes, as root. It is also necessary to uncomment the following line in /etc/sudoers:
%wheel ALL=(ALL) ALL


If platform is Arch x86_64 Enable multilib repository
=========================================
Uncomment the following in /etc/pacman.conf:
[multilib]
Include = /etc/pacman.d/mirrorlist

Update the package database 
=======================
sudo pacman -Syu

If platform is Arch x86_64:
====================
sudo pacman -S jdk7-openjdk \
python2 \
python2-pip \
python2-kivy \
mesa-libgl \
lib32-mesa-libgl \
lib32-sdl2 \
lib32-sdl2_image \
lib32-sdl2_mixer \
sdl2_ttf \
unzip \
gcc-multilib \
gcc-libs-multilib

If prompted with the following, answer 'y' for both prompts:
::gcc-multilib and gcc are in conflict. Remove gcc?
::gcc-libs-multilib and gcc-libs are in conflict. Remove gcc-libs?

If platform is Arch x86:
==================
sudo pacman -S jdk7-openjdk \
python2 \
python2-pip \
python2-kivy \
mesa-libgl \
sdl2 \
sdl2_image \
sdl2_mixer \
sdl2_ttf \
unzip


Install Cython:
===========
sudo pip2 install cython


Install buildozer:
==============
git clone http://github.com/kivy/buildozer
sudo python2 setup.py install


DONE!

From here you should be able to run the buildozer build process.
- buildozer init
- modify the buildozer.conf as necessary
- buildozer android debug serve

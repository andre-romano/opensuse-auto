openSUSE-Auto
===================


This repository stores scripts to automate **openSUSE**&trade;<sup id=opensuse_back>[1](#opensuse)</sup> Linux distribution in many ways. They allow installation, configuration and optimization of software, as well as solve common **openSUSE** &trade; or Linux issues and problems.

Special Scripts
---------------

These scripts have very specific and individual purposes that differ from the each other. Please check them carefully below.

### Configure Distro - System Initial Configuration

These scripts are used to install all the required drivers, codecs and some frequently software inside your **openSUSE&trade;**. The best way to do this is to run the following command from the repository root directory:

```Shell
sudo ./install.sh
```


### Repositories - Custom Useful Repositories

These scripts are used to install new repositories inside your **openSUSE&trade;**. To install a repository, you only need to cd to the Repositories directory, and run the repository script:

```Shell
cd Repositories
sudo ./name_of_repository_to_add.sh
```

> **CAUTION:**  
>  
> Be extra careful with the repositories you add in your system, as well as their priorities. **A bad repository with a high priority might harm your system really bad (to the point of needing a full reinstall of the OS). As a rule of thumb, only install repositories that you TRUST, as you NEED them**. By default, only a subfraction of the repositories available in the _Repositories_ directory is installed in the system when you issue the system configuration command _"sudo ./install.sh"_. Check _"Configure Distro/install.sh"_ for more info.  

> **CONSISTENCY:**  
>  
> Also, keep in mind that if you're using a set of softwares from a repository, only use this repository for these types of software. In other words, keep the consistency of your system at all cost.  
> __**Eg:**__ if you install _ffmpeg_ from _Packman_ repository, all multimedia codecs (and related software and tools) you install / update thereafter should come from _Packman_ repository **ONLY**. Failing to do so may cause system instability, problems with libraries and software malfunction.  

>**KERNEL:**  
>  
> **Do not mess with your kernel unless you know what you're doing.** The "Repositories" path contain the latest kernel repository (kernel.sh) tested and patched by the **openSUSE&trade;** community. This DOES NOT mean you should update your kernel. Keep in mind that newer kernels might have unknown bugs and issues, as well as stability problems. **As a rule of thumb, only upgrade / compile your kernel if:**  
> - You have hardware performance issues
> - Your hardware is not recognized or is malfunctioning  
> - You require or use a bleeding edge filesystem (BTRFS, ZFS, etc)  
> - A security breach has been found and needs to be patched

### luks - Managing Cryptographic Files within Linux

> **DESCRIPTION:**  
>
> LUKS is an OpenSource, platform-independent standard that allows you to safely store files in your computer, by using advanced cryptography algorithms. It was built to be really fast, and it works really well in Linux.  
> LUKS works by storing a special header in the partition of your permanent storage device (HDD, SSD, etc) to configure it's parameters. For more information about LUKS, check the [Wikipedia article](https://en.wikipedia.org/wiki/Linux_Unified_Key_Setup) and the [Arch Wiki](https://wiki.archlinux.org/index.php/Dm-crypt).  
>As LUKS is a complex system that requires a bunch of commands to work properly, scripts were created to make life easier :D . They automate the tasks required to create and use LUKS inside a file. This file will then operate as a LUKS container. In other words, this file works as a physical device, with limited storage size, connected to your computer, that uses cryptography to protect it's data.  
> The scripts do all the hard work for you in order to make this complex system work, as easy as it can get for the final user. In a few words these scripts do the following:  
> - Create the file in your permanent storage device (if it's not already created))
> - Set the file to operate as a LUKS device
> - Map this file into a virtual device
> - Mount this virtual device with the user provided password.  

> **NOTE:**  
>  
> - This script analyses the file to detect any data corruption before mounting. If any errors are found, the script will try to fix them. If the fix is not possible, it warns the user about the problem. 
> - **This script DOES NOT STORE ANY PASSWORD. It means that if you lose your password, you'll lose all the data that is stored inside the file container.**

These scripts are used to open, close and create LUKS container files. To be able to use them, you will need to run the command below to install them in your system:

```Shell
cd luks
sudo ./install.sh
```

> **Note:**  
>  
> After executing this command, you'll have 3 new scripts installed inside your system:
> - _lopen_  
> - _lclose_  
> - _lcreate_  

> They open, close and create LUKS file containers respectively. For more info, use the argument --help with them.

### Tar7Z - Allow 7zip as a compression option for .tar files

The script tar7z allows you to use 7zip as a compression method in .tar files. To do so, you will need to install the script in your system:

```Shell
cd Tar7Z
sudo ./install.sh
```

> **Note:**  
>  
> After executing this command, you'll have 1 new script installed inside your system:
> - _tar7z_  

> For more info, use the argument --help.

### pdf - Script that compresses PDFs with GhostScript

This script compresses PDFs into smaller ones, appending the suffix "_compress.pdf" to them. To do so, this script requires the binary "gs" (GhostScript) that it can install automatically (using zypper). All you have to do is issue the following commands:

```Shell
cd pdf
sudo ./install.sh
```

> **Note:**  
>  
> After executing this command, you'll have 1 new script installed inside your system:
> - _pdfcompress_  

> For more info, use the argument --help.

### isomount - Script that makes the mount of CDs easier

This script mounts CDs (without requiring you to type all that mount syntax yourself). To install this script, run the following:

```Shell
cd isomount
sudo ./install.sh
```

> **Note:**  
>  
> After executing this command, you'll have 2 new scripts installed inside your system:
> - _isomount_  
> - _isoumount_  

> They mount and unmount the CDs respectively. For more info, use the argument --help with them.  


### ffmpeg - Script that makes ffmpeg transcoding easier

This script makes transcoding into common codecs and containers easier. It also applies some filters to improve image / audio quality. To install this script, run the following:

```Shell
cd ffmpeg
sudo ./install.sh
```

> **Note:**  
>  
> After executing this command, you'll have 4 new scripts installed inside your system:
> - _mp3_encode_  
> - _vp9_encode_  
> - _x264_encode_  
> - _x265_encode_  

> They transcode multimedia files into their respective containers (see the scripts names for the destination container). For more info, use the argument --help with them.

### ntfs - Script that makes NTFS filesystem mounting less troublesome

Linux may have issues mounting NTFS filesystems, either because they were hibernated or have any type of corruption. If this happens, the system boot is interrupted as /etc/fstab could not mount it's mountpoints. To deal with this without causing boot issues to the Linux system (making Dual Booting with Windows easier), this script was created. To install this script, run the following:

```Shell
cd ntfs
sudo ./install.sh
```

> **Note:**  
>  
> After executing this command, the file /etc/ntfs_to_mount.conf will be created. This file must contain a list of the devices to be mounted with NTFS upon system boot. To write into this file, follow the syntax below:
```Shell
/dev/DEVICE_NAME MOUNTPOINT
```

--------

Utilities
---------------

This path contain scripts that can be useful in different scenarios. They are used throughout this repository as auxiliary scripts to simplify common tasks. Check the description of them below (for more info, type _--help_ with the script):

| Script | Description |
| :------- | :---- |
| drivers.sh | Shows a list of the drivers currently being used in your system |
| setautoupdate.sh | Installs an autoupdate script that checks periodically if software updates are needed. If they are, it installs them. **NOTE: It only checks for some non-critical software for updates. So the kernel and other system packages ARE NOT UPDATED AUTOMATICALLY.**. Only the packages contained inside /etc/autoupdate are updated. When the update is completed, the log file /var/log/autoupdate.log is generated. |
| list_installed.sh | Dumps the installed packages and repositories of the system into two files: _installed.packages_, _installed.repositories_. |
| suse_version.sh | Script that returns the openSUSE version of the system. Used throughout the repository for OS version probing. |

--------

Installation / Configuration of New Software
---------------

These scripts allow you to rapidly install and / or configure (with minimal to no human intervention) any software that is listed here.

### openSUSE&trade; Scripts
These scripts are developed to work with openSUSE OS's only. With some changes they may work fine in other OS's as well.  
When executed, these scripts will do the following:
- Add the required repositories (when / as they're needed)  
- Install the requested softwares and their dependencies  
- Issue commands to properly configure the softwares installed  

> **Notes:**
>
> - The packages of these softwares are maintained by their respective repository owners. Any problem related to the softwares should be reported to the respective repository owners.

| Software | Description |
| :------- | :---- |
| Configure Distro | Installation of graphics drivers, codecs, and some commonly used softwares that I consider to be essential for the best user experience with openSUSE |
| <abbr title="Dynamic Kernel Module System">DKMS</abbr> | Used to compile kernel modules automatically for new installed kernels (used by NVIDIA, VirtualBox and others) |
| Fritzing | CAD software for prototyping eletronic projects |
| Google Chrome | Google's Closed-source Web Browser |
| GRUB2 | Linux GRUB2 Boot loader installer script (it does a re-installation of the boot loader back into the system) |
| LaTeX | A editing system that works by commands instead of graphical interfaces provided by software like LibreOffice and MS Office Word |
| SMPlayer | Video player (configured to avoid common memory leaks that it could cause) |
| Tuned | A daemon to tune the system dinamically as it is required |
| Unbound | One of the best and fastest DNS Caching Server available |
| Unison | Syncing software that allows you to sync in both directions REALLY fast |
| VirtualBox | Oracle's Hardware Virtualization Technology |
| VLC | Video player (configured to avoid common memory leaks that it could cause) |

Workarounds
-----------------

Linux is great, but as many OS's out there, it has it's own problems and performance issues. To solve those issues, scripts have been created to automate these fixes.

> **Note:**  
>
> - Although these scripts work well in a desktop on a daily-basis, most of them are **workarounds**. Therefore, they're far from being <i>perfect solutions</i>. They're provided AS-IS with NO WARRANTY whatsoever.

| Name | Description |
| ------- | ------ |
| Block Touchscreen | Disables touchscreen in laptops or similar devices |
| Bluetooth RFKILL Unlock | Enables bluetooth driver by unlocking the RFKILL functionality. Some motherboards have this issue, but it seems this problem has been fixed in Kernel >= 4 . |
| Mouse Fast Scroll - Microsoft | Fixes the fast scroll that happens with the Microsoft's driver for their Optical (Wire or Wireless) Mouses |
| [NVIDIA Optimus&trade;][optimus] | Install Bumblebee software to enable fast switch between Onboard and NVIDIA&trade; GPU's. Very used for Laptops to spare energy when the robust GPU is not needed. Before using this feature, please check if your card is supported [here](http://www.geforce.com/hardware/technology/optimus/supported-gpus). |
| Performance Tuning | Improve Linux general performance (CPU, Memory IO, Disk IO, Network, etc), by applying a bunch of different techniques and patches to critical system sections. Theses scripts work by changing the Modifying Power Management as the system power is changed (AC power connected in the Laptop, or Laptop running with a battery, or a Desktop that always runs with AC power), Kernel Sysctl Variables, Reduce Non-Real Time Daemons Priorities, Modifying modules options to increase responsivity and throughout.  |
| Suspend | Avoid suspension / hibernation problems related to either not being able to suspend / hibernate or not being able to wake up from these energy modes. **This is a common issue with systems that have at least one NVIDIA GPU.** |
| VPN Kernel Allow | Enables PPTP VPN functionality on Kernels >=3.4 during boot (it does some _modprobe's_ on boot time). |

<hr>

Tested Environment
-----------------

The scripts provided were tested in a x86_64 machine running openSUSE&trade; Leap 42.3 and the most recent kernel available within the default openSUSE&trade; repositories and kernel stable openSUSE&trade; repository.

Footnotes
------------------

<a id="opensuse">1</a>:  [openSUSE&trade;](https://www.opensuse.org/) is a Linux-based project and distribution sponsored by **SUSE Linux GmbH**&trade; and other companies. It is widely used throughout the world, particularly in Germany. The focus of its development is creating usable open-source tools for software developers and system administrators, while providing a user-friendly desktop, and feature-rich server environment. [↩](#opensuse_back)<br>
<a id="zypper">2</a>:  **ZYpp**&trade; (or **libzypp**&trade;) is a package management engine that powers Linux applications like **YaST&trade;, Zypper**&trade; and the **openSUSE/SUSE Linux Enterprise**&trade; implementation of PackageKit&trade;. Unlike other common package managers, it provides a powerful satisfiability solver to compute package dependencies and a convenient package management API. [↩](#zypper_back)<br>
<a id="rpm">3</a>:  **RPM Package Manager (RPM)**&trade; (originally **Red Hat Package Manager**&trade;; now a recursive acronym) is a package management system. The name **RPM**&trade; variously refers to the .rpm file format, files in this format, software packaged in such files, and the package manager itself. RPM&trade; was intended primarily for Linux distributions; the file format is the baseline package format of the Linux Standard Base. [↩](#rpm_back)<br>

[optimus]: http://www.nvidia.com/object/optimus_technology.html

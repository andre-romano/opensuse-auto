openSUSE-Auto
===================


This is a **GitHub** repository that stores scripts to automate **openSUSE**&trade;<sup id=opensuse_back>[1](#opensuse)</sup> Linux distribution in many ways. They allow installation and configuration of software, as well as solve common **openSUSE** &trade; (or Linux) issues.

Special Scripts
---------------

These scripts have each one of them a very specific and individual purpose that differ from the others. Please check them carefully below.

### Initial_Config - System Initial Configuration

These scripts are used to install all the required drivers, codecs and some frequently software inside your **openSUSE&trade;**. The best way to do this is to run the command from within this directory:

```Shell
cd 'Initial_Config'
sudo ./install_dist.sh
```

### Custom bash

This script installs a custom **.bashrc** file that provides some cool functionality to **ALL USERS prompts**. To use it run the code:

```Shell
cd 'Custom Bash'
sudo ./install.sh
```

### LUKS - Managing Cryptographic Files within Linux

These scripts are used to open, close and create LUKS files. To be able to use them, will need to run the command below to install them in your system:

```Shell
cd luks
sudo ./install.sh
```

 > **Note:**
 > After executing this command, you'll have 3 new scripts installed inside your system. You'll have 'lopen', 'lclose' and 'lcreate'. As you might imagine, they all do what their names imply. For more info, use the options --help with them.

### Open All in Tabs

This script allows you to open many URL's with one single command within bash. To use it you just need to type the following from within it's folder:

```
web-open.sh file
```

> **Note:**
> Where there is **file** replace with the file that has the URL's that you want to open. By default it will try to open them with the default web browser. Use the option **--help** to see what other functionality this script has.

> You may install this script inside your system using the command:
> ```Shell
> sudo install.sh
> ```
> When the script is installed, you don't need to use it with the .SH extension. Just type **web-open** and it will work.

--------

Installation / Configuration of New Software
---------------

These scripts allow the admin to rapidly install and/or configure (with minimal to no human intervention) any software that is listed here.

### openSUSE&trade; Scripts
These scripts need some openSUSE repositories to work properly. They will issue a sequence of commands to correctly add the required repositories, install the requested softwares and issue the required commands to properly configure them.

> **Notes:**
>
> - The vast majority of the scripts are contained inside this category for better maintainability/stability.
> - The updates of these softwares will be maintained by the repository owner. These updates will executed by  **openSUSE**&trade;. At least **zypper**&trade; <sup id=zypper_back>[2](#zypper)</sup> and **rpm**&trade;<sup id=rpm_back>[3](#rpm)</sup> softwares are going to be used.
> - Depending on your Graphical Desktop Interface (**GNOME**&trade;, **KDE**&trade;, or others) other software may be used to download and apply the required patches and updates released by the repository owner.

| Software | Description |
| :------- | :---- |
| <abbr title="Dynamic Kernel Module System">DKMS</abbr> | Used to compile and keep kernel modules within the kernel versions installed in the system |
| Fritzing | Electronic Design Automation software for OpenSource Hardware Schematic and PCB Design |
| Google Chrome | Google's Closed-source Web Browser |
| Initial_Config | Installation of graphics drivers, codecs, and some common use software that I consider to be essential for the best user experience with openSUSE |
| VirtualBox | Oracle's Hardware Virtualization Technology |
| Workrave | Avoid RSI (repetitive strain injury), that can result in hurting your spine, hands, etc |

### General Scripts
Some softwares don't have an **openSUSE**&trade; repository already setup. In order to install and keep these softwares updates, these scripts parse the required information from the software vendor's website. It then detects if the software is installed and needs an update, or if the software was not installed and needs to be installed.

> **Files in These Scripts**: <br>
> 1. **DESKTOP** file (to install the required links into the Graphical Desktop Interface) <i>**(some softwares might not have this file, the .RPM downloaded from their source website already does this for us)**</i><br>
> 2. **update.sh** bash script (keep the software updated, and if software is not present in the system, install it)<br>
> 3. **install.sh** bash script (to install the **DESKTOP** file, and also schedule the update file with **anacron** to run once per week)

| Software | Description |
| ------- | ------ |
| TeamViewer | A Remote Access software that can bypass NAT and port forwarding. It can even configure itself inside the system's default firewall. |
| <abbr title="Universal Media Server">UMS</abbr> | - uPnp Streaming to Multimedia devices in the same Network Subnet|

<hr>

Workarounds
-----------------

There are some other scripts that solve* some common problems that you might encounter when using Linux-based OS's.

> <b>*Note:</b>
>
> - Although these scripts work well and fix the issues, they're **workarounds**. Therefore, they're far from being <i>perfect solutions</i>.

| Name | Description |
| ------- | ------ |
| Mouse Fast Scroll - Microsoft | Fixes the fast scroll that happens with the Microsoft's driver for their Optical (Wire or Wireless) Mouses |
| [NVIDIA Optimus&trade;][optimus] | Install Bumblebee software to enable fast switch between Onboard and NVIDIA&trade; GPU's. Very used for Laptops to spare energy when the robust GPU is not needed. Before using this feature, please check if your card is supported [here](http://www.geforce.com/hardware/technology/optimus/supported-gpus). |
| Suspend | Avoid suspension/hibernation problems related to either no being able to suspend/hibernate or not being able to wake up from these energy modes. |

<hr>

Tested Environment
-----------------

The scripts provided were tested within a x86_64 machine running openSUSE&trade; Leap 42.2 and the most recent kernel available within the default openSUSE&trade; repositories

Footnotes
------------------

<a id="opensuse">1</a>:  [openSUSE&trade;](https://www.opensuse.org/) is a Linux-based project and distribution sponsored by **SUSE Linux GmbH**&trade; and other companies. It is widely used throughout the world, particularly in Germany. The focus of its development is creating usable open-source tools for software developers and system administrators, while providing a user-friendly desktop, and feature-rich server environment. [↩](#opensuse_back)<br>
<a id="zypper">2</a>:  **ZYpp**&trade; (or **libzypp**&trade;) is a package management engine that powers Linux applications like **YaST&trade;, Zypper**&trade; and the **openSUSE/SUSE Linux Enterprise**&trade; implementation of PackageKit&trade;. Unlike other common package managers, it provides a powerful satisfiability solver to compute package dependencies and a convenient package management API. [↩](#zypper_back)<br>
<a id="rpm">3</a>:  **RPM Package Manager (RPM)**&trade; (originally **Red Hat Package Manager**&trade;; now a recursive acronym) is a package management system. The name **RPM**&trade; variously refers to the .rpm file format, files in this format, software packaged in such files, and the package manager itself. RPM&trade; was intended primarily for Linux distributions; the file format is the baseline package format of the Linux Standard Base. [↩](#rpm_back)<br>

[optimus]: http://www.nvidia.com/object/optimus_technology.html

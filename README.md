Sync-Hub
========

By [@jerogee](https://github.com/jerogee) and [contributors](https://github.com/mail-in-a-box/mailinabox/graphs/contributors).

Sync-Hub helps to keep your files in sync and secure across devices, with an easy-to-deploy server in your control.

* * *

Sync-Hub offers:

* File synchronization across devices using a central server (a hub) in your control
* Full control over your data, full control over upload/download speed
* Encryption on devices and on hub, keeping your data safe even if the hub is compromised
* Relies on proven technology, such as [Unison](https://www.cis.upenn.edu/~bcpierce/unison/) for efficient data syncing and [gocryptfs](https://nuetzlich.net/gocryptfs/) (a successor of [EncFS](https://vgough.github.io/encfs/)) for state-of-the-art encryption.
* Incremental backup of encrypted data, with easy roll-back
* Support for Linux, Unix, and OSX devices, with a Windows port in development



The Hub
-------

Sync-Hub can be deployed in a one-click fashion on a fresh Debian or Ubuntu machine by installing and configuring various components that all focus on doing one job well: supporting sync across devices whilst keeping the data safe and secure.


Installation
------------

For experts, start with a completely fresh Debian Stable or Ubuntu LTS 64-bit machine. On the machine...

Clone this repository:

	$ git clone https://github.com/jerogee/sync-hub
	$ cd sync-hub

_Optional:_ Download my PGP key and then verify that the sources were signed
by me:

	INSTRUCTIONS HERE

Begin the installation.

	$ sudo setup/start.sh



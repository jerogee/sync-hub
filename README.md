sync-hub
========

Sync-hub helps to keep your files securely in sync across devices, with an easy-to-deploy server in your control.


This software is in **pre-alpha**. Please wait using it until it reached at least beta.

* * *

Sync-hub offers:

* File synchronization across devices using a central server (a hub) in your full control.
* Encryption on client-side, end-to-end, keeping your data safe even if the hub is compromised.
* Relies on proven technology, such as [Unison](https://www.cis.upenn.edu/~bcpierce/unison/) for efficient data syncing and [gocryptfs](https://nuetzlich.net/gocryptfs/) (a successor of [EncFS](https://vgough.github.io/encfs/)) for state-of-the-art encryption.
* Incremental backup of encrypted data, with easy roll-back.


The Hub
-------

Sync-hub can be deployed in a one-click fashion on a fresh Ubuntu machine or VPS from any provider by installing and configuring various components that all focus on doing one job well: supporting sync across devices whilst keeping the data safe and secure.


Security
--------

Many cloud storage providers claim to protect user files with encryption, but do that on their servers. As the providers have the encryption keys, they can (and so can hackers) decrypt data if they want to or are legally forced to.

The only way to ensure your data cannot be peeked at is to use so called [end-to-end encryption](https://en.wikipedia.org/wiki/End-to-end_encryption), so to encrypt BEFORE it leaves your device, with only you being in posession of the encryption keys.

Even the few providers that claim to use end-to-end encryption, or rely on peer-to-peer technology that promises communication between devices directly, require closed-source client software to be installed which could just as well provide backdoor access or simply submit local encryption keys elsewhere.

General security features of Sync-Hub:
* Files are encrypted on the device (end-to-end encryption), exclusively using open source based software;
* Only encrypted data is synced to and from the Hub. If the Hub gets compromised, data are safe;
* Sync-hub also stores files on your device in an encrypted state, by using the [cryptographic file system](https://en.wikipedia.org/wiki/Filesystem-level_encryption) [gocryptfs](https://nuetzlich.net/gocryptfs/), which encrypts files individually using chunked AES-GCM ([Galois Counter Mode](https://en.wikipedia.org/wiki/Galois/Counter_Mode)) and encrypts filenames with AES-EME ([ECB-Mix-ECB](https://eprint.iacr.org/2003/147.pdf)). If someone gains access to the content of your home directory without being able to mount the cryptographic file system, data are safe;
* Syncing happens over [SSH](https://en.wikipedia.org/wiki/Secure_Shell), which provides a secure channel over an unsecured network to transfer data, using [Unison](https://www.cis.upenn.edu/~bcpierce/unison/).

Security settings of the Hub:
* SSH Key-Based Authentication (instead of password-based);
* Automatic (unattended) security updates;
* Generic firewall ([UFW](https://help.ubuntu.com/community/UFW);
* Protection against agressive login attempts ([Fail2Ban](https://github.com/fail2ban/fail2ban).


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


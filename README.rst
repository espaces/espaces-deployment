[hostname] configuration
========================

Todo
----

* Remove ``roots`` symlink once the ``file_roots`` relativity
  issue is fixed: https://github.com/saltstack/salt/issues/14613

Features
--------

Installation
------------

Provision like so::

   salt-ssh hostname state.highstate

Requirements
------------

* Your *master* (the computer running Salt) must have root-level SSH access to
  the given host via key-based authentication.
* This configuration requires the latest Salt 2014.7 (Helium) commit to be run
  correctly.  This release features various fixes to ``salt-ssh``, which is
  used to deploy the configuration to the server.  At the time of writing,
  this needs to be manually installed from Salt's git repository.
* If your host is Debian/Ubuntu, you must have ``certifi`` installed::

     sudo easy_install certifi

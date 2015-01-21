[hostname] configuration
========================

Features
--------

* Add your features here.

Provisioning targets
--------------------

Provision your targets like so::

   salt-ssh [hostname] state.highstate

Identifiers for this command come from the Salt roster file (``salt/roster``).

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

Todo
----

* Remove ``roots`` symlink once the ``file_roots`` relativity
  issue is fixed: https://github.com/saltstack/salt/issues/14613

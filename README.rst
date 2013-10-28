Installation
============

Development
-----------

.. code:: bash

    git clone --recursive https://github.com/espaces/espaces-deployment.git
    vagrant plugin install vagrant-vbguest
    vagrant plugin install vagrant-salt
    vagrant up

Production
----------

.. code:: bash

    ssh production.example.org
    wget -O - http://bootstrap.saltstack.org | sudo sh
    git clone --recursive https://github.com/espaces/espaces-deployment.git
    ln ...
    salt-call --local state.highstate

States
======

* Web server (Nginx)

  * Install
  * Configuration
  * Firewall
  * Services running

* Filesystem mounting (for NeCTAR production only)
 
  * Check presence of volume device
  * Create partition table, main partition, and format
  * Mount and configure to mount on boot

* Platform installation (Plone)

  * Git clone repository to system
  * Bootstrap environment
  * Configure buildout for specific environment ``-c production.cfg``
  * Run Buildout
  * Install supervisord as system service
  * Ensure service starts on boot
  * Start supervisord (thus Plone)

Todo
====

* How to easily switch from development to production (Pillar?)
* Using salt-ssh with a non-Salt bootstrapped host - possible?
* Install instructions
* Vagrant file for development
* Salt host configuration

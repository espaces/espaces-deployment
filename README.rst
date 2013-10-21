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

* Filesystem mounting (NeCTAR production only)

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

* Install instructions
* Vagrant file for development
* Salt host configuration
* SSL certificate and storage somewhere that can be pulled in via Salt

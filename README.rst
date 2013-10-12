Installation
============

Development
-----------

.. code:: bash

    vagrant plugin install salty-vagrant
    vagrant up

Production
----------

.. code:: bash

    ssh production.example.org
    wget -O - http://bootstrap.saltstack.org | sudo sh
    ln ...
    salt-call --local state.highstate

States
======

* Web server
  * Install
  * Configuration
  * Firewall
  * Services running
* Filesystem mounting (production only)
* Plone installation
  * Git clone to system
  * Bootstrap environment
  * Configure buildout for specific environment ``-c production.cfg``
  * Run Buildout
  * Put supervisord as system service
  * Start supervisord (thus Plone)

Todo
====

* Install instructions
* Vagrant file for development
* Salt host configuration
* SSL certificate and storage somewhere that can be pulled in via Salt

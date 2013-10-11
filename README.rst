Installation
============

Development
-----------

::
    vagrant plugin install salty-vagrant
    vagrant up

Production
----------

::
    ssh production.example.org
    wget -O - http://bootstrap.saltstack.org | sudo sh
    ln ...
    salt-call --local state.highstate

Todo
====

* Install instructions
* Vagrant file for development
* Salt host configuration
* SSL certificate and storage somewhere that can be pulled in via Salt

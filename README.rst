Installation
============

Initial SSL configuration
-------------------------

To run this configuration with preconfigured SSL certificates, you must at
least provide a relevant SSL certificate for use with the web server.  For
development, you may wish to use a self-signed certificate.  However, for
production, you must have a minimum of an SSL certificate and key provided by a
suitable Certificate Authority (CA).  You should also think about providing a
pre-computed keypair for the Shibboleth service.  

In any case, to introduce these elements to Salt, then prior to running
it, create a private pillar area with relevant files inside
``salt/roots/pillar/private``::

    webserver-ssl.crt
    webserver-ssl.key
    shibboleth-sp-cert.pem  
    shibboleth-sp-key.pem

The ``webserver-ssl.crt`` file should be a complete, chained SSL file suitable
for consumption by Nginx.

Development
-----------

.. code:: bash

    git clone --recursive https://github.com/espaces/espaces-deployment.git
    vagrant plugin install vagrant-vbguest
    vagrant plugin install vagrant-salt
    vagrant up

The above provisioning will generate self-signed certificates for SSL web
services and for Shibboleth. You can override this behaviour by placing

Production
----------

.. code:: bash

    ssh production.example.org
    wget -O - http://bootstrap.saltstack.org | sudo sh
    git clone --recursive https://github.com/espaces/espaces-deployment.git
    rm -rf /etc/salt/minion
    ln -s salt/minion /etc/salt/minion
    ln -s salt/roots/pillar /srv/pillar
    ln -s salt/roots/salt /srv/salt

    #Introduce your private files into /srv/pillar/private here

    salt-call --local state.highstate

Features
========

Inclusions
----------

* Vagrantfile and integration with salty-vagrant for development

States
------

* Web server (Nginx)

  * Install
  * Configuration
  * Firewall
  * Services running

* Filesystem mounting (for NeCTAR production only)
 
  * Check presence of volume device
  * Create partition table, main partition, and format
  * Mount and configure to mount on boot

* Shibboleth and AAF configuration

  * Install
  * Configuration of Shibboleth for AAF
  * Configuration of FastCGI applications
  * Services running 

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
* Salt host configuration

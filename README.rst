Todo
====

* Custom VM snapshot/instance for cleanly basing this off. (Duplicate existing?)


Installation
============


Preconfiguration
----------------

Initial SSL configuration
^^^^^^^^^^^^^^^^^^^^^^^^^

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

Enrolment in AAF
^^^^^^^^^^^^^^^^

This deployment utilises the Australian Access Federation for authentication
with Shibboleth.  To enrol your application, see 
https://manager.aaf.edu.au/federationregistry/.  Once you have enrolled,
then configure the Pillar data accordingly with hostname, entity ID and
the like such that Shibboleth is configured correctly on running the
highstate.

Since eSpaces uses Plone/Zope under the hood, authentication is
flexible and AAF isn't specifically necessary and can be changed out as
required. On a separate note, the default install also allows login
via a local username and password for non-AAF users.

Development
-----------

.. code:: bash

    git clone --recursive https://github.com/espaces/espaces-deployment.git
    vagrant up development

The above provisioning will generate self-signed certificates for SSL web
services and for Shibboleth. You can override this behaviour by placing certificate
configuration within the relevant pillar area.

Production
----------

.. code:: bash

    vagrant plugin install vagrant-openstack-plugin
    source .env; vagrant up production --provider=openstack

This will deploy onto NeCTAR (QCloud) infrastructure via OpenStack provisioning.
This requires various environment variables to be present, as follows:

.. code:: bash

export OS_AUTH_URL=https://keystone.rc.nectar.org.au:5000/v2.0/
export OS_TENANT_ID=1234567890abcdef0123456789
export OS_TENANT_NAME="QCIF_eSpaces"
export OS_USERNAME=user@example.org

export OS_PASSWORD='secret'
export OS_KEYPAIR_NAME='keypair-dev'

You can utilise the *OpenStack RC File* download to set the first set of options
for you.  The latter set of options are specific to this configuration. 

For convenience, you might place all of the above into a ``.env`` file and
``source .env`` prior to use.  You could even go further and use something like
`Autoenv <https://github.com/kennethreitz/autoenv>`_ to automate this process.


Old instructions
----------------

.. code :: bash

    vagrant plugin install vagrant-vbguest
    vagrant plugin install vagrant-salt

.. code :: bash

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

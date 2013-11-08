About
=====

This Vagrant/Salt set of configuration allows the deployment of fully
functional eSpaces (like https://espaces.edu.au) stack.  The resulting
configured VM will have Plone (with eSpaces customisations), Nginx
(with Shibboleth customisations and SSL configured), and Shibboleth 
(configured appropriately) all set up and wired together.  The only
manual steps necessary are the items mentioned under `Preconfiguration`_.

Features
========

Key features
------------

* Vagrantfile and integration with built-in Salt provisioner for development
* Vagrantfile integration with OpenStack provisioning for NeCTAR production
  deployment.
* Easily deploy a development machine via VirtualBox and a production
  machine to NeCTAR/OpenStack using the same configuration to produce
  the same results.

States
------

* Web server (Nginx)

  * Install
  * Configuration
  * SSL installation
  * Firewall rules
  * Services running

* Filesystem mounting (optional; for NeCTAR production only)
 
  * Check presence of volume device
  * Create partition table, main partition, and format
  * Mount and configure to mount on boot

* Shibboleth and AAF configuration

  * Install services
  * Configuration of Shibboleth for AAF (metadata, URLs, etc)
  * Configuration of FastCGI applications
  * Configuration of Nginx to talk to Shibboleth FastCGI
  * Services running 

* Platform installation (Plone)

  * Git clone repository to system
  * Bootstrap environment
  * Configure buildout for specific environment ``-c production.cfg``
  * Run Buildout
  * Install supervisord as system service
  * Start supervisord (thus Plone)
  * Ensure service starts on boot
  

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

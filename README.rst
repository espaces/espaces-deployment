eSpaces configuration
=====================

This Vagrant/Salt set of configuration allows the deployment of fully
functional eSpaces (like https://espaces.edu.au) stack.  The resulting
configured VM will have Plone (with eSpaces customisations), Nginx
(with Shibboleth customisations and SSL configured), and Shibboleth 
(configured appropriately) all set up and wired together.  The only
manual steps necessary are the items mentioned under `Preconfiguration`_.

Features
--------

* Vagrantfile and integration with built-in Salt provisioner for development
* Vagrantfile integration with OpenStack provisioning for NeCTAR production
  deployment.
* Easily deploy a development machine via VirtualBox and a production
  machine to NeCTAR/OpenStack using the same configuration to produce
  the same results.

States
~~~~~~

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

Provisioning targets
--------------------

See `Installation`_ first before proceeding.

Provision your targets like so::

   git clone --recursive https://github.com/espaces/espaces-deployment.git
   salt-ssh espaces state.apply
   salt-ssh espaces-dev state.apply

Identifiers for this command come from the Salt roster file (``salt/roster``).

Alternatively, you can test locally using Vagrant to provision a local VM and
provision that using Salt's masterless provisioning::

   vagrant up

The above provisioning will generate self-signed certificates for SSL web
services and for Shibboleth. You can override this behaviour by placing certificate
configuration within the relevant pillar area.

Once the development machine is running, re-provision via Vagrant with::

   vagrant provision # on host machine

or directly with Salt on the Vagrant VM by::

   vagrant ssh
   salt-call --local state.apply

By running Vagrant in this directory, the ``Vagrantfile`` is picked up
automatically for all the above commands.

Requirements
------------

* Vagrant 1.4+ and Salt 2015.5+
* Your *master* (the computer running Salt) must have root-level SSH access to
  the given host via key-based authentication.
* If your host is Debian/Ubuntu, you must have ``certifi`` installed::

     sudo easy_install certifi

Todo
----

* Remove ``roots`` symlink once the ``file_roots`` relativity
  issue is fixed: https://github.com/saltstack/salt/issues/14613


Installation preconfiguration
-----------------------------

SSL configuration
~~~~~~~~~~~~~~~~~

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

Enrolment in Shibboleth federations
~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

This deployment utilises Shibboleth federations for authentication with
research institutions.  eSpaces currently works with the Australian Access
Federation (AAF) and Tuakiri New Zealand Access Federation.  To enrol your
application, see https://manager.aaf.edu.au/federationregistry/ and
https://registry.tuakiri.ac.nz/.  Once you have enrolled, then configure the
Pillar data accordingly with hostname, entity ID and the like such that
Shibboleth is configured correctly on applying the highstate.

Since eSpaces uses Plone/Zope under the hood, authentication is flexible and
federated login isn't specifically necessary and can be changed out as
required. Similarly, the default install also allows login via a
local username and password for non-federated users.


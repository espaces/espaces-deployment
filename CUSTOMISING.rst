How to customise this Salt config for your machine
==================================================

This configuration is designed to be a template for future machine
provisioning, so content is laid out and written from that perspective.  The
general idea is that you'll customise the config and the documentation for
your specific VM or machine provisoning.

#. Create a new branch of this configuration in the ``app-configuration``
   repository, if private, or create a new repository if public.  The
   information contained here isn't strictly private, but downstream Salt
   configurations can be.

#. Edit the ``README.rst`` and replace ``[hostname]`` references to be your
   own machines.  Describe your project and include the features that your
   Salt configuration provides.

#. If using Vagrant, customise the private network IP address in the
   ``Vagrantfile``.

#. Edit the Salt roster file ``salt/roster`` to point to your machines. You
   will need to adjust the configuration according to how you SSH into your
   targets.  Consult
   http://docs.saltstack.com/en/latest/topics/ssh/roster.html for full
   details.

#. Customise the host ID ``[hostname]`` in ``salt/minion_production`` and
   ``salt/minion_development``.  These are effectively arbitrary unless you're
   configuring a multi-host provisioning environment.

#. States: configure your `Salt States
   <http://docs.saltstack.com/en/latest/topics/tutorials/starting_states.html>`_
   according to how you need your machines provisioned and state data is always
   placed into ``salt/roots/salt/``. The top-level state is ``top.sls`` in
   this directory and tells Salt how to match your machine ID to state
   configuration.

#. Pillars: configure your `Salt Pillars
   <http://docs.saltstack.com/en/latest/topics/tutorials/pillar.html>`_ within
   ``salt/roots/pillar``.  The top-level pillar configuration is ``top.sls``
   and tells Salt how to match your machine ID to Pillar data.

#. If adding `Formulas
   <http://docs.saltstack.com/en/latest/topics/development/conventions/formulas.html>`
   (pre-written states) see ``salt/roots/formulas/README.rst`` for details.
   If using a third-party Formula, take a close look over the code and
   consider pinning to a specific commit or fork the code to ensure you don't
   introduce arbitrary changes later.

#. Use the existing JCU eResearch `Shared-Salt-States
   <https://github.com/jcu-eresearch/shared-salt-states>`_ to configure your
   machine -- and add to it if you're doing anything generic such as setting
   up packages, configuring generic applications and so forth.

#. Once all of the above are done, commit your files to your new branch or
   repo and provision your machines.  Make sure you test first, Vagrant is
   your friend!


Note
----

* The ``roots`` symlink at the top-level of this directory is a shortcut that
  solves a bug in Salt. Do not delete it.
* This configuration has been initially designed as a single-machine
  provisioner.  It is possible to provision multiple machines with Salt,
  though in order to do this effectively, some assumptions in this base
  configuration will need refinement.

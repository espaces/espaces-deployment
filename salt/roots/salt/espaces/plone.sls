include:
   - jcu.development_tools
   - jcu.python
   - jcu.repositories.eresearch

Plone requirements:
   pkg.installed:
      - pkgs:
      {% if grains['os_family'] == 'RedHat' %}
         - db4-devel
         - freetype-devel
         - glibc-devel
         - libjpeg-turbo-devel
         - libxslt
         - ncurses-devel
         - openssl-devel
         - zlib-devel
      {% elif grains['os_family'] == 'Debian' %}
         - build-essential
         - git
         - zlib1g-dev
         - libsasl2-dev
         - libssl-dev
         - libjpeg-dev
         - libfreetype6-dev
         - subversion
         - patch
      {% endif %}
         - poppler-utils
         - lynx
         - xlhtml
         - xpdf
         - wv
      - require:
      {% if grains['os_family'] == 'RedHat' %}
         - sls: jcu.development_tools
      {% endif %}
         - sls: jcu.python.python_2_7

{% set plone_path = '/opt/espaces-platform' %}

# Create a specific user to run the service
Plone user:
   user.present:
      - name: plone
      - gid_from_name: true
      - createhome: true
      - shell: /bin/bash

# Create directory in /opt with correct user and clone from VCS
eSpaces configuration:
   file.directory:
      - name: {{ plone_path }} 
      - user: plone
      - group: plone
      - dir_mode: 755
   git.latest:
      - name: https://github.com/espaces/espaces-platform.git
      - target: {{ plone_path }}
      - user: plone
      - require:
         - user: Plone user
         - file: eSpaces configuration 
         - pkg: Plone requirements

# Bootstrap the Buildout environment
eSpaces bootstrap:
   cmd.wait:
      - cwd: {{ plone_path }}
      - name: python2.7 bootstrap.py
      - user: plone
      - group: plone
      - unless: test -x {{ plone_path }}/bin/buildout
      - watch:
         - git: eSpaces configuration 

# Run buildout 
eSpaces buildout:
   cmd.wait:
      - cwd: {{ plone_path }}
      - name: ./bin/buildout
      - user: plone
      - group: plone
      - require:
         - cmd: eSpaces bootstrap 
      - watch:
         - git: eSpaces configuration

# Service installation for supervisord
eSpaces service:
   file.symlink:
      - name: /etc/supervisord.d/espaces.ini
      - target: {{ plone_path }}/parts/supervisor/supervisord.conf
      - require:
         - pkg: supervisor
      - watch:
         - cmd: eSpaces buildout
      - watch_in:
         - service: supervisord

# Confirm that the Plone service is actually running
eSpaces supervisord:
   supervisord.running:
      - name: instance1
      - watch:
         - service: supervisord

# Firewall configuration
eSpaces iptables:
   module.run:
      - name: iptables.insert
      - table: filter
      - chain: INPUT
      - position: 3
      - rule: -p tcp --dport 80 -j ACCEPT

# To refactor into own file
supervisor:
  pkg.installed:
     - require:
        - pkgrepo: JCU package repository 

supervisord:
  service:
     - running
     - enable: True
     - require:
        - pkg: supervisor

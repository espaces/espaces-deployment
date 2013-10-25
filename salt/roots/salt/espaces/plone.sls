include:
   - jcu.development_tools
   - jcu.python
   - jcu.repositories.eresearch
   - jcu.supervisord
   - jcu.shibboleth.fastcgi
   - jcu.nginx.custom

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
      - name: {{ pillar['paths']['plone'] }} 
      - user: plone
      - group: plone
      - dir_mode: 755
   git.latest:
      - name: https://github.com/espaces/espaces-platform.git
      - target: {{ pillar['paths']['plone'] }}
      - user: plone
      - require:
         - user: Plone user
         - file: eSpaces configuration 
         - pkg: Plone requirements
      - onlyif: echo ''

# Bootstrap the Buildout environment
eSpaces bootstrap:
   cmd.wait:
      - cwd: {{ pillar['paths']['plone'] }}
      - name: python2.7 bootstrap.py
      - user: plone
      - group: plone
      - unless: test -x {{ pillar['paths']['plone'] }}/bin/buildout
      - watch:
         - git: eSpaces configuration 

# Run buildout 
eSpaces buildout:
   cmd.wait:
      - cwd: {{ pillar['paths']['plone'] }}
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
      - target: {{ pillar['paths']['plone'] }}/parts/supervisor/supervisord.conf
      - require:
         - host: mail.espaces.edu.au
      - watch:
         - cmd: eSpaces buildout
      - watch_in:
         - service: supervisord

# Confirm that the Plone service is actually running
eSpaces supervisord:
   supervisord.running:
      - name: instance1
      - update: true
      - watch:
         - service: supervisord

#Other supporting settings
mail.espaces.edu.au:
   host.present:
      - ip: {{ pillar['hosts']['mail'] }}

# Configure web front end
espaces web configuration:
   file.managed:
       - name: /etc/nginx/conf.d/espaces.conf
       - source: salt://espaces/nginx.conf
       - user: root
       - group: root
       - mode: 644
       - watch_in:
           - service: nginx

espaces ssl certificate:
   file.managed:
       - name: /etc/nginx/ssl/star.espaces.edu.au.chained.crt
       - makedirs: true
       - user: root
       - group: root
       - mode: 400
       - contents_pillar: 'nginx:certificate'
       - require: 
            - pkg: nginx
       - watch_in:
           - service: nginx

espaces ssl key:
   file.managed:
       - name: /etc/nginx/ssl/star.espaces.edu.au.key
       - makedirs: true
       - user: root
       - group: root
       - mode: 400
       - contents_pillar: 'nginx:key'
       - require: 
            - pkg: nginx
       - watch_in:
           - service: nginx

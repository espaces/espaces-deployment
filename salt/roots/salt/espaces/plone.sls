{% set path = pillar['paths']['plone'] %}
{% set user = 'plone' %}
{% set group = 'plone' %}

include:
  - jcu
  - jcu.git
  - jcu.development_tools
  - jcu.python.virtualenv
  - jcu.python.python_2_7
  - jcu.shibboleth.fastcgi
  - jcu.nginx
  - jcu.supervisord

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
{{ user }} user:
  user.present:
    - name: {{ user }}
    - gid_from_name: true
    - createhome: true
    - shell: /bin/bash

# Create directory in /opt with correct user and clone from VCS
eSpaces setup:
  file.directory:
    - name: {{ path }}
    - user: {{ user }}
    - group: {{ group }}
    - dir_mode: 755
  git.latest:
    - name: https://github.com/espaces/espaces-platform.git
    - target: {{ path }}
    - user: {{ user }}
    - require:
      - user: {{ user }} user
      - file: eSpaces setup
      - pkg: Plone requirements
  virtualenv.managed:
    - name: {{ path }}
    - cwd: {{ path }}
    - user: {{ user }}
    - python: python2.7
    - unless: test -x {{ path }}/bin/python
    - require:
      - pkg: virtualenv
      - git: eSpaces setup
  cmd.run:
    - cwd: {{ path }}
    # Force pip to upgrade to avoid zc.buildout install problems
    - name: ./bin/pip install -U pip && ./bin/pip install setuptools==26.1.1 zc.buildout==1.7.1
    - runas: {{ user }}
    - unless: test -x {{ path }}/bin/buildout
    - require:
      - virtualenv: eSpaces setup

# Run buildout
eSpaces buildout:
  cmd.wait:
    - cwd: {{ path }}
    - name: ./bin/buildout -N -c production.cfg
    - runas: {{ user }}
    - require:
      - cmd: eSpaces setup
    - onchanges:
      - git: eSpaces setup

# Service installation for supervisord
eSpaces service:
  file.symlink:
    - name: /etc/supervisord.d/espaces.ini
    - target: {{ path }}/parts/supervisor/supervisord.conf
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
    - restart: true
    - update: true
    - watch:
      - file: eSpaces service
      - cmd: eSpaces buildout
      - service: supervisord

#Other supporting settings
mail.espaces.edu.au:
  host.present:
    - ip: {{ pillar['hosts']['mail'] }}

# Configure web front end
espaces error resources:
  file.recurse:
    - name: /usr/share/nginx/html/errors
    - source: salt://espaces/errors
    - user: nginx
    - group: nginx
    - require:
      - file: nginx error resources

espaces web configuration:
  file.managed:
    - name: /etc/nginx/conf.d/espaces.conf
    - source: salt://espaces/espaces.conf
    - user: root
    - group: root
    - mode: 644
    - require:
      - file: Shibboleth nginx config
      - file: nginx error resources
    - watch_in:
      - service: nginx

espaces ssl certificate:
  file.managed:
    - name: /etc/nginx/ssl/star.espaces.edu.au.crt
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

include:
   - jcu.repositories.eresearch

Shibboleth package repository:
   file.managed:
      - name: /etc/yum.repos.d/security:shibboleth.repo
      - source: http://download.opensuse.org/repositories/security://shibboleth/RHEL_6/security:shibboleth.repo
      - source_hash: sha256=4279b0d9725d94f5ceeb9b4f10f4e9e7c0c306752605b154adaff5343b3236ab
      - user: root
      - group: root
      - mode: 644

nginx:
   pkg:
      - installed
      - require:
          - pkgrepo: JCU package repository 
   service:
      - running
      - enable: True
      - reload: True
      - watch:
          - pkg: nginx
          - file: nginx configuration
          - pkg: shibboleth

nginx configuration:
   file.managed:
       - name: /etc/nginx/conf.d/espaces.conf
       - source: salt://espaces/nginx.conf
       - user: root
       - group: root
       - mode: 644
       - require:
           - pkg: nginx

shibboleth:
   pkg:
      - installed
      - require:
          - pkgrepo: JCU package repository 
          - file: Shibboleth package repository 

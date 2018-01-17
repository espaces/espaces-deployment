include:
  - jcu.repositories.eresearch

veeam backup scripts:
  file.recurse:
    - name: /opt/backup-scripts
    - source: salt://espaces/backup-scripts
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

{% if grains['os_family'] == 'RedHat' %}
veeam-release-el{{ grains['osmajorrelease'] }}:
  pkg.installed:
    - require:
      - pkgrepo: jcu-eresearch
      - file: veeam backup scripts
{% endif %}

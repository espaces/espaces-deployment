include:
  - jcu.backups

veeam backup scripts:
  file.recurse:
    - name: /opt/backup-scripts
    - source: salt://espaces/backup-scripts
    - user: root
    - group: root
    - dir_mode: 755
    - file_mode: 755

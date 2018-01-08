Base packages:
  pkg.installed:
    - pkgs:
      - vim-enhanced

{% set hostname = 'espaces.edu.au' %}
espaces hostname:
  cmd.run:
    {% if grains["init"] == "systemd" %}
    - name: hostnamectl set-hostname {{ hostname }}
    {% else %}
    - name: hostname {{ hostname }}
    {% endif %}
    - unless: test "{{ hostname }}" = "$(hostname)"

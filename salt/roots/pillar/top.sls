base:
   '*':
      - base
      {% if 'development' in grains['roles'] %}
      - development
      {% endif %}
      {% if 'production' in grains['roles'] %}
      - production
      {% endif %}

base:
   '*':
      - base
      {% if grains['id'].endswith('dev') %}
      - development
      {% else %}
      - production
      {% endif %}

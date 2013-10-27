shibboleth:
   host: sp.espaces.edu.au 
   entityID: https://sp.espaces.edu.au/shibboleth
   REMOTE_USER: auEduPersonSharedToken eppn persistent-id targeted-id
   supportContact: noreply@espaces.edu.au
   paths:
      '/':
        requireSession: 'true'
paths:
    plone: /opt/espaces-platform

{% import 'private/star.espaces.edu.au.chained.crt' as ssl_cert %}
{% import 'private/star.espaces.edu.au.key' as ssl_key %}
nginx:
   certificate: |-
      {{ ssl_cert|string|indent(6) }}
   key: |-
      {{ ssl_key|string|indent(6) }} 

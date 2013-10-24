{% import 'shibboleth-sp-cert.pem' as cert %}
{% import 'shibboleth-sp-key.pem' as key %}
shibboleth:
   host: sp.espaces.edu.au 
   entityid: https://sp.espaces.edu.au/shibboleth
   certificate: |-
      {{ cert|string|indent(6) }}
   key: |-
      {{ key|string|indent(6) }} 

hosts:
    #smtp.uq.edu.au
    mail: '130.102.132.85'

{% import 'shibboleth-sp-cert.pem' as shibboleth_cert %}
{% import 'shibboleth-sp-key.pem' as shibboleth_key %}
shibboleth:
   host: sp.espaces.edu.au 
   entityid: https://sp.espaces.edu.au/shibboleth
   certificate: |-
      {{ shibboleth_cert|string|indent(6) }}
   key: |-
      {{ shibboleth_key|string|indent(6) }} 


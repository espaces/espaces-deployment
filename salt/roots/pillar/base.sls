{% set is_production = 'production' in grains['roles'] %}
{% set is_development = 'development' in grains['roles'] %}

paths:
    plone: /opt/espaces-platform

volumes:
    {% if is_development %}
    /dev/sdb:
        mount: /opt/ 
        fstype: ext4
        opts: defaults,noatime,nodiratime,errors=remount-ro
        mkmnt: true
    {% endif %}
    {% if is_production %}
    /dev/vdc:
        mount: /opt/ 
        fstype: ext4
        opts: defaults,noatime,nodiratime,errors=remount-ro
        mkmnt: true
    {% endif %}

hosts:
    {% if is_development %}
    #hostrelay.jcu.edu.au
    mail: '137.219.16.198'
    {% endif %}

    {% if is_production %}
    #smtp.uq.edu.au
    mail: '130.102.132.85'
    {% endif %}

nginx:
   {% import 'private/webserver-ssl.crt' as ssl_cert %}
   {% import 'private/webserver-ssl.key' as ssl_key %}
   certificate: |-
      {{ ssl_cert|string|indent(6) }}
   key: |-
      {{ ssl_key|string|indent(6) }} 
   service-name: eSpaces
   contact-email: eresearch@jcu.edu.au

shibboleth:
   host: sp.espaces.edu.au 
   entityID: https://sp.espaces.edu.au/shibboleth
   discoveryURL: https://espaces.edu.au/login
   REMOTE_USER: auEduPersonSharedToken eppn persistent-id targeted-id
   supportContact: noreply@espaces.edu.au
   hosts:
      espaces.edu.au:
         paths:
            '/':
               requireSession: 'false'
      www.espaces.edu.au:
         paths:
            '/':
               requireSession: 'false'
   {% if is_development %}
   providers:
     - aaf-test
     - tuakiri-test
   {% else %}
   providers:
     - aaf
     - tuakiri
   {% import 'private/shibboleth-sp-cert.pem' as shibboleth_cert %}
   {% import 'private/shibboleth-sp-key.pem' as shibboleth_key %}
   certificate: |-
      {{ shibboleth_cert|string|indent(6) }}
   key: |-
      {{ shibboleth_key|string|indent(6) }} 
   {% endif %}

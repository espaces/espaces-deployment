# -*- mode: ruby -*-
# vi: set ft=ruby :
#

unless Vagrant.has_plugin?("vagrant-openstack-plugin")
    raise 'You must install vagrant-openstack-plugin to continue.'
end

Vagrant.configure("2") do |config|

  config.vm.define :development do |development|

      development.vm.box     = "centos-64-x64-vbox4210"
      development.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"
      development.vm.network :forwarded_port, guest: 8080, host: 9090
      development.vm.network :public_network

      development.vm.provision :salt do |salt|
        salt.minion_config = "salt/minion_develop"
        salt.run_highstate = true
        salt.verbose = true
        salt.install_type = "git"
        salt.install_args = "v0.17.5"
        salt.always_install = true 
      end

      development.vm.synced_folder "salt/roots/", "/srv/"
      development.vm.provider :virtualbox do |vb|
         vb.memory = 2048
         vb.customize ["modifyvm", :id, "--cpus", "4"]
      end

  end

  config.vm.define :production do |production|

      production.vm.box = "dummy"
      production.vm.box_url = "https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box"

      production.ssh.private_key_path = ["~/.ssh/#{ENV['OS_KEYPAIR_NAME']}.pem"]

      #For OpenStack
      production.vm.provider :openstack do |openstack|

          openstack.endpoint = "#{ENV['OS_AUTH_URL']}/tokens"
          openstack.tenant = "#{ENV['OS_TENANT_NAME']}"
          openstack.username = "#{ENV['OS_USERNAME']}"
          openstack.api_key = "#{ENV['OS_PASSWORD']}"
          openstack.keypair_name = "#{ENV['OS_KEYPAIR_NAME']}"

          openstack.flavor = /m1.medium/
          # Public snapshot 'eSpaces_Base' (which is 'NeCTAR CentOS 6.4 x86_64' + rsync)
          openstack.image = "0debdc10-1eeb-4239-8177-3e756c2758c9" 
          openstack.ssh_username = "ec2-user"

          openstack.security_groups = ['default', 'Web']
          openstack.availability_zone = "qld"
      end

      #For Amazon Web Services
      production.vm.provider :aws do |aws, override|

          aws.access_key_id = "#{ENV['AWS_ACCESS_KEY_ID']}"
          aws.secret_access_key = "#{ENV['AWS_SECRET_ACCESS_KEY']}"
          aws.keypair_name = "#{ENV['AWS_KEYPAIR_NAME']}"

          aws.instance_type = /m1.medium/
          aws.ami = "#{ENV['AWS_AMI']}"
          override.ssh.username = "ec2-user"

          aws.security_groups = ['default', 'Web']
          aws.region = "#{ENV['AWS_REGION']}"
      end

      production.vm.synced_folder "salt/roots/", "/srv/"
      production.vm.provision :salt do |salt|
        salt.minion_config = "salt/minion_production"
        salt.run_highstate = true
        salt.verbose = true
        salt.install_type = "git"
        salt.install_args = "v0.17.5"
        salt.always_install = true 
      end

  end

end

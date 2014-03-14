# -*- mode: ruby -*-
# vi: set ft=ruby :
#
plugins = ["vagrant-openstack-plugin",
           "vagrant-aws"]

plugins.each { |plugin|
  unless Vagrant.has_plugin?(plugin)
    raise 'You must install ' + plugin + ' to continue.' \
      + "\r\nTo do this, you can run: vagrant plugin install " + plugin
  end
}


Vagrant.configure("2") do |config|

  config.ssh.pty = true

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

      #For OpenStack
      production.vm.provider :openstack do |openstack, override|

          override.vm.box = "dummy-openstack"
          override.vm.box_url = "https://github.com/cloudbau/vagrant-openstack-plugin/raw/master/dummy.box"
          override.ssh.private_key_path = ["~/.ssh/#{ENV['OS_KEYPAIR_NAME']}.pem"]

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
        
          override.vm.box = "dummy-aws"
          override.vm.box_url = "https://github.com/mitchellh/vagrant-aws/raw/master/dummy.box"
          override.ssh.private_key_path = ["~/.ssh/#{ENV['AWS_KEYPAIR_NAME']}.pem"]

          aws.access_key_id = "#{ENV['AWS_ACCESS_KEY_ID']}"
          aws.secret_access_key = "#{ENV['AWS_SECRET_ACCESS_KEY']}"
          aws.keypair_name = "#{ENV['AWS_KEYPAIR_NAME']}"

          aws.instance_type = "#{ENV['AWS_INSTANCE_TYPE']}"
          aws.ami = "#{ENV['AWS_AMI']}"
          override.ssh.username = "#{ENV['AWS_SSH_USERNAME']}"

          aws.security_groups = ['Web']
          aws.region = "#{ENV['AWS_REGION']}"

          aws.tags = {
            'Name' => 'espaces.edu.au'
          }
          aws.block_device_mapping = [
            {
              'DeviceName' => "/dev/sda",
              'Ebs.VolumeSize' => 250,
              'Ebs.DeleteOnTermination' => false,
              'Ebs.VolumeType' => 'standard'
            }
          ]
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

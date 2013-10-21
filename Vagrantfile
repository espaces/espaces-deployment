# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  config.vm.box     = "centos-64-x64-vbox4210"
  config.vm.box_url = "http://puppet-vagrant-boxes.puppetlabs.com/centos-64-x64-vbox4210.box"

  config.vm.network :forwarded_port, guest: 8080, host: 8081
  config.vm.network :public_network

  config.vm.synced_folder "salt/roots/", "/srv/"

  config.vm.provision :salt do |salt|
    salt.minion_config = "salt/minion"
    salt.run_highstate = true
    salt.verbose = true
    salt.install_type = "git"
    salt.install_args = "develop"
    salt.always_install = true
  end

  config.vm.provider :virtualbox do |vb|
    vb.customize ["modifyvm", :id, "--cpus", "1"]
    vb.customize ["modifyvm", :id, "--memory", "2048"]
  end

end

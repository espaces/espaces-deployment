# -*- mode: ruby -*-
# vi: set ft=ruby :
#

Vagrant.configure("2") do |config|

    config.vm.box = "centos-6.5-x86_64"
    config.vm.box = "https://www.hpc.jcu.edu.au/boxes/centos-6.5-x86_64.box"
    #config.vm.box     = "centos-7.0-x86_64"
    #config.vm.box_url = "https://www.hpc.jcu.edu.au/boxes/centos-7.0-x86_64.box"
    config.vm.network :private_network, ip: "25.1.1.x"

    config.vm.provision :salt do |salt|
        salt.minion_config = "salt/minion_production"
        salt.run_highstate = true
        salt.verbose = true
        salt.colorize = true
        salt.install_type = "git"
        salt.install_args = "2014.7"
        salt.always_install = true
    end

    config.vm.synced_folder "salt/roots/", "/srv/"
    config.vm.provider :virtualbox do |vb|
        vb.memory = 2048
        vb.customize ["modifyvm", :id, "--cpus", "4"]
    end

end

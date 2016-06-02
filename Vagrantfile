# -*- mode: ruby -*-
# vi: set ft=ruby :
#
plugins = []
plugins.each { |plugin|
  unless Vagrant.has_plugin?(plugin)
    raise 'You must install ' + plugin + ' to continue.' \
      + "\r\nTo do this, you can run: vagrant plugin install " + plugin
  end
}

Vagrant.configure("2") do |config|

    config.vm.box = "centos-6.5-x86_64"
    config.vm.box = "https://www.hpc.jcu.edu.au/boxes/centos-6.5-x86_64.box"
    #config.vm.box     = "centos-7.0-x86_64"
    #config.vm.box_url = "https://www.hpc.jcu.edu.au/boxes/centos-7.0-x86_64.box"
    config.vm.network :private_network, ip: "25.1.1.3"

    config.vm.provision :salt do |salt|
        salt.minion_config = "salt/minion_production"
        salt.run_highstate = true
        salt.verbose = true
        salt.colorize = true
        salt.install_type = "git"
        salt.install_args = "v2015.5.1"
        salt.bootstrap_options = "-G" # Use https:// over git://
        salt.always_install = true
    end

    config.vm.synced_folder "salt/roots/", "/srv/"
    config.vm.provider :virtualbox do |vb|
        vb.name = "vagrant-espaces-development"
        vb.memory = 2048
        vb.customize ["modifyvm", :id, "--cpus", "4"]
    end

end

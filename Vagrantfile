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

    config.vm.box = "centos-6.7-x86_64-jcu"
    config.vm.box = "https://www.hpc.jcu.edu.au/boxes/centos-6.7-x86_64-virtualbox.box"
    config.vm.network :private_network, ip: "25.1.1.3"

    config.vm.provision :salt do |salt|
        salt.minion_config = "salt/minion_production"
        salt.run_highstate = true
        salt.verbose = true
        salt.colorize = true
        salt.install_type = "git"
        salt.install_args = "v2016.11.7"
        salt.always_install = false
        # Workarounds to get working on CentOS 6
        salt.bootstrap_options = "-P -y -x python2.7"
    end

    config.vm.synced_folder "salt/roots/", "/srv/"
    config.vm.provider :virtualbox do |vb|
        vb.name = "vagrant-espaces"
        vb.memory = 2048
        vb.cpus = 2
    end

end

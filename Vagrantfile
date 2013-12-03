# -*- mode: ruby -*-
# vi: set ft=ruby :

# Vagrantfile API/syntax version. Don't touch unless you know what you're doing!
VAGRANTFILE_API_VERSION = "2"

Vagrant.configure(VAGRANTFILE_API_VERSION) do |config|
  
  config.vm.box = "precise64"

  config.vm.network :forwarded_port, guest: 50070, host: 50070
  config.vm.network :forwarded_port, guest: 50030, host: 50030
  config.vm.network :forwarded_port, guest: 50060, host: 50060

  config.vm.synced_folder "vm-shared/", "/home/vagrant/vm-shared"

  config.vm.provision :shell, :path => "vm-init.sh"
  
end

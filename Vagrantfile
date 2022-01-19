# -*- mode: ruby -*-
# vi: set ft=ruby :

BOX_NAME = ENV["BOX_NAME"] || "bento/ubuntu-18.04"
BOX_MEMORY = ENV["BOX_MEMORY"] || "512"
DOKKU_VERSION = "master"

Vagrant.configure(2) do |config|
  config.vm.box = BOX_NAME
  config.ssh.forward_agent = true

  config.vm.provider :virtualbox do |vb|
    # Ubuntu's Raring 64-bit cloud image is set to a 32-bit Ubuntu OS type by
    # default in Virtualbox and thus will not boot. Manually override that.
    vb.customize ["modifyvm", :id, "--ostype", "Ubuntu_64"]
    vb.customize ["modifyvm", :id, "--memory", BOX_MEMORY]
  end

  config.vm.provider :vmware_fusion do |v, override|
    v.vmx["memsize"] = BOX_MEMORY
  end

  config.vm.define "default", primary: true do |vm|
    vm.vm.synced_folder File.dirname(__FILE__), "/vagrant"

    vm.vm.provision :shell, :inline => "curl https://raw.githubusercontent.com/dokku/dokku/v0.14.6/bootstrap.sh | bash"
  end
end

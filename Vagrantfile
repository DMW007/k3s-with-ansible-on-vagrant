# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'
current_dir    = File.dirname(File.expand_path(__FILE__))
config_file = ENV['VAGRANT_CONFIG_FILE'] || "vagrant-config.yml"
vconfig        = YAML.load_file("#{current_dir}/" + config_file)

ansible_config_file = ENV['ANSIBLE_CONFIG_FILE'] || "vars.yml"
puts "Config files\n\tVagrant: " + config_file + "\n\tAnsible: " + ansible_config_file

ressources_config = vconfig['ressources']
rancher_config = vconfig['rancher']
ansible_config = vconfig['ansible']

Vagrant.require_version ">= 1.7.0"

Vagrant.configure(2) do |config|
  # With bionic we sometimes got a timeout when waiting for dns pod
  config.vm.box = "ubuntu/xenial64"

  if rancher_config['forward_ports'] then 
    config.vm.network "forwarded_port", guest: 80, host: rancher_config['host_http_port']
    config.vm.network "forwarded_port", guest: 443, host: rancher_config['host_https_port']
  end

  # Disable the new default behavior introduced in Vagrant 1.7, to ensure that all Vagrant machines will use the same SSH key pair.
  # See https://github.com/hashicorp/vagrant/issues/5005
  config.ssh.insert_key = vconfig['insert_ssh_key']

  # Requirements for ansible
  config.vm.provision "shell", inline: <<-SHELL
    test -e /usr/bin/python || (apt-get update && apt-get install -y python-minimal build-essential python-pip)
  SHELL

  config.vm.provision "ansible" do |ansible|
    ansible.verbose = ansible_config['verbose_args']
    ansible.playbook = "k3s.yml"
    ansible.extra_vars = "@" + ansible_config_file
  end

  config.vm.provider "virtualbox" do |v|
    v.memory = ressources_config['memory']
    v.cpus = ressources_config['cpus']
  end
end
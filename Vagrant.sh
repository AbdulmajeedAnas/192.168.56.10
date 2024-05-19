#!/bin/bash

Vagrant up
Vagrant.configure("2") do |config|
  # Define the master VM
  config.vm.define "master" do |master|
    master.vm.box = "ubuntu/bionic64" # You can use any other Ubuntu box
    master.vm.hostname = "master"
    master.vm.network "private_network", ip: "192.168.56.10"

    # Provisioning script for master
    #master.vm.provision "shell", inline: <<-SHELL
    #  sudo apt-get update
    #  sudo apt-get install -y apache2
    #  echo "This is the master server" > /var/www/html/index.html
    #SHELL
  end

  # Define the slave VM
  config.vm.define "slave" do |slave|
    slave.vm.box = "ubuntu/bionic64" # You can use any other Ubuntu box
    slave.vm.hostname = "slave"
    slave.vm.network "private_network", ip: "192.168.56.11"

    # Provisioning script for slave
    #slave.vm.provision "shell", inline: <<-SHELL
    #  sudo apt-get update
    #  sudo apt-get install -y apache2
    #  echo "This is the slave server" > /var/www/html/index.html
    #SHELL
  end
end
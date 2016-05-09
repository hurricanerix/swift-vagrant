# -*- mode: ruby -*-
# vi: set ft=ruby :
require 'yaml'

# read local config values.
local_config = 'local.yaml'
if !File.exist?(local_config)
    STDERR.puts "local.yaml not found, creating one using example.local.yaml"
    `cp example.local.yaml local.yaml`
end
settings = YAML.load_file local_config

Vagrant.configure("2") do |config|

  # Admin Nodes
  (1..1).each do |i|
    hostname = "admin#{i}"
    config.vm.define hostname do |admin|
      admin.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      admin.vm.box = "trusty64"
      admin.vm.hostname = hostname
      admin.vm.synced_folder "salt", "/srv/salt/"
      admin.vm.network :private_network, ip: "#{settings['admin']['ip']}"

      admin.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", hostname]
      end

      admin.vm.provision :salt do |saltmaster|
        saltmaster.always_install = true
        saltmaster.install_master = true
        saltmaster.master_config = "salt/master/conf"
        saltmaster.masterless = false
        saltmaster.bootstrap_options = '-F -c /tmp/ -P'
      end

      # http://foo-o-rama.com/vagrant--stdin-is-not-a-tty--fix.html
      admin.vm.provision "fix-no-tty", type: "shell" do |s|
          s.privileged = false
          s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
      end

      admin.vm.provision "update system packages", type: "shell" do |s|
        s.privileged = true
        s.inline = "apt-get update && apt-get upgrade -Vy --force-yes"
      end

      admin.vm.provision "update hosts", type: "shell" do |s|
        s.privileged = true
        s.inline = "echo \"#{settings['admin']['ip']} salt\" >> /etc/hosts"
      end

      admin.vm.provision :salt do |saltminion|
        saltminion.masterless = false
        saltminion.minion_id = hostname
        saltminion.minion_config = "salt/minion/conf"
        saltminion.grains_config = "salt/minion/grains/admin"
        saltminion.run_highstate = false
        saltminion.bootstrap_options = '-F -c /tmp/ -P'
      end
    end
  end

  # Load Balancer Nodes
  (1..1).each do |i|
    hostname = "lb#{i}"
    config.vm.define hostname do |lb|
      lb.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      lb.vm.box = "trusty64"
      lb.vm.hostname = hostname
      lb.vm.synced_folder "salt", "/srv/salt/"
      lb.vm.network :private_network, ip: "#{settings['general']['network']}.8#{i}"

      lb.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", hostname]
      end

      # http://foo-o-rama.com/vagrant--stdin-is-not-a-tty--fix.html
      lb.vm.provision "fix-no-tty", type: "shell" do |s|
          s.privileged = false
          s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
      end

      lb.vm.provision "update system packages", type: "shell" do |s|
        s.privileged = true
        s.inline = "apt-get update && apt-get upgrade -Vy --force-yes"
      end

      lb.vm.provision "update hosts", type: "shell" do |s|
        s.privileged = true
        s.inline = "echo \"#{settings['admin']['ip']} salt\" >> /etc/hosts"
      end

      lb.vm.provision :salt do |saltminion|
        saltminion.masterless = false
        saltminion.minion_id = hostname
        saltminion.minion_config = "salt/minion/conf"
        saltminion.grains_config = "salt/minion/grains/lb"
        saltminion.run_highstate = false
        saltminion.bootstrap_options = '-F -c /tmp/ -P'
      end
    end
  end

  # Proxy Nodes
  (1..settings['proxy']['count']).each do |i|
    hostname = "proxy-z#{i}"
    config.vm.define hostname do |proxy|
      proxy.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      proxy.vm.box = "trusty64"
      proxy.vm.hostname = hostname

      proxy.vm.network :private_network, ip: "#{settings['general']['network']}.10#{i}"

      proxy.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", hostname]
      end

      # http://foo-o-rama.com/vagrant--stdin-is-not-a-tty--fix.html
      proxy.vm.provision "fix-no-tty", type: "shell" do |s|
          s.privileged = false
          s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
      end

      proxy.vm.provision "update system packages", type: "shell" do |s|
        s.privileged = true
        s.inline = "apt-get update && apt-get upgrade -Vy --force-yes"
      end

      proxy.vm.provision "update hosts", type: "shell" do |s|
        s.privileged = true
        s.inline = "echo \"#{settings['admin']['ip']} salt\" >> /etc/hosts"
      end

      proxy.vm.provision :salt do |saltminion|
        saltminion.masterless = false
        saltminion.minion_id = hostname
        saltminion.minion_config = "salt/minion/conf"
        saltminion.grains_config = "salt/minion/grains/proxy"
        saltminion.run_highstate = false
        saltminion.bootstrap_options = '-F -c /tmp/ -P'
      end
    end
  end

  # Storage Nodes
  (1..settings['storage']['count']).each do |i|
    hostname = "storage-z#{i}"
    config.vm.define hostname do |storage|
      storage.vm.box_url = "https://cloud-images.ubuntu.com/vagrant/trusty/current/trusty-server-cloudimg-amd64-vagrant-disk1.box"
      storage.vm.box = "trusty64"
      storage.vm.hostname = hostname
      storage.vm.network :private_network, ip: "#{settings['general']['network']}.20#{i}"

      storage.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 1024]
        v.customize ["modifyvm", :id, "--name", hostname]
        v.customize ["storagectl", :id, "--name", "SATAController", "--portcount", 11]

        (1..10).each do |j|
          file_to_disk = "./tmp/#{hostname}-d#{j}.vdi"
          unless File.exist?(file_to_disk)
            v.customize ['createhd', '--filename', file_to_disk, '--size', 400 * 1024]
          end
        end
        # TODO: figure out why this does not work in a loop...
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 1, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d1.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 2, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d2.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 3, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d3.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 4, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d4.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 5, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d5.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 6, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d6.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 7, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d7.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 8, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d8.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 9, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d9.vdi"]
        v.customize ['storageattach', :id, '--storagectl', 'SATAController', '--port', 10, '--device', 0, '--type', 'hdd', '--medium', "./tmp/#{hostname}-d10.vdi"]
      end

      # http://foo-o-rama.com/vagrant--stdin-is-not-a-tty--fix.html
      storage.vm.provision "fix-no-tty", type: "shell" do |s|
          s.privileged = false
          s.inline = "sudo sed -i '/tty/!s/mesg n/tty -s \\&\\& mesg n/' /root/.profile"
      end

      storage.vm.provision "update system packages", type: "shell" do |s|
        s.privileged = true
        s.inline = "apt-get update && apt-get upgrade -Vy --force-yes"
      end

      storage.vm.provision "update hosts", type: "shell" do |s|
        s.privileged = true
        s.inline = "echo \"#{settings['admin']['ip']} salt\" >> /etc/hosts"
      end

      storage.vm.provision :salt do |saltminion|
        saltminion.masterless = false
        saltminion.minion_id = hostname
        saltminion.minion_config = "salt/minion/conf"
        saltminion.grains_config = "salt/minion/grains/storage"
        saltminion.run_highstate = false
        saltminion.bootstrap_options = '-F -c /tmp/ -P'
      end
    end
  end
end

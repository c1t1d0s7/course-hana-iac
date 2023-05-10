# -*- mode: ruby -*-
# vi: set ft=ruby :

Vagrant.configure("2") do |config|

  $vm_provider = "virtualbox"
  $box_image = "generic/rocky8"

  $vm_name_prefix = "iac"

  $number_of_control_planes = 1
  $number_of_nodes = 1

  $vm_subnet = "192.168.56"

  $vm_control_plane_cpus = 1
  $vm_control_plane_memory = 2048
  $vm_node_cpus = 1
  $vm_node_memory = 2048

  # Controllers
  (1..$number_of_control_planes).each do |i|
    config.vm.define "#{$vm_name_prefix}-control#{i}" do |node|
      node.vm.box = $box_image
      node.vm.provider $vm_provider do |vm|
        vm.name = "#{$vm_name_prefix}-control#{i}"
        vm.cpus = $vm_control_plane_cpus
        vm.memory = $vm_control_plane_memory
      end
      node.vm.hostname = "#{$vm_name_prefix}-control#{i}"
      node.vm.network "private_network", ip: "#{$vm_subnet}.1#{i}", nic_type: "virtio"
    end
  end

  # Nodes
  (1..$number_of_nodes).each do |i|
    config.vm.define "#{$vm_name_prefix}-node#{i}" do |node|
      node.vm.box = $box_image
      node.vm.provider $vm_provider do |vm|
        vm.name = "#{$vm_name_prefix}-node#{i}"
        vm.cpus = $vm_node_cpus
        vm.memory = $vm_node_memory
      end
      node.vm.hostname = "#{$vm_name_prefix}-node#{i}"
      node.vm.network "private_network", ip: "#{$vm_subnet}.2#{i}", nic_type: "virtio"
    end
  end

  # Enable SSH Password Authentication
  config.vm.provision "shell", inline: <<-SHELL
    sed -i 's/PasswordAuthentication no/PasswordAuthentication yes/g' /etc/ssh/sshd_config
    systemctl restart sshd
  SHELL
end

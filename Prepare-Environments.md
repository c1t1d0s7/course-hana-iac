# IaC 실습 환경 구성

## 1. VirtualBox 다운로드 및 설치

[VirtualBox 설치 파일](https://download.virtualbox.org/virtualbox/7.0.8/VirtualBox-7.0.8-156879-Win.exe)

[VirtualBox 확장 팩](https://download.virtualbox.org/virtualbox/7.0.8/Oracle_VM_VirtualBox_Extension_Pack-7.0.8.vbox-extpack)

> [Microsoft Visual C++ Redistributable 2019](https://aka.ms/vs/17/release/vc_redist.x64.exe)가 필요한 경우 받아서 설치

## 2. Vagrant 다운로드 및 설치

[Vagrant 설치 파일](https://releases.hashicorp.com/vagrant/2.3.4/vagrant_2.3.4_windows_amd64.msi)

> VirtualBox 및 Vagrant가 정상적으로 동작하기 위해 시스템 재부팅 필요

## 3. Vagrant로 실습 환경 구성

### Vagrant 디렉토리 생성

`powershell` 앱 실행

```powershell
> cd ~ 
> mkdir iac
> cd iac
```

### Vagrantfile 파일 작성

```powershell
> code Vagrantfile
```

```ruby
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
```

`Vagrantfile` 파일 이름으로 파일 내용 저장

### Vagrant로 VM 관리

VM (생성 및) 부팅

```
vagrant up
```

VM 상태 확인

```
vagrant status
```

VM 접속

```
vagrant ssh <VM_NAME>
vagrant ssh iac-control1
```

VM 나가기

```
exit
```

VM 종료

```
vagrant halt
```

VM 삭제

```
vagrant destroy
```

## 4. Visual Studio Code 설치

### VSCode 다운로드 및 설치

[VSCode 설치 파일](https://code.visualstudio.com/sha/download?build=stable&os=win32-x64-user)

확장 프로그램:

- Korean Language Pack for Visual Studio Code
- Remote - SSH
- YAML
- Ansible
- HashiCorp HCL
- HashiCorp Terraform

### VSCode에서 VM에 SSH 연결 설정

```powershell
> vagrant ssh-config

Host iac-control1
  HostName 127.0.0.1
  User vagrant
  Port 2222
  UserKnownHostsFile /dev/null
  StrictHostKeyChecking no
  PasswordAuthentication no
  IdentityFile C:/Users/user/iac/.vagrant/machines/iac-control1/virtualbox/private_key
  IdentitiesOnly yes
  LogLevel FATAL
...
```

`Host iac-control1` 부분을 복사

VSCode에서 `원격 탐색기` => `SSH` => 기어 아이콘 => `C:\USers\user\.ssh\config` 선택

```
Host iac-control1
    HostName 192.168.56.11
    User vagrant
    Port 22
    UserKnownHostsFile /dev/null
    StrictHostKeyChecking no
    PasswordAuthentication no
    IdentityFile C:/Users/user/iac/.vagrant/machines/iac-control1/virtualbox/private_key
    IdentitiesOnly yes
    LogLevel FATAL
```

`HostName` 및 `Port` 부분을 수정하고 파일 저장

### VSCode에서 VM에 SSH 연결

VSCode에서 `원격 탐색기` => `원격` => 새로고침 아이콘 선택 => `iac-control1` => `현재 창에서 연결` / `새 창에서 연결` 아이콘 선택

메뉴 => 보기 => 터미널

## 5. Ansible 설치

iac-control1 시스템에 SSH로 접근

```bash
vagrant ssh iac-control1
```

```bash
sudo yum install -y ansible
```


## 6. Terraform 및 Packer 설치

iac-control1 시스템에 SSH로 접근

```bash
vagrant ssh iac-control1
```

```bash
sudo yum install -y yum-utils
```

```bash
sudo yum-config-manager --add-repo https://rpm.releases.hashicorp.com/RHEL/hashicorp.repo
```

```bash
sudo yum install -y terraform packer
```

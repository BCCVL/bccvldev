# -*- mode: ruby -*-
# vi: set ft=ruby :

# All Vagrant configuration is done below. The "2" in Vagrant.configure
# configures the configuration version (we support older styles for
# backwards compatibility). Please don't change it unless you know what
# you're doing.
Vagrant.configure("2") do |config|
  # The most common configuration options are documented and commented below.
  # For a complete reference, please see the online documentation at
  # https://docs.vagrantup.com.

  # Every Vagrant development environment requires a box. You can search for
  # boxes at https://atlas.hashicorp.com/search.
  config.vm.box = "centos/7"

  # Disable automatic box update checking. If you disable this, then
  # boxes will only be checked for updates when the user runs
  # `vagrant box outdated`. This is not recommended.
  # config.vm.box_check_update = false

  # Create a forwarded port mapping which allows access to a specific port
  # within the machine from a port on the host machine. In the example below,
  # accessing "localhost:8080" will access port 80 on the guest machine.
  # config.vm.network "forwarded_port", guest: 80, host: 8080

  # Create a private network, which allows host-only access to the machine
  # using a specific IP.
  config.vm.network "private_network", ip: "192.168.99.100"

  # Create a public network, which generally matched to bridged network.
  # Bridged networks make the machine appear as another physical device on
  # your network.
  # config.vm.network "public_network"

  # Share an additional folder to the guest VM. The first argument is
  # the path on the host to the actual folder. The second argument is
  # the path on the guest to mount the folder. And the optional third
  # argument is a set of non-required options.
  # config.vm.synced_folder "../data", "/vagrant_data"

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "virtualbox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = "2048"
  end
  #
  # View the documentation for the provider you are using for more
  # information on available options.

  # Define a Vagrant Push strategy for pushing to Atlas. Other push strategies
  # such as FTP and Heroku are also available. See the documentation at
  # https://docs.vagrantup.com/v2/push/atlas.html for more information.
  # config.push.define "atlas" do |push|
  #   push.app = "YOUR_ATLAS_USERNAME/YOUR_APPLICATION_NAME"
  # end

  # Enable provisioning with a shell script. Additional provisioners such as
  # Puppet, Chef, Ansible, Salt, and Docker are also available. Please see the
  # documentation for more information about their specific syntax and use.
  config.vm.provision "shell", inline: <<-SHELL
    yum -y upgrade
    yum install -y yum-utils git samba samba-common

    # update kernel
    rpm --import "https://www.elrepo.org/RPM-GPG-KEY-elrepo.org"
    rpm -Uvh "http://www.elrepo.org/elrepo-release-7.0-2.el7.elrepo.noarch.rpm"
    yum --enablerepo=elrepo-kernel install -y kernel-ml
    # set new kernel as default
    grub2-set-default

    # configure samba
    cat << EOF > /etc/samba/smb.conf
    [global]
    workgroup = WORKGROUP
    server string = Samba Server %v
    netbios name = bccvl
    security = user
    map to guest = bad user
    dns proxy = no
    # share vagrant home
    [vagrant]
    path = /home/vagrant
    browseable = yes
    writeable = yes
    guest ok = no
    read only = no
    valid users = vagrant
    force user = root
    force group = root
    hide dot files = no
    hosts allow = 192.168.99.0/255.255.255.0
    EOF

    echo 'vagrant' | tee - | smbpasswd -a -s vagrant
    # allow samba on home folder
    chcon -R -t samba_share_t /home/vagrant

    systemctl enable smb.service
    systemctl enable nmb.service
    systemctl restart smb.service
    systemctl restart nmb.service

    # install docker
    yum-config-manager --add-repo https://docs.docker.com/engine/installation/linux/repo_files/centos/docker.repo

    yum install -y docker-engine

    yum clean all

    systemctl enable docker.service

    systemctl start docker.service

    # allow ec2-user access to docker

    usermod -a -G docker vagrant

    # install docker-compose

    curl -L "https://github.com/docker/compose/releases/download/1.11.2/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

    chmod +x /usr/local/bin/docker-compose

    # setup bccvl hub
    docker login -u bccvlro -p bccvlro hub.bccvl.org.au
    sudo -i -u vagrant -- docker login -u bccvlro -p bccvlro hub.bccvl.org.au

    # install cloud9 ide and start it up

    sudo -i -u vagrant -- git clone https://github.com/BCCVL/bccvldev

    echo "C9_WORKSPACE=/home/vagrant/bccvldev" > /home/vagrant/bccvldev/.env
    echo "C9_USER=admin" >> /home/vagrant/bccvldev/.env
    echo "C9_PASS=admin" >> /home/vagrant/bccvldev/.env
    echo "BCCVL_HOSTNAME=192.168.99.100" >> /home/vagrant/bccvldev/.env

    echo "COMPOSE_FILE=docker-compose.yml:cloud9.yml" >> /home/vagrant/bccvldev/.env
    echo "COMPOSE_PROJECT_NAME=bccvldev" >> /home/vagrant/bccvldev/.env

    chown vagrant:vagrant /home/vagrant/bccvldev/.env
    chmod 600 /home/vagrant/bccvldev/.env

    sudo -i -u vagrant -- bash -c "cd bccvldev; ./bin/gen_config.sh"

    # TODO: maybe a systemd unit file would be best here?
    # echo '#!/bin/sh' > /var/lib/cloud/scripts/per-boot/cloud9.sh
    # echo 'sudo -i -u ec2-user -- bash -c "cd bccvldev; /usr/local/bin/docker-compose up -d nginxcloud9 cloud9"' >> /var/lib/cloud/scripts/per-boot/cloud9.sh
    # chmod +x /var/lib/cloud/scripts/per-boot/cloud9.sh

    # reboot to activate new kernel
    reboot

  SHELL
end

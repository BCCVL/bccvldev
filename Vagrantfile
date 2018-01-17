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

  # disable default synced folder
  config.vm.synced_folder ".", "/vagrant", disabled: true

  # Provider-specific configuration so you can fine-tune various
  # backing providers for Vagrant. These expose provider-specific options.
  # Example for VirtualBox:
  #
  config.vm.provider "VirtualBox" do |vb|
    # Display the VirtualBox GUI when booting the machine
    # vb.gui = true

    # Customize the amount of memory on the VM:
    vb.memory = "6144"
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
  config.vm.provision "shell" do |s|
    s.inline = <<-SHELL
        yum -y upgrade
        yum install -y yum-utils device-mapper-persistent-data lvm2 git

        # update kernel
        rpm --import "https://www.elrepo.org/RPM-GPG-KEY-elrepo.org"
        rpm -Uvh "http://www.elrepo.org/elrepo-release-7.0-3.el7.elrepo.noarch.rpm"
        yum --enablerepo=elrepo-kernel install -y kernel-ml kernel-ml-devel
        # set new kernel as default
        grub2-set-default 0

        # disable restrictive selinux (causes ssh login issues)
        sed -i'' -e 's/SELINUX=.*/SELINUX=permissive/' /etc/sysconfig/selinux
        sed -i'' -e 's/SELINUX=.*/SELINUX=permissive/' /etc/selinux/configy
    SHELL
  end
  config.vm.provision :reload
  config.vm.provision "shell" do |s|
    s.env = {
        "C9_PASS" => ENV["C9_PASS"],
        "BCCVL_HUB_USER" => ENV["BCCVL_HUB_USER"],
        "BCCVL_HUB_PASS" => ENV["BCCVL_HUB_PASS"]
    }
    s.inline = <<~SHELL
        # install epel for pwgen
        yum install -y https://dl.fedoraproject.org/pub/epel/epel-release-latest-7.noarch.rpm

        # install samba
        yum install -y samba samba-common pwgen

        # gen pw if needed
        if [ -z "$C9_PASS" ] ; then
            export C9_PASS=$(pwgen -cns 10 1)
        fi

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
        [bccvlvagrant]
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

        echo "$C9_PASS" | tee - | smbpasswd -a -s vagrant
        # allow samba on home folder
        chcon -R -t samba_share_t /home/vagrant

        systemctl enable smb.service
        systemctl enable nmb.service
        systemctl restart smb.service
        systemctl restart nmb.service

        # install docker
        yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo

        yum install -y docker-ce

        systemctl enable docker.service
        # stop in case it is already running
        systemctl stop docker.service
        # restart
        systemctl start docker.service

        # allow vagrant access to docker
        usermod -a -G docker vagrant

        # install docker-compose
        curl -L "https://github.com/docker/compose/releases/download/1.18.0/docker-compose-$(uname -s)-$(uname -m)" -o /usr/local/bin/docker-compose

        chmod +x /usr/local/bin/docker-compose

        # TODO: I could probably move the bccvldev setup out of here, and just setup
        #       cloup9. put config values into /home/ec2-user/.local/c9/env?
        #       and certs as well /home/ec2-user/.local/c9/c9.pem (dev env and cloud9 will have different certs)
        #       let's encrypt could be nice here?
        # setup bccvl hub
        #   login to bccvl hub if we have user and pass
        if [ -n "$BCCVL_HUB_USER" -a -n "$BCCVL_HUB_PASS" ] ; then
            docker login -u "$BCCVL_HUB_USER" -p "$BCCVL_HUB_PASS" hub.bccvl.org.au
            sudo -i -u vagrant -- docker login -u "$BCCVL_HUB_USER" -p "$BCCVL_HUB_PASS" hub.bccvl.org.au
        fi

        # setup bccvldev env
        sudo -i -u vagrant -- git clone https://github.com/BCCVL/bccvldev

        echo "C9_WORKSPACE=/home/vagrant/bccvldev" > /home/vagrant/bccvldev/.env
        echo "C9_USER=admin" >> /home/vagrant/bccvldev/.env
        echo "C9_PASS=$C9_PASS" >> /home/vagrant/bccvldev/.env
        echo "BCCVL_HOSTNAME=192.168.99.100" >> /home/vagrant/bccvldev/.env

        echo "COMPOSE_FILE=docker-compose.yml" >> /home/vagrant/bccvldev/.env
        echo "COMPOSE_PROJECT_NAME=bccvldev" >> /home/vagrant/bccvldev/.env

        chown vagrant:vagrant /home/vagrant/bccvldev/.env
        chmod 600 /home/vagrant/bccvldev/.env

        sudo -i -u vagrant -- bash -c "cd bccvldev; ./bin/gen_config.sh"

        # install c9 ide into /home/vagrant/c9sdk
        curl --silent --location https://rpm.nodesource.com/setup_9.x | bash -
        yum -y install nodejs gcc gcc-c++ glibc-static tmux
        sudo -i -u vagrant -- mkdir /home/vagrant/c9sdk
        sudo -i -u vagrant -- git clone https://github.com/c9/core.git c9sdk
        sudo -i -u vagrant -- ./c9sdk/scripts/install-sdk.sh

        # write c9 systemd unit
        cat << 'EOF' > /etc/systemd/system/c9.service
        [Unit]
        Description=Cloud9 IDE
        Requires=network.target

        [Service]
        Type=simple
        User=vagrant
        EnvironmentFile=/home/vagrant/bccvldev/.env
        ExecStart=/usr/bin/node /home/vagrant/c9sdk/server.js \
            --listen 0.0.0.0 \
            --port 8443 \
            --auth "admin:${C9_PASS}" \
            -w "/home/vagrant/bccvldev" \
            --secure /home/vagrant/bccvldev/etc/nginx.pem

        Restart=on-failure

        [Install]
        WantedBy=multi-user.target
        EOF

        systemctl daemon-reload
        systemctl enable c9
        systemctl start c9

        echo "BCCVL DEV ENV admin password: $C9_PASS"
        echo "Open ide at https://192.168.99.100:8443"

      SHELL
    end
end

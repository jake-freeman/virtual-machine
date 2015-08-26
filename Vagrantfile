# -*- mode: ruby -*-
# vi: set ft=ruby :

# If VAGRANT_USER has been specifically set in the environment, use it. Otherwise, just use USER
# 
$user = "#{ENV['VAGRANT_USER']}"
$user = $user != "" ? $user : "#{ENV['USER']}"

def get_network_address(config)
    # get the user-based quad
    # 
    require 'digest/sha1'
    digest = Digest::SHA1.hexdigest $user
    userquad = digest[-2..-1].hex

    # Get the box-based quad
    #
    match = /target-(\d+)/.match(config.vm.hostname)
    if match
        boxquad = match[1].to_i + 50
    else
        map = { "dev-base" =>  10, "dev-gui" =>  11 }
        boxquad = map[config.vm.hostname]
    end

    return "10.168.#{userquad}.#{boxquad}"
end

def provision(typelist, config)
    name = config.vm.hostname
    address = get_network_address(config)
    config.vm.provision "shell", inline: "echo started #{name} at #{address}", run: "always"

    provisionlist = {
        'base' => [ 
            'bin/base-provision.sh', 
            "users/#{$user}/base-provision.sh",
            'bin/target-provision.sh'
        ],
        'gui' => [ 
            'bin/gui-provision.sh', 
            "users/#{$user}/gui-provision.sh"
        ],
        'target' => [
            'bin/target-provision.sh',
            'bin/ssh-setup.sh'
        ],
        'final' => [
            'bin/first-login-setup.sh'
        ]
    }
    hostname = `uname -n`

    typelist.each { |type| 
        if provisionlist[type]
            provisionlist[type].each { |file|
                if File.exist?(file)
                    config.vm.provision "shell", path: file, keep_color: true, privileged: false,
                                                 args: ["#{$user}", hostname]
                end
            }
        end
    }
end

def set_dev_profile(config, name)
    config.vm.hostname = "dev-#{name}"

    config.ssh.forward_agent = true
    config.vm.network "public_network", ip: get_network_address(config), :netmask => "255.255.0.0"
    config.vm.network "private_network", type: "dhcp"

    config.vm.provider "virtualbox" do |vb|
        vb.memory = "4096"
        vb.cpus = 4
    end
end

def set_target_profile(config, number)
    config.vm.hostname = "target-#{number}"

    config.ssh.forward_agent = true
    config.vm.network "public_network", ip: get_network_address(config), :netmask => "255.255.0.0"
    config.vm.network "private_network", type: "dhcp"

    config.vm.provider "virtualbox" do |vb|
        vb.memory = "512"
        vb.cpus = 1
        vb.gui = false
        if number == 0
            vb.customize ["modifyvm", :id, "--uart1", "0x2f8", "3"]
            vb.customize ["modifyvm", :id, "--uartmode1", "COM1"]
        end
    end
end

Vagrant.configure(2) do |config|
    config.vm.box = "ubuntu/trusty64"
    config.vm.box_version = "14.04"
    config.vm.box_check_update = false

    # Base machine
    #
    config.vm.define :base, autostart: false do |base|
        # If Chris, forward port 80 on the host into the VM.
        if $user == "chris.koenig"
            config.vm.network("forwarded_port", guest: 80, host: 80)
        end

        set_dev_profile base, 'base'
        provision [ "base", "final" ], base
    end

    # GUI machine
    #
    config.vm.define :gui, autostart: false do |gui|
        config.vm.provider "virtualbox" do |vb|
            vb.gui = true
            vb.customize ["modifyvm", :id, "--vram", "32"]
        end

        set_dev_profile gui, 'gui'

        provision [ "base", "gui", "final" ], gui
    end 

    (0..10).each do |i|
        config.vm.define ("target-#{i}").to_sym, autostart: false do |target|
            set_target_profile target, i
            provision [ "target" ], target
        end
    end
end

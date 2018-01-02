Vagrant.configure("2") do |config|
    config.vm.box = "bento/ubuntu-16.04"
    config.vm.box_url = "https://atlas.hashicorp.com/bento/boxes/ubuntu-16.04"
    config.vm.network "private_network", ip: "10.10.10.130"

    config.vm.provider :virtualbox do |v|
        v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
        v.customize ["modifyvm", :id, "--memory", 4096]
        v.customize [ "modifyvm", :id, "--uartmode1", "disconnected" ] # No need for logging
    end

    config.vm.synced_folder "./app", "/var/www", create: true

    config.vm.provision :shell, :path => "provision.sh"
    config.vm.provision :shell, run: "always", :path => "startup.sh"
end

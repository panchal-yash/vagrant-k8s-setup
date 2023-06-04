Vagrant.configure("2") do |config|
  config.vm.define "db1" do |db1|
    db1.vm.box = "ubuntu/focal64"
    db1.vm.hostname = 'db1'
    db1.vm.box_url = "ubuntu/focal64"
    db1.vm.provision "shell", path: "setup-k8s.sh"
    db1.vm.provision "shell", path: "master.sh"
    db1.vm.network "public_network", ip: '192.168.1.101', bridge: 'enp11s0'
    db1.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 2000]
      v.customize ["modifyvm", :id, "--name", "db1"]
    end
  end

  config.vm.define "db2" do |db2|
    db2.vm.box = "ubuntu/focal64"
    db2.vm.hostname = 'db2'
    db2.vm.box_url = "ubuntu/focal64"
    db2.vm.provision "shell", path: "setup-k8s.sh"
    db2.vm.provision "shell", path: "worker.sh"
    db2.vm.network "public_network", ip: '192.168.1.102', bridge: 'enp11s0'
    db2.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 2000]
      v.customize ["modifyvm", :id, "--name", "db2"]
      
    end
  end

  config.vm.define "db3" do |db3|
    db3.vm.box = "ubuntu/focal64"
    db3.vm.hostname = 'db3'
    db3.vm.box_url = "ubuntu/focal64"
    db3.vm.provision "shell", path: "setup-k8s.sh"
    db3.vm.provision "shell", path: "worker.sh"
    db3.vm.network "public_network", ip: '192.168.1.103', bridge: 'enp11s0'
    db3.vm.provider :virtualbox do |v|
      v.customize ["modifyvm", :id, "--natdnshostresolver1", "on"]
      v.customize ["modifyvm", :id, "--memory", 2000]
      v.customize ["modifyvm", :id, "--name", "db3"]
      
    end
  end


end


# Vagrantfile (QEMU on Apple Silicon)
Vagrant.configure("2") do |config|
  # Use one ARM64 box for both VMs
  config.vm.box = "perk/ubuntu-2204-arm64"

  # If you plan to use /vagrant inside the VMs, keep rsync on QEMU
  config.vm.synced_folder ".", "/vagrant", type: "rsync", rsync__auto: true

  # ---------- Server ----------
  config.vm.define "aoustaniS" do |ser|
    ser.vm.hostname = "aoustaniS"
    ser.vm.network "private_network", ip: "192.168.56.110", nic_type: "virtio"
    # Forward VM:80 -> Host:5656
    ser.vm.network "forwarded_port", guest: 80, host: 5656

    ser.vm.provider :qemu do |q|
      q.memory  = 1024
      q.cpus    = 1
      q.accel   = "hvf"     # Apple Hypervisor Framework acceleration
      q.display = "none"    # use "cocoa" if you want a VM window
      q.ssh_port = 55022
    end
  end

  # ---------- Worker ----------
  config.vm.define "aoustaniW" do |wor|
    wor.vm.hostname = "aoustaniW"
    
    wor.vm.network "private_network", ip: "192.168.56.111", nic_type: "virtio"
    # Forward VM:80 -> Host:5665
    wor.vm.network "forwarded_port", guest: 80, host: 5665

    wor.vm.provider :qemu do |q|
      q.memory  = 1024
      q.cpus    = 1
      q.accel   = "hvf"
      q.display = "none"
      q.ssh_port = 55023
    end
  end
end

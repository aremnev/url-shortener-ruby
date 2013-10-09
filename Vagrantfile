Vagrant.configure('2') do |config|
  config.vm.box      = 'precise32'
  config.vm.box_url  = 'http://files.vagrantup.com/precise32.box'
  config.vm.hostname = 'rails-dev-box'

  config.vm.network :private_network, ip: '192.168.33.10'

  config.vm.provision :puppet do |puppet|
    puppet.manifests_path = 'config/puppet/manifests'
    puppet.module_path    = 'config/puppet/modules'
  end
end

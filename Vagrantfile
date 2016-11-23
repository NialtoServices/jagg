# Get the name of the gem
name = File.basename(File.expand_path('..', __FILE__))
raise 'Could not determine gem name' unless name

# Configure Vagrant
Vagrant.configure(2) do |config|
  config.vm.box = 'ubuntu/xenial64'
  config.vm.synced_folder './', "/opt/#{name}"
  config.vm.provision 'shell', inline: <<-SHELL
    locale-gen en_GB.UTF-8
    apt-get update
    apt-get dist-upgrade -y
    apt-get install build-essential git software-properties-common -y
    apt-add-repository ppa:brightbox/ruby-ng -y
    apt-get update
    apt-get install ruby2.3 ruby2.3-dev -y
    echo 'export PATH="$PATH:$HOME/.gem/ruby/2.3.0/bin"' | su vagrant -l -c 'tee -a ~/.bash_profile'
    echo 'gem: --no-document --user-install' | su vagrant -l -c 'tee -a ~/.gemrc'
    su vagrant -l -c 'gem install bundle'
    su vagrant -l -c "cd /opt/#{name}; bundle install"
  SHELL
end

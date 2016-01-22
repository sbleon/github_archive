Vagrant.configure(2) do |config|
  config.vm.box = "ubuntu/trusty64"
  config.vm.network "forwarded_port", guest: 3000, host: ENV.fetch('PORT', 3000)

  config.vm.provider "virtualbox" do |v|
    v.memory = 1024
  end

  config.vm.provision "shell", inline: <<-SHELL
    sudo apt-get update
    sudo apt-get -y autoremove
    sudo apt-get upgrade

    # Postgres
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'
    sudo apt-get install wget ca-certificates
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update
    sudo apt-get install -yq postgresql-9.5 libpq-dev

    # Ruby
    sudo add-apt-repository ppa:brightbox/ruby-ng
    sudo apt-get update
    sudo apt-get install -yq ruby2.3 ruby2.3-dev
    sudo gem install bundler
    sudo apt-get install -yq autoconf bison build-essential curl gnupg libcurl4-openssl-dev libssl-dev libyaml-dev libreadline6-dev zlib1g-dev libncurses5-dev libffi-dev libgdbm3 libgdbm-dev

    # Node
    sudo apt-get install -yq nodejs
    sudo ln -sf /usr/bin/nodejs /usr/local/bin/node

    # Application
    cd /vagrant
    bundle install
    sudo -u postgres psql -c "create user vagrant superuser password 'password'"
    bin/rake db:setup

    # Passenger
    sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv-keys 561F9B9CAC40B2F7
    sudo apt-get install -y apt-transport-https ca-certificates
    sudo sh -c 'echo deb https://oss-binaries.phusionpassenger.com/apt/passenger trusty main > /etc/apt/sources.list.d/passenger.list'
    sudo apt-get update
    sudo apt-get install -yq passenger

    echo '#!/bin/sh -e' | sudo tee /etc/rc.local
    echo "cd /vagrant" | sudo tee -a /etc/rc.local
    echo "passenger start" | sudo tee -a /etc/rc.local
    echo "exit 0" | sudo tee -a /etc/rc.local
  SHELL
end

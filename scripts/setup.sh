#!/usr/bin/env bash

fail () {
  echo "$@" >&2
  exit 1
}

main () {
  sudo apt-get update
  fix_sudo
  install_bash_profile
  install_apt_add
  install_tools
  install_nodejs
#  install_rbenv
  install_rvm
  clean_up_packages
}

fix_sudo () {
  # Set up sudo
  echo %vagrant ALL=NOPASSWD:ALL > /etc/sudoers.d/vagrant
  chmod 0440 /etc/sudoers.d/vagrant
  # Setup sudo to allow no-password sudo for "sudo"
  usermod -a -G sudo vagrant
}

install_rvm () {
  print_section "Installing RVM and stable Ruby"
  sudo gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
  sudo \curl -sSL https://get.rvm.io | bash -s stable --rails
  print_section "Adding vagrant to the rvm group"
  groupadd rvm
  usermod -G rvm vagrant
}

install_rbenv () {
  print_section "Installing rbenv"
  sudo apt-get install -y rbenv
}

install_nodejs () {
  print_section "Installing Node JS"
  sudo apt-get install -y nodejs
  print_section "Installing NPM"
  sudo apt-get install -y npm
  print_section "Adding Node to path"
  sudo ln -s  /usr/bin/nodejs  /usr/bin/node
}

print_section () {
  local msg="$1"
  echo "************************************************************"
  echo "$msg"
  echo "************************************************************"
}

install_tools () {
  print_section "Installing good-to-have packages"
  sudo apt-get install -y \
    build-essential \
    git-core \
    vim \
    curl \
    ack-grep \
    wget \
    tree \
    zip \
    unzip \
    libssl-dev \
    || fail "Unable to install tools."
}

install_apt_add () {
  print_section "Installing apt-add-repository"
  sudo apt-get install -y python-software-properties || fail "Unable to install python-software-properties"
}

#add_nginx_repo () {
#  print_section "Adding ppa:nginx/stable"
#  sudo apt-add-repository -y ppa:nginx/stable || fail "Unable to install Nginx repo"
#}

# update_package_list () {
#   print_section "Updating package list"
#   sudo apt-get update
# }

# install_nginx () {
#   print_section "Installing nginx"
#   sudo apt-get install -y nginx || fail "Unable to install Nginx"
# }

# install_php5_fpm () {
#   print_section "Installing PHP5 FPM"
#   sudo apt-get install -y \
#     php5 \
#     php5-fpm \
#     php5-common \
#     php5-dev \
#     php5-gd \
#     php5-xcache \
#     php5-mcrypt \
#     php5-pspell \
#     php5-snmp \
#     php5-xsl \
#     php5-imap \
#     php5-geoip \
#     php5-curl \
#     php5-cli \
#     || fail "Unable to install PHP5 FPM"
# }

clean_up_packages () {
  print_section "Cleaning up packages"
  (sudo apt-get autoremove -y && sudo apt-get autoclean -y) || fail "Unable to clean up packages"
}

install_bash_profile () {
  print_section "Installing .bash_profile"
  cp /vagrant/configs/.bash_profile /home/vagrant/.bash_profile
  chown vagrant:vagrant /home/vagrant/.bash_profile
}

# configure_php5fpm () {
#   print_section "Configure PHP5 FPM"
#   if [ ! -d /var/run/php5-fpm ]; then
#     sudo mkdir /var/run/php5-fpm || fail "Unable to create /var/run/php5-fpm"
#   fi
#   ( sudo cp /vagrant/configs/default_nginx.conf /etc/php5/fpm/pool.d/default_nginx.conf \
#     && sudo cp /vagrant/configs/index.php /usr/share/nginx/html/index.php ) \
#     || fail "Unable to copy PHP FPM config files."
# }

# configure_nginx () {
#   print_section "Configure Nginx"
#   ( sudo cp /vagrant/configs/nginx.conf /etc/nginx/nginx.conf \
#     && sudo cp /vagrant/configs/nginx_default /etc/nginx/sites-available/default ) \
#     || fail "Unable to copy Nginx config files."
# }

# restart_services () {
#   print_section "Restart services"
#   sudo service php5-fpm restart
#   sudo service nginx restart
# }

main "$@"


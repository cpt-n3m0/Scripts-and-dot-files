wd=$(pwd)
pf='.config_phase'
phase=0

if [[ -f $pf ]]
then
  phase=$(cat $pf)
  echo "Continuing at phase $phase."
else
  echo $phase > $pf
fi

if [ $phase -eq 0 ]
then

  echo "Configuration started"
  ln  welcome $HOME/welcome
  echo "Setting up bash configs"
  mv $HOME/.bashrc .bashrc.backup
  ln .bashrc $HOME/.bashrc

  echo "Installing themes and fonts"
  sudo cp -r ./Midnight-BlueNight /usr/share/themes
  sudo cp -r ./fantasque /usr/share/fonts

  echo "Setting up scripts"
  scd=$HOME/scripts
  mkdir $scd
  ln getHN.py $scd/getHN.py
  ln gitStatusNotif.sh $scd/gitStatusNotif.sh


  echo "Beginning Installation of necessary software"

mysoft=("kitty" "vim" "ubuntu-gnome-desktop" "gdm3" "okular" "gnome-tweaks" "python3" "python3-pip" "python3-venv" "cmake" "net-tools" "curl" "xclip" "wine" "gimp" "wireshark" "ffmpeg" "vlc" "qemu-kvmlibvirt-daemon-systemlibvirt-clientsbridge-utils" "virt-manager" "gnome-shell-extensions")

  installList=''
  for s in "${mysoft[@]}"
  do
    installList+=$s
    installList+=" "
  done

  sudo apt install -y $installList

  # Brave browser download
  sudo apt install apt-transport-https -y
  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg
  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list
  sudo apt update
  sudo apt install brave-browser -y

  echo 1 > .config_phase
  #sudo reboot
fi

if [ $phase -eq 1 ]; then
  echo "Setting up vim config..."
  git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
  mv $HOME/.vimrc .vimrc.backup
  ln .vimrc $HOME/.vimrc
  echo "Setting kitty config..."
  kd=$HOME/.config/kitty
  mv $kd kitty_old
  mkdir -p $kd/themes

  ln kitty/kitty.conf $kd
  for f in $(ls kitty/themes)
  do
    ln kitty/themes/$f $kd/themes/$f
  done

  gsettings set org.gnome.desktop.default-applications.terminal exec kitty

  echo "Setting Gnome config..."
  dconf load / < ./gnome_tweaks.dconf

  echo "Setting Cron jobs"
  (crontab -l; echo '*/5 * * * * $scd/getHN.py'; echo "0 * * * * dconf dump / > $wd/gnome_tweaks.dconf ") | crontab -
  (sudo crontab -l; echo '* 12 * * * apt upgrade') | sudo crontab -

  sudo apt install golang npm -y
  cd  ~/.vim/bundle/YouCompleteMe/; python3 install.py --all >> /dev/null &
  cd
  cd $wd
fi

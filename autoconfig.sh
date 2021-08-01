wd=$(pwd)
pf='.config_phase'
phase=0

if [[ -f $pf ]]; then
  phase=$(cat $pf)
  echo "Continuing at phase $phase."
else
  echo $phase > $pf
fi

if [ $phase -eq 0 ]; then

  echo "Configuration started"
  echo "Setting up bash configs"
  mv $HOME/.bashrc .bashrc.backup
  cp .bashrc $HOME/.bashrc

  echo "Installing themes and fonts"
  sudo cp -r ./Midnight-BlueNight /usr/share/themes
  sudo cp -r ./fantasque /usr/share/fonts

  echo "Setting up scripts"
  scd=$HOME/scripts
  mkdir $scd
  ln getHN.py $scd/getHN.py
  ln gitStatusNotif.sh $scd/gitStatusNotif.sh


  echo "Beginning Installation of necessary software"

  installList='kitty '
  installList+='vim '
  installList+='ubuntu-gnome-desktop '
  installList+='gdm3 '
  installList+='okular '
  installList+='gnome-tweaks '
  installList+='python3 '
  installList+='python3-pip '
  installList+='python3-venv '
  installList+='cmake '
  installList+='net-tools '
  installList+='curl '
  installList+='xclip '
  installList+='wine '
  installList+='gimp '
  installList+='wireshark '
  installList+='ffmpeg '
  installList+='vlc '
  installList+='qemu-kvm libvirt-daemon-system libvirt-clients bridge-utils '
  installList+='virt-manager '
  installList+='gnome-shell-extensions '


  sudo apt install -y $installList

  # Brave browser download
  sudo apt install apt-transport-https curl

  sudo curl -fsSLo /usr/share/keyrings/brave-browser-archive-keyring.gpg https://brave-browser-apt-release.s3.brave.com/brave-browser-archive-keyring.gpg

  echo "deb [signed-by=/usr/share/keyrings/brave-browser-archive-keyring.gpg arch=amd64] https://brave-browser-apt-release.s3.brave.com/ stable main"|sudo tee /etc/apt/sources.list.d/brave-browser-release.list

  sudo apt update

  sudo apt install brave-browser

  phase=1
  echo $phase > .config_phase
  sudo reboot
fi

if [ $phase -eq 1 ]; then

  echo "Setting up vim config..."
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

  echo "Setting Gnome config..."
  gnome-shell-extension-tool -e user-themes
  dconf load / < ./gnome_tweaks.dconf

  echo "Setting Cron jobs"
  (crontab -l; echo '1 * * * * $scd/getHN.py'; echo "0 * * * * dconf dump / > $wd/gnome_tweaks.dconf ") | crontab -
  (sudo crontab -l; echo '* 12 * * * apt upgrade') | sudo crontab -
fi

wd=$(pwd)
pf='.config_phase'
phase=0

if [[ -f $pf ]]; then
  phase=$(cat $pf)
  echo "Continuing at phase $phase."
else
  echo $phase > $pf

if [ $phase -eq 0 ]; then

  mv $HOME/.vimrc .vimrc.backup
  mv $HOME/.bashrc .bashrc.backup
  mv $HOME/.config/kitty kittyoldconfig

  ln .vimrc $HOME/.vimrc
  cp .bashrc $HOME/.bashrc

  kd=$HOME/.config/kitty
  mkdir -p $kd/themes

  ln kitty/kitty.conf $kd
  for f in $(ls kitty/themes)
  do
    ln kitty/themes/$f $kd/themes/$f
  done

  sudo cp -r ./Midnight-BlueNight /usr/share/themes
  sudo cp -r ./fantasque /usr/share/fonts

  scd=$HOME/scripts
  mkdir $scd
  ln getHN.py $scd/getHN.py

# Install necessary software

  installList=' '
  installList+='kitty '
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


  "sudo apt install $installList -y"

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
  echo "Configuring Gnome"
  # Configure gnome
  gnome-shell-extension-tool -e user-themes
  # set up necessary jobs
  echo "Loading gnome Tweaks"
  dconf load / < ./gnome_tweaks.dconf
  (crontab -l; echo '1 * * * * $scd/getHN.py'; echo "0 * * * * dconf dump / > $wd/gnome_tweaks.dconf ") | crontab -
  (sudo crontab -l; echo '* 12 * * * apt upgrade') | sudo crontab -
fi

{ config, pkgs, ... }:
{
  imports = [
    ./hardware-configuration.nix
    ./machine.nix

    # VS Code Live Share plugin patch for NixOS
    (builtins.fetchTarball {
      url = "https://github.com/msteen/nixos-vsliveshare/archive/e6ea0b04de290ade028d80d20625a58a3603b8d7.tar.gz";
      sha256 = "12riba9dlchk0cvch2biqnikpbq4vs22gls82pr45c3vzc3vmwq9";
    })
  ];

  #  _____           _                                    _____                 _               
  # |  __ \         | |                            _     / ____|               (_)              
  # | |__) |_ _  ___| | ____ _  __ _  ___  ___   _| |_  | (___   ___ _ ____   ___  ___ ___  ___ 
  # |  ___/ _` |/ __| |/ / _` |/ _` |/ _ \/ __| |_   _|  \___ \ / _ \ '__\ \ / / |/ __/ _ \/ __|
  # | |  | (_| | (__|   < (_| | (_| |  __/\__ \   |_|    ____) |  __/ |   \ V /| | (_|  __/\__ \
  # |_|   \__,_|\___|_|\_\__,_|\__, |\___||___/         |_____/ \___|_|    \_/ |_|\___\___||___/
  #                             __/ |                                                           
  #                            |___/                                                            

  nixpkgs.config.allowUnfree = true; # THE MOST IMPORTANT LINE IN THIS WHOLE FILE lol
  nix.gc = { automatic = true; dates = "05:00"; }; # Garbage collection at 5AM
  system.autoUpgrade.enable = true;
  virtualisation.docker = { enable = true; enableOnBoot = true; };
  virtualisation.virtualbox.host.enable = true;
  services.openssh = { enable = true; passwordAuthentication = false; };
  services.logrotate.enable = true;
  security.pam.enableEcryptfs = true; # Encryption, but not FDE
  # Not being used: services.flatpak.enable = true;
  programs.adb.enable = true; # For Android
  programs.gnupg.agent = { enable = true; enableSSHSupport = true; };
  # programs.zsh.enable = true;
  environment.shells = [ pkgs.zsh pkgs.bashInteractive ];
  services.vsliveshare = {
    enable = true;
    enableWritableWorkaround = true;
    enableDiagnosticsWorkaround = true;
    extensionsDir = "/home/james/.vscode-oss/extensions";
  };
  environment.systemPackages = with pkgs; [
    #   _____ _    _ _____     
    #  / ____| |  | |_   _|    
    # | |  __| |  | | | |  ___ 
    # | | |_ | |  | | | | / __|
    # | |__| | |__| |_| |_\__ \
    #  \_____|\____/|_____|___/

    # Browsers that I'm fine with being slightly out of date
    opera google-chrome google-chrome-beta tor-browser-bundle firefox-devedition-bin
    # Open files
    gimp libreoffice kdeApplications.ark sqlitebrowser vlc
    # Screen capturing (damn, I miss Cmd+Shift+5 from macOS)
    kdeApplications.spectacle peek vokoscreen
    # External connections
    kdeconnect plex-media-player syncthing remmina
    # Programming
    vscodium sublime3 sublime-merge
    # Communication
    skype signal-desktop pavucontrol # "pavucontrol" was needed to get skype to actually work with my mic
    # Games
    minecraft steam (steam.override { extraPkgs = pkgs: [ mono gtk3 gtk3-x11 libgdiplus zlib ]; nativeOnly = true; }).run
    # Misc
    wineWowPackages.full # Windows programs w/o a VM (but also w/o proper scaling)
    baobab # Disk utilization break-down. Nix hardlinks give it angina :/
    libnotify # Provides `notify-send`
    anbox # Android Emulator-ish
    autokey # Save some keystrokes
    partition-manager
    mullvad-vpn

    #   _____ _      _____     
    #  / ____| |    |_   _|    
    # | |    | |      | |  ___ 
    # | |    | |      | | / __|
    # | |____| |____ _| |_\__ \
    #  \_____|______|_____|___/

    # Bare necessities
    curl exfat coreutils file findutils lsof tree wget vim
    # Basic quality-of-life-in-*nix improvements
    bat bc colordiff exa fd fzf htop httpie gitAndTools.diff-so-fancy icdiff jq nanorc progress ripgrep rsync zsh zsh-completions
    # Tools for building things
    autoconf automake cmake binutils gmp gcc gnumake pkg-config

    # Development:
    git git-lfs # Source control
    nodejs python3 # The only interpreters I really need
    docker-compose minikube kubectl # Don't try using k8s directly: https://github.com/NixOS/nixpkgs/issues/71040
    gnupg gnupg1 dirmngr # Not sure if I need any of these (I set programs.gnupg.agent) - TODO: try building from scratch without them
    yarn # UGH

    # Misc
    _1password # CLI for 1Password. Use 1Password X on browsers
    ecryptfs ecryptfs-helper # Encryption, but not FDE
    p7zip unrar unzip # Open archives
    lame libvorbis ffmpeg-full youtube-dl # Simple audio/video tasks
    xclip # Copy + paste from terminal - replace this when switching from X11 to Wayland
    expect # Used for making gpg trust my private key
    thefuck # Quick suggestions to fix things
    tokei # Quick SLoC calculator
    screenfetch # Show off system info
    rclone # Like scp but with support for "the cloud"
    libssh2 libusb # Not sure if I need these anymore - TODO: try building from scratch without them
    cifs-utils # For sharing between windows and linux

    # Things I installed, thought were cool, but don't really use at the moment:
    # asciinema diskus dpkg hexyl magic-wormhole moreutils ngrep nmap tldr

    # For stress-testing overclocks:
    lm_sensors # s-tui stress stress-ng

    # Rails development :/
    ruby solargraph # bundix foreman bundler
    
    # Databases
    mycli # mysql postgresql mysql-workbench

    # Bluetooth-by-hand
    bluez bluez-tools blueman

    # To get the latest version of a specific package, you can use something like this:
    # (import (fetchFromGitHub {
    #   owner = "NixOS";
    #   repo = "nixpkgs";
    #   rev = "d793d53b0d829090b8a38b14384dfcaae9ab1ae5";
    #   sha256 = "09pz7wkk4w4kwifzwdjwxpqdqqb8g1nd2i4kwdlx8jg8ydb44pm8";
    # }) {
    #   config.allowUnfree = true;
    # }).firefox-devedition-bin
  ];

  #   _____             __ _       
  #  / ____|           / _(_)      
  # | |     ___  _ __ | |_ _  __ _ 
  # | |    / _ \| '_ \|  _| |/ _` |
  # | |___| (_) | | | | | | | (_| |
  #  \_____\___/|_| |_|_| |_|\__, |
  #                           __/ |
  #                          |___/   

  # Open ports in the firewall.
  networking.firewall.allowedTCPPorts = [
    # "KDE Connect uses dynamic ports in the range 1714-1764 for UDP and TCP"
    1714 1715 1716 1717 1718 1719 1720 1721 1722 1723 1724 1725 1726 1727 1728 1729 1730 1731 1732 1733 1734 1735 1736 1737 1738 1739 1740 1741 1742 1743 1744 1745 1746 1747 1748 1749 1750 1751 1752 1753 1754 1755 1756 1757 1758 1759 1760 1761 1762 1763 1764
    8080 # For testing things
    22000 # Syncthing
  ];
  networking.firewall.allowedUDPPorts = [
    # Also for KDE Connect
    1714 1715 1716 1717 1718 1719 1720 1721 1722 1723 1724 1725 1726 1727 1728 1729 1730 1731 1732 1733 1734 1735 1736 1737 1738 1739 1740 1741 1742 1743 1744 1745 1746 1747 1748 1749 1750 1751 1752 1753 1754 1755 1756 1757 1758 1759 1760 1761 1762 1763 1764
  ];
  # networking.firewall.enable = false;

  # networking.wireless.enable = true; # wpa_supplicant
  networking.networkmanager.enable = true;

  # Set time zone
  time.timeZone = "America/Chicago";

  system.stateVersion = "19.09";

  # Enable printing via CUPS
  # services.printing.enable = true;

  # Enable sound and bluetooth
  sound.enable = true;
  hardware.bluetooth.enable = true;
  hardware.pulseaudio = {
    enable = true;
    package = pkgs.pulseaudioFull;
    support32Bit = true;
  };

  # Enable touchpad support:
  services.xserver.libinput.enable = true;

  # Enable X11
  services.xserver = {
    enable = true;
    layout = "us";
    xkbOptions = "caps:escape, shift:both_capslock";
  };
  hardware.opengl.driSupport32Bit = true;

  # Enable KDE
  services.xserver.displayManager.sddm.enable = true;
  services.xserver.desktopManager.plasma5.enable = true;

  # Fonts
  fonts.fonts = [ pkgs.powerline-fonts pkgs.google-fonts ];

  # Select internationalisation properties
  i18n = {
    consoleFont = "Lat2-Terminus16";
    consoleKeyMap = "us";
    defaultLocale = "en_US.UTF-8";
  };

  # Create default user accounts
  users.users.james = {
    initialPassword = "test";
    isNormalUser = true;
    shell = pkgs.zsh;
    extraGroups = [ "adbusers" "audio" "docker" "networkmanager" "wheel" ];
    openssh.authorizedKeys.keys = [ "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINPSXnK4t2JLa7A9ziIVNt28g2lvSvPK/jSf+kFQINpD ssh@jam" ];
  };
  users.users.victoria = {
    initialPassword = "test";
    isNormalUser = true;
    extraGroups = [ "audio" "networkmanager" ];
  };
  # users.defaultUserShell = pkgs.zsh;
  environment.variables.ZDOTDIR = "/home/james/.config/zsh-james";

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.supportedFilesystems = [ "ecryptfs" ];

  boot.kernel.sysctl = {
    "vm.swappiness" = 10;
    "vm.overcommit_memory" = 1; # For Redis
    "fs.inotify.max_user_watches" = 9999999;
  };

  # Less writes to the SSD than normal, but not to the potentially bad extent of noatime
  fileSystems."/".options = [ "relatime" ];
}

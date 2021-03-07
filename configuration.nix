# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

{
  imports =
    [
      # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.plymouth.enable = true;
  boot.plymouth.theme = "spinner";
  boot.extraModprobeConfig = "
    options bluetooth disable_ertm=1
  ";

  boot.supportedFilesystems = [ "exfat" "ntfs" ];

  networking.hostName = "Swift-SF314-52"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.
  networking.networkmanager.enable = true;

  # Set your time zone.
  time.timeZone = "America/Argentina/Buenos_Aires";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  i18n.defaultLocale = "es_AR.UTF-8";
  console = {
    #   font = "Lat2-Terminus16";
    keyMap = "la-latin1";
  };

  fonts.fontconfig.cache32Bit = true;

  # Enable the X11 windowing system.
  services.xserver.enable = true;

  # Enable the GNOME 3 Desktop Environment.
  services.xserver.displayManager.gdm.enable = true;
  services.xserver.desktopManager.gnome3.enable = true;

  # Configure keymap in X11
  services.xserver.layout = "latam";
  # services.xserver.xkbOptions = "eurosign:e";

  # Enable CUPS to print documents.
  services.printing.enable = true;

  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;
  hardware.pulseaudio.support32Bit = true;

  hardware.opengl.driSupport32Bit = true;

  hardware.bluetooth = {
    enable = true;
    package = pkgs.bluezFull;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  services.xserver.libinput.enable = true;

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.federico = {
    description = "Federico Damián";
    isNormalUser = true;
    extraGroups = [ "networkmanager" "wheel" ]; # Enable ‘sudo’ for the user.
  };

  nixpkgs.config.allowUnfree = true;

  environment.gnome3.excludePackages = with pkgs; with pkgs.gnome3; [
    epiphany
    gnome-connections
  ];

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages =
    with pkgs;
    with pkgs.gitAndTools;
    with pkgs.gnome3;
    with pkgs.gnomeExtensions;
    [
      git
      git-extras
      gh
      google-chrome
      spotify
      retroarch
      tdesktop
      discord
      minecraft

      gsconnect
      impatience
      appindicator

      rnix-lsp
      nixpkgs-fmt

      (vscode-with-extensions.override {
        vscodeExtensions =
          (
            with pkgs.vscode-extensions;
            [
              bbenoist.Nix
              jnoortheen.nix-ide
              matklad.rust-analyzer
              ms-vsliveshare.vsliveshare
            ]
          ) ++ pkgs.vscode-utils.extensionsFromVscodeMarketplace [
            {
              name = "nix-env-selector";
              publisher = "arrterian";
              version = "1.0.2";
              sha256 = "a1efa383f13faa3ded2f213ff8afbc502af9e520fde78806a96d8afece30ff9a";
            }
          ];
      })
    ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  programs.gnupg.agent = {
    enable = true;
    enableSSHSupport = true;
  };

  programs.steam.enable = true;
  hardware.steam-hardware.enable = true;

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  qt5 = {
    enable = true;
    platformTheme = "gnome";
    style = "adwaita";
  };

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.05"; # Did you read the comment?
}

{ pkgs, dmenu_command ? "rofi -show dmenu", userSettings, ... }:

{
  home.packages = with pkgs; [ networkmanager_dmenu networkmanagerapplet ];

  home.file.".config/networkmanager-dmenu/config.ini".text = ''
    [dmenu]
    dmenu_command = ''+dmenu_command+''

    compact = True
    wifi_chars = ▂▄▆█
    list_saved = True

    [editor]
    terminal = ''+userSettings.term+''
    # gui_if_available = <True or False> (Default: True)
  '';
}

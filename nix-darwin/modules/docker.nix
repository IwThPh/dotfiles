{ pkgs, ... }:
{
  home.packages = with pkgs; [
    docker
    docker-buildx
    docker-compose
    colima # colima start --cpu 4 --memory 8 --arch aarch64 --vm-type=vz --vz-rosetta
    lazydocker
  ];
}


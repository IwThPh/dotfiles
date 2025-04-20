{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    docker
    docker-buildx
    docker-compose
    colima # colima start --cpu 4 --memory 8 --arch aarch64 --vm-type=vz --vz-rosetta
    lazydocker
  ];

  home.sessionVariables = {
    DOCKER_HOST = "unix://${config.home.homeDirectory}/.colima/default/docker.sock";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
  };
}


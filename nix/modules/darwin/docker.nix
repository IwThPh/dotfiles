{ pkgs, config, ... }:
{
  home.packages = with pkgs; [
    docker
    docker-buildx
    docker-compose
    colima # colima start --cpu 4 --memory 8 --arch aarch64 --vm-type=vz --vz-rosetta
    lazydocker
  ];

  home.file.".docker/cli-plugins/docker-buildx" = {
    source = "${pkgs.docker-buildx}/libexec/docker/cli-plugins/docker-buildx";
  };

  home.file.".docker/cli-plugins/docker-compose" = {
    source = "${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose";
  };

  home.sessionVariables = {
    DOCKER_HOST = "unix://${config.home.homeDirectory}/.colima/default/docker.sock";
    TESTCONTAINERS_DOCKER_SOCKET_OVERRIDE = "/var/run/docker.sock";
  };
}

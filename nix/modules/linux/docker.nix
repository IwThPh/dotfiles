{ pkgs, ... }:
{
  home.packages = with pkgs; [
    docker
    docker-buildx
    docker-compose
    lazydocker
  ];

  home.file.".docker/cli-plugins/docker-buildx" = {
    source = "${pkgs.docker-buildx}/libexec/docker/cli-plugins/docker-buildx";
  };

  home.file.".docker/cli-plugins/docker-compose" = {
    source = "${pkgs.docker-compose}/libexec/docker/cli-plugins/docker-compose";
  };

  home.sessionVariables = {
    DOCKER_HOST = "unix:///var/run/docker.sock";
  };
}

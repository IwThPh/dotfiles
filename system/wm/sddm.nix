{ pkgs }:

pkgs.stdenv.mkDerivation {
  name = "sddm-theme";
  src = pkgs.fetchgit {
    url = "https://framagit.org/MarianArlt/sddm-sugar-candy.git";
    rev = "2b72ef6c6f720fe0ffde5ea5c7c48152e02f6c4f";
    sha256 = "1db4p2d0k5a6avr7dg9h1r7y9mx711ci5dgwmljqjb8pq5b0a22y";
  };
  installPhase = ''
    mkdir -p $out
    cp -R ./* $out/
  '';
}


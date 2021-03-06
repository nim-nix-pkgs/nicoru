{
  description = ''A new awesome nimble package'';

  inputs.flakeNimbleLib.owner = "riinr";
  inputs.flakeNimbleLib.ref   = "master";
  inputs.flakeNimbleLib.repo  = "nim-flakes-lib";
  inputs.flakeNimbleLib.type  = "github";
  inputs.flakeNimbleLib.inputs.nixpkgs.follows = "nixpkgs";
  
  inputs.src-nicoru-main.flake = false;
  inputs.src-nicoru-main.ref   = "refs/heads/main";
  inputs.src-nicoru-main.owner = "fox0430";
  inputs.src-nicoru-main.repo  = "nicoru";
  inputs.src-nicoru-main.type  = "github";
  
  inputs."syscall".owner = "nim-nix-pkgs";
  inputs."syscall".ref   = "master";
  inputs."syscall".repo  = "syscall";
  inputs."syscall".dir   = "master";
  inputs."syscall".type  = "github";
  inputs."syscall".inputs.nixpkgs.follows = "nixpkgs";
  inputs."syscall".inputs.flakeNimbleLib.follows = "flakeNimbleLib";
  
  outputs = { self, nixpkgs, flakeNimbleLib, ...}@deps:
  let 
    lib  = flakeNimbleLib.lib;
    args = ["self" "nixpkgs" "flakeNimbleLib" "src-nicoru-main"];
    over = if builtins.pathExists ./override.nix 
           then { override = import ./override.nix; }
           else { };
  in lib.mkRefOutput (over // {
    inherit self nixpkgs ;
    src  = deps."src-nicoru-main";
    deps = builtins.removeAttrs deps args;
    meta = builtins.fromJSON (builtins.readFile ./meta.json);
  } );
}
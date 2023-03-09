let
  thiloho = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJbBLdvGb1E4vEpfq8zVAPeZy9yv4S2bxu9lfmYQA8sY thiloho@mainpc";
  users = [ thiloho ];

  mainpc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIK2KK5+fT/ffnxQtbn1dTGfBgudu6y5n+Z63wGOSR77G root@mainpc";
  mainserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsIwEVW/NcahiKDOqcmivKFm1C4RBp+OJICD3Clbgmx root@mainserver";
  systems = [ mainpc mainserver ];
in
{
  "mainpc-root-password.age".publicKeys = [ thiloho mainpc ];
  "mainpc-thiloho-password.age".publicKeys = [ thiloho mainpc ];
  "mainserver-root-password.age".publicKeys = [ thiloho mainserver ];
  "mainserver-thiloho-password.age".publicKeys = [ thiloho mainserver ];
}
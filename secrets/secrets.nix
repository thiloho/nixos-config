let
  thiloho = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJvwRN8uxppJn6qw+p+2oMR3fgd9k5EqiFcE69Wh3K1T thiloho@mainpc";
  users = [ thiloho ];

  mainpc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIFhpS60wuabohLu3RN/iWR+FU2Wr/EKneV7O4HfEwI5S root@mainpc";
  mainserver = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAICsIwEVW/NcahiKDOqcmivKFm1C4RBp+OJICD3Clbgmx root@mainserver";
  systems = [ mainpc mainserver ];
in
{
  "mainpc-root-password.age".publicKeys = [ thiloho mainpc ];
  "mainpc-thiloho-password.age".publicKeys = [ thiloho mainpc ];
  "mainserver-root-password.age".publicKeys = [ thiloho mainserver ];
  "mainserver-thiloho-password.age".publicKeys = [ thiloho mainserver ];
  "mainserver-firefox-syncserver-secrets.age".publicKeys = [ thiloho mainserver ];
  "mainserver-wireguard-private-key.age".publicKeys = [ thiloho mainserver ];
}
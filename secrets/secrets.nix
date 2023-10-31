let
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIHzBBw5pNpuCg1e9cJcQfcxKuTFZ0cleMkEiRZDxE+qQ thiloho@server";
in
{
  "hedgedoc-environment-file.age".publicKeys = [ server ];
  "discord-bot-token.age".publicKeys = [ server ];
}
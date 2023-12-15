let
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN82ukcaWQZcihgh+n0h+ihwTafm64SO1wngibOA6Vro root@server";
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkvr+vT7Ik0fjquxb9xQBfVVWJPgrfC+vJZsyG2V+/G thiloho@pc";
in
{
  "hedgedoc-environment-file.age".publicKeys = [ server pc ];
  "discord-bot-token.age".publicKeys = [ server pc ];
  "todos-environment-file.age".publicKeys = [ server pc ];
  "restic/password.age".publicKeys = [ server pc ];
  "restic/minecraft-environment-file.age".publicKeys = [ server pc ];
  "restic/minecraft-repository.age".publicKeys = [ server pc ];
}

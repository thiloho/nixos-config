let
  server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIN82ukcaWQZcihgh+n0h+ihwTafm64SO1wngibOA6Vro root@server";
  pc = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMkvr+vT7Ik0fjquxb9xQBfVVWJPgrfC+vJZsyG2V+/G thiloho@pc";
in
{
  "hedgedoc-environment-file.age".publicKeys = [ server pc ];
  "discord-bot-token.age".publicKeys = [ server pc ];
  "todos-environment-file.age".publicKeys = [ server pc ];
  "restic/minecraft-password.age".publicKeys = [ server pc ];
  "restic/minecraft-environment-file.age".publicKeys = [ server pc ];
  "restic/minecraft-repository.age".publicKeys = [ server pc ];
  "restic/hedgedoc-password.age".publicKeys = [ server pc ];
  "restic/hedgedoc-environment-file.age".publicKeys = [ server pc ];
  "restic/hedgedoc-repository.age".publicKeys = [ server pc ];
  "restic/todos-password.age".publicKeys = [ server pc ];
  "restic/todos-environment-file.age".publicKeys = [ server pc ];
  "restic/todos-repository.age".publicKeys = [ server pc ];
  "restic/discord-bot-password.age".publicKeys = [ server pc ];
  "restic/discord-bot-environment-file.age".publicKeys = [ server pc ];
  "restic/discord-bot-repository.age".publicKeys = [ server pc ];
}

# SSH

- install openssh

Generate new ssh key

```sh
ssh-keygen -t ed25519
```

- if you want to create a specific key other than default use a diferente name typo: `<user>.<host>.id_ed25519`

## Use different accounts on a single GitLab instance

assign aliases to host in the `~/.ssh/config` file

cofig file:
```
# User1 Account Identity
Host <user_1.gitlab.com>
  Hostname gitlab.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/<example_ssh_key1>

# User2 Account Identity
Host <user_2.gitlab.com>
  Hostname gitlab.com
  PreferredAuthentications publickey
  IdentityFile ~/.ssh/<example_ssh_key2>
```

then to clone the repo change de host name when you use the command
```
git clone git@<user_1.gitlab.com>:gitlab-org/gitlab.git
```

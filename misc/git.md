# 🛠️ Git Configuration (`.gitconfig`)

Detailed documentation explaining how each section and directive in your `~/.gitconfig` works.

---

## 1. 👤 User Identity (`[user]`)

```ini
[user]
    email = 26639314+zeldandev@users.noreply.github.com
    name = zeldandev
```

- **Purpose**: Defines the global default identity (name and email) that gets recorded as the author and committer of every Git commit you create.
- **Privacy Note**: Uses GitHub's `noreply` email address to keep your personal email private in public commit logs.

---

## 2. 🔀 Custom Aliases (`[alias]`)

```ini
[alias]
    logline = log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit
```

- **Usage**: `git logline`
- **How it works**: Displays a highly visual, compact ASCII tree/graph of commit history:
  - **`%Cred%h%Creset`**: Short commit hash in red.
  - **`%C(yellow)%d%Creset`**: Branches, tags, and `HEAD` decorations in yellow.
  - **`%s`**: Commit message.
  - **`%Cgreen(%cr)`**: Relative commit date (e.g., *2 hours ago*) in green.
  - **`%C(bold blue)<%an>`**: Author name in bold blue.

---

## 3. 🏢 Directory Conditional Inclusion (`[includeIf]`)

```ini
[includeIf "gitdir:~/work/"]
    path = ~/work/.gitconfig.work
```

- **How it works**: If you are working inside any repository located under `~/work/` (or its subdirectories), Git automatically loads additional settings from `~/work/.gitconfig.work`.
- **Use Case**: Allows you to keep work and personal Git configurations separate (e.g. using your company email address for repositories under `~/work/` without changing your global `.gitconfig`).

---

## 4. 🌿 Workflow & Automation (`[init]`, `[push]`, `[fetch]`, `[rerere]`)

```ini
[init]
    defaultBranch = main
```
- **How it works**: Sets `main` as the default branch name whenever you run `git init` (replacing legacy `master`).

```ini
[push]
    autoSetupRemote = true
```
- **How it works**: Eliminates the need to run `git push --set-upstream origin <branch>` manually for new local branches. When you run `git push`, Git automatically sets up tracking for `origin/<branch>`.

```ini
[fetch]
    prune = true
```
- **How it works**: Automatically cleans up local references to remote-tracking branches (e.g. `origin/feature-xyz`) that have been deleted from the remote server when you run `git fetch` or `git pull`.

```ini
[rerere]
    enabled = true
```
- **How it works**: Stands for **"Reuse Recorded Resolution"**. When you resolve a merge conflict or rebase conflict, Git records how you solved it. If the exact same conflict occurs again in the future, Git applies your saved resolution automatically.

---

## 5. 💻 Line Ending Normalization (`[core]`)

```ini
[core]
    autocrlf = input
```

- **How it works**: Prevents line ending conflicts between operating systems (Windows `CRLF` vs Linux/macOS `LF`):
  - On **commit**, automatically converts `CRLF` to `LF`.
  - On **checkout**, retains Unix `LF` line endings.

---

## 6. 🎨 Advanced Pager & Syntax Diffs (`[pager]`, `[interactive]`, `[delta]`)

```ini
[pager]
    diff = delta
    log = delta
    reflog = delta
    show = delta

[interactive]
    diffFilter = delta --color-only

[delta]
    navigate = true
    light = false
    side-by-side = true
    line-numbers = true
```

- **Purpose**: Integrates the modern **`git-delta`** tool to replace Git's default pager with high-definition syntax highlighting and side-by-side diff views.
- **Option Details**:
  - **`side-by-side = true`**: Renders code diffs in two parallel columns (old code on the left, new code on the right), similar to GitHub or IDEs.
  - **`line-numbers = true`**: Displays exact line numbers beside diff lines.
  - **`navigate = true`**: In the `less` pager, allows pressing `n` and `N` to jump directly between modified files.
  - **`light = false`**: Optimized for dark terminal color schemes (*Dark Mode*).

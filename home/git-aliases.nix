{
  programs.git.settings.alias = {
    # Basic commands
    a = "add";
    aa = "add --all";
    ap = "add -p";
    cb = "rev-parse --abbrev-ref HEAD";
    d = "diff";
    dc = "diff --cached";
    pf = "pull --ff-only";
    pl = "pull";
    pu = "push";
    puf = "push --force-with-lease";
    pub = "!f() { git push --force-with-lease --set-upstream origin $(git cb); }; f";
    s = "status";
    st = "status";


    # Checkout commands
    co = "checkout";
    nb = "checkout -b";
    sw = "switch";
    swm = "switch master";

    # Commit commands
    c = "commit";
    ca = "commit --amend";
    cam = "commit --amend --no-edit";
    cf = "commit --fixup";
    cm = "commit -m";

    # Rebase commands
    rb = "rebase";
    rba = "rebase --abort";
    rbc = "rebase --continue";
    rbi = "rebase --interactive";
    rbs = "rebase --skip";

    # Reset commands
    r = "reset HEAD";
    r1 = "reset HEAD^";
    r2 = "reset HEAD^^";
    rhard = "reset --hard";
    rhard1 = "reset HEAD^ --hard";
    rhard2 = "reset HEAD^^ --hard";

    # Stash commands
    sd = "stash drop";
    spo = "stash pop";
    spu = "stash push";
    spua = "stash push --all";

    # Other commands
    lsg = "log --graph --abbrev-commit --decorate --format=format:'%C(blue)%h%C(reset) - %C(green)(%ar)%C(reset) %s %C(italic)- %an%C(reset)%C(magenta bold)%d%C(reset)' --all";
    lg = "log --oneline";
    rs = "restore --staged";
    which = "log --pretty=format:'%ad %h %d' --abbrev-commit --date=short -1";
  };
}

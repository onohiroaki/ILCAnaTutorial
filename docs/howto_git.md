# git how to

Please visit git prompt at [https://github.com/andresailer/tutorial](https://github.com/andresailer/tutorial)
for a very helpful information.

## .gitconfig example 
```
[user]
        name = <user name>      # your name
        email = <mail address>  # e-mail address
[alias]
        st = status
        ci = commit
        co = checkout
        lola = log --graph --decorate=full\n--pretty=oneline --abbrev-commit --all
        logf = "!echo \"Remember to add -S<string>\" ; git log --color -p --source --all"
        date = log --graph --pretty=format:'%C(yellow)%h%Creset %C(cyan)%ad%Creset%C(green)%d%Creset %s' --date=format:'%Y
/%m/%d %H:%M:%S'

[color]
        ui = true
        diff = auto
        status = auto
[core]
        excludesfile = <home directory>/.gitignore_global  
        editor = vim
[branch]
        autosetuprebase = always
[push]
        ## for newer versions of git, otherwise try "simple"
        default = matching

```
`<user name>`, `<mail address>` and `<home directory>` are your name, your mail address and home directory, 
respectively. 


<!-- ## BashCompletion and GitPrompt  -->




## Checkout one directory from git repository

An example to checkout `docs` directory from this repository
to the current directory;

```
( git init && cd .git && git config core.sparsecheckout true )
echo "docs/" >> .git/info/sparse-checkout
git remote add origin https://github.com/akiyamiyamoto/Tutorial.git
git pull origin master
git read-tree -m -u HEAD
```

## Download one of the directory using svn command.

* List directory 
```
$ svn ls https://github.com/akiyamiyamoto/Tutorial

$ svn ls https://github.com/akiyamiyamoto/Tutorial/trunk
```
* Download one directory ( docs directory )
```
$ svn export https://github.com/akiyamiyamoto/Tutorial/trunk/docs
```

* Download one file ( this file )
```
$ svn export https://github.com/akiyamiyamoto/Tutorial/trunk/docs/howto_git.md
```



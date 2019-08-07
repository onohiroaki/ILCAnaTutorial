# git how to

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



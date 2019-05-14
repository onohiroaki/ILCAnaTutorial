# git how to

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



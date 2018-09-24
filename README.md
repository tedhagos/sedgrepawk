# Introduction to grep, sed and awk

You already know how to use this. At least instinctively. 

`grep user /etc/passwd` - will scan the entire file of _/etc/passwd_ and find any line that matches `user`, which in this case is a regular expression. 

**NOTE**:  it might be better if you use `grep --color=auto` rather than just regular `grep`, so you can see the matching expression easily. You can alias this in your bashrc file

Now, try `grep User /etc/passwd`. What results did you get

Next, try `grep '[Uu]ser' /etc/passwd`. What results did you get? What if we used `grep '[a-zA-Z]ser' /etc/passwd`

Another example;

Let's use the `declare` utilty, if you run this command, you'll see all the functions that are defined in the system (including functions you created on your own and are part of the login script). You'll see the name of the function and the definition. If we use `declare -F`, we'll get only the names of the function, like this

```
declare -f rvm
declare -f rvm_debug
declare -f rvm_debug_stream
declare -f rvm_error
declare -f rvm_error_help
declare -f rvm_fail
declare -f rvm_help
declare -f rvm_install_gpg_setup
declare -f rvm_is_a_shell_function
declare -f rvm_log
declare -f rvm_notify
```

But, annoyingly, the `declare -f` is still included in. To get rid of that, you can try the command `declare -f | grep '[a-z_]'`.  Now, we get this

```
rvm () 
rvm_debug () 
rvm_debug_stream () 
rvm_error () 
rvm_error_help () 
rvm_fail () 
rvm_help () 
rvm_install_gpg_setup () 
rvm_is_a_shell_function () 
rvm_log () 
rvm_notify () 
```

**Some examples of sed**

`sed 'p' /etc/man.conf` ,  it should just print the entire contentst of "man .conf", but you'll see every line  of it printed twice. It prints the pattern, then it prints the output of the pattern. So, to suppress the output, we can use the command `sed -n 'p' /etc/man.conf`.  So, in this  command, `'p'` is a command, it means "print".  

If we use the command `sed -n '/^#/  p' /etc/man.conf`. What does this mean? We know `p` means print, but we've got some new things int the expression; `/^#/` is a pattern, everything in between the slashes is a pattern. What we're looking for is are all lines that begin with the pound sign; and we want to print it.  

`sed '/^#/  d' /etc/man.conf` - this will delete all the lines that starts with a pound sign

`sed -n '/^#/  ;/^$/' /etc/man.conf` - this will delete all the blank lines. The caret symbol, as you will remember, means "starts with" and the dollar symbol means "ends with". Since there are no characters between the "starts with " and "ends witht" pattern, we're looking for for a blank line. The semi-colon is used to join the two regular expressions. It's how you make a compound expression.

**Some examples of awk**

Awk is the third tool we'll look at, it's also the most powerful among the three. You can use awk like this

`awk { print } /etc/man.conf`. It will simply print all contents of "man.conf" line per line.  Awk command can be this short, it can also be this long

```bash
awk 'BEGIN {print "Hello"} {print} END {print NR}' /etc/man.conf
```

We can also pipe it.

`ifconfig eth0 | awk -F":" '/HWaddr/{print $3 $4 $5}'`. This print out the mac or hardware address of eth0. If you're on a mac, you should use this

```bash
ifconfig en1 | awk -F":" '/ether/{print $3 $4 $5}
```

To try out another example, we can type the command

` ls -l | awk '/[a-zA-Z]/ {print $9 }'` which will print only filenames column of the `ls -l` command

# grep

It means **G**lobal **R**egular **E**xpression **P**rint. It's a text search utility used from the command line to globally search a file or STDIN for an given regular expression. It will print matching lines to STDOUT.

`grep 'regular expression' <which files to search>`

We can also use it like this

`<command> | grep 'regular expression'`

Some examples

* `grep 'user' /var/log/system.log` - searches for the the line which matches the pattern `user` in a specific file
* `grep -i 'user' /var/log/system.log` - same as above, but the _-i_ makes the expression case-insensitive
* `grep `user` /var/log/*` - same as above, but it searches for the pattern in all the files under /var/log 
* `ifconfig eth0 | grep 'active'` - tries to see the active status of eth0

**NOTE**:  This tutorial has a Github repo. The sample files uses in this tutorial are in the repo. You should download all of it if you want to follow the examples. There are 3 sample files in the repo, *autofs.conf, man.conf* and *sample1.txt*.

# regular expressions

*What is it*? It's a sequence of symbols and characters expressing a string or pattern to be matched within a longer string. For example;

```bash
\b[Cc]olou?r\b
```

This regular expression is designed to match the word(s) Color, Colour, color or colour, where;

* `\b` means a word boundary
* `[Cc]` is the range specifier. We don't mind if the word begins in lowercase or uppercase
* `u?` means the _u_ character is optional. We don't care if it's the American or English spelling

## anchors

`^The` - matches any string that starts with "The"

`bank$` - matches any string that ends with "bank"

`^The bank$ ` - matches any string that begins with "The" and ends with "bank"

`quick` - matches any srting that has the word "quick" in it

For example, the command `grep '^$' autofs.conf'` will display all the blank lines. But if I want to see all non-blank lines, we can instead say

```bash
grep -v '^$' autofs.conf
```

The _-v_ means, we want the reverse (think of it like the logical unary  _not_ operator)

## ranges

`[a-z]` - We're looking for any combination of lowercase letters

`[A-Z]` - We're looking for any combination of uppercase letters

`[a-zA-Z]` - We're looking for a combination of any letter, regardless of case

`[0-9]` - This will match any digit

`[349]` - will match either 3,4 or 9. It will also match 349 because 349 includes all the digits in the expression

Examples;

`declare -f | grep '^[_]'` - shows all the functions that starts with the underscore character.

`declare -f | grep '^[a-z_]'` - shows all the functions that start with any lowercase character or underscore

## quantifiers









*example 1. contents of sample1.txt*

```bash
the quick brown fox jumped over the head of lazy dog.
THE QUICK BROWN FOX JUMPED OVER THE HEAD OF THE LAZY DOG.
The Quick Brown Fox Jumped over The Head Of The Lazy Dog.
```

`grep the sample1.txt` will give the following results

```
the quick brown fox jumped over the head of lazy dog.
```

`grep THE sample1.txt` will output

```
THE QUICK BROWN FOX JUMPED OVER THE HEAD OF THE LAZY DOG.
```

`grep The sample1.txt` will output

```
The Quick Brown Fox Jumped over The Head Of The Lazy Dog.
```

Why.

What's grep, why is it useful

What's sed. 

What's awk

## grep







## sed







## awk







https://medium.com/factory-mind/regex-tutorial-a-simple-cheatsheet-by-examples-649dc1c3f285







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

`grep 'rotate [46]$' /etc/logrotate.d/*` - will show all the files in /etc/logrotate.d/ that has 4 or 6 in its ending

`grep 'rotate [^4]$' /etc/logrotate.d/*` - will match every file that has 'rotate' in its ending but we don't want the 4 (everything else but the 4)

`grep '[Ss]erver' /etc/hosts.allow` - What do you think this does?

## boundaries

`\s` represents whitespace (line return, tab or just plain whitespace)

`\b` a word boundary, might be a space but could also be hypen.

`\S` - Not a white space (revers of \s)

`\B` not a word boundary (reverse \b)

`\ssystem` will match "file system"

`\bsystem` will match "file system" and "file-system"

Examples;

`grep server  /etc/ntp.conf.bak` will match lines that has "server" and "servers". If you want to exclude the lines with "servers" (plural), put a word boundary on the regular expression, like this.

`grep 'server\b' /etc/ntp.conf.bak`  - this will exclude the lines that has the plural "servers"

`grep 'server\S' /etc/ntp.conf.bak` - this command on the other hand, will only the show the lines that the "servers" (plural)

## quantifiers

`a*` matches zero or more _a_ 

`a?` matches zero _a_ or once only

`a+` matches one or more occurences

`a{2}` matches exactly 3 _a_ characters

Now, some examples;

`grep '^\s#' /vagrant/Vagrantfile` - will show all the commented lines (the ones with a pound sign)

`grep -v '^\s#' /vagrant/Vagrantfile` - will show only the lines that are not commented

# sed

*sed* is a non-interactive stream batch editor. It works with streams e.g. STDIN or when a file is read into memory, it's treated as a stream. You can do text transformations with _sed_.

`sed -n 'p' sample2` - prints out each line in our sample2 file (-n means suppress the output, only show the pattern. We don't have a pattern, so it shows everything)

`sed -n '1,5 p' sample2` - prints lines 1-5 of sample2

`sed -n '5,$ p' sample2` - prints from line 5 up until the end of the doc

`sed -n '/^a/ p' sample2` - prints all the lines that starts with letter _a_

`sed -n '/^a[0-9]/ p' sample2` prints all the lines that start with _a_ followed by digits

### substitute command

When you want to replace a specific string occurence with something. The command is as follows

```bash
sed '[range] s/<string>/<replacement>/' file
```

The command `sed s/start/bleh/ sample2` will replace all the occurences of the word "start" with "bleh" in the sample2 file. But this will only print in STDOUT, it won't actually change the file sample2.

For example, let's consider the _pythonsample.py_ file (shown below)

```python
count = 0
while True:
print(count)
count += 1
if count >= 5:
break
```

It's a botched program, because it doesn't have any indentations (Python is a stickler for indents).  Just looking at the program, the codes after _while_ should be indented; also the codes after _if_ should be indented.  Let's print this out in the terminal and show their line numbers. You can do that with this command `nl pythonsample.py`, which shows the following output.

```python
     1	count = 0
     2	while True:
     3	print(count)
     4	count += 1
     5	if count >= 5:
     6	break
```

We should indent lines 3-5 by 4 spaces, and then line 6 by 8 spaces.  

```bash
sed '3,5 s/^/    /g' pythonsample.py
```

This results in the following file

```python
count = 0
while True:
    print(count)
    count += 1
    if count >= 5:
break

```

Of course, these changes aren't written permanently to the pythonsample file. To make the changes permanent, we can redirect the output of the _sed_ command to the python file, like this

```bash
sed '3,5 s/^/    /g' pythonsample.py > pythonsample.py
```

Or we can use the `-i` directive, like this

```bash
sed -i.bak '3,5 s/^/    /g' pythonsample.py
```

We still have to fix line number 6, it needs to be indented 8 spaces; I'll leave this to you for a small exercise.

## Appending

You can also use sed to append entries to files. Let's see the following example. 

```bash
 sed -n '/^server  3/ p' ntp.conf
```

It should give us the following output

```bash
server  3.us.pool.ntp.org               iburst
```

If we wanted to append a line after "server  3", we can manage it with this command

```bash
sed '/^server  3/ a server  ntp.example.com' ntp.conf | more
```

The `| more` command is there just so we can see the results before it scrolls out of the screen. Again, this isn't permanent and won't be written back to the file; so, let's make it permanent.

```bash
sed -i.bak '/^server  3/ a server  ntp.example.com' ntp.conf
```

If we use the _i_ command instead of _a_,  instead of "ntp.example.com" being written after "server. 3", it will be written before it. Try it out.

```bash
sed '/^server  3/ i server  ntp.example.com' ntp.conf | more
```

If we wanted to delete some entries from the file ntp.conf, say, we wanted to delete servers 0-3, we can do it like this

```bash
sed '/^server\s [0-9]\./ d' ntp.conf | more
```

## Multiple sed commands

You can combine sed commands (interactively) using curly braces, like this

```sed
sed '{
   3,5  s/^/    g 
   6    s/^/    g 
}' pythonsample.py
```

Or we can put these commands in control file (a program).  Let's say we have a file called "pythonsample.sed"; it doesn't matter what the name of the file is, we don't even have to put the "sed" extension, the name serves a practical purpose (for us to remember it easily), there is no technical reason for the file to be named like that. We can put the following commands in it.

```sed
3,5  s/^/    g
6    s/^/    g 
```

To execute this, we can use the command

```bash
sed -f pythonsample.sed pythonsample.py
```

This results into

```python
count = 0
while True:
    print(count)
    count += 1
    if count >= 5:
        break
```

Now, all you have to do is to make the change permanent in the file. Use the `-i` or `--in-place` option in the `sed` command to write the changes to the file.

# awk

AWK stands for Aho Weinberger and Kernighan, these were the 3 people responsible for creating the awk programming language. It was primarily designed for text processing (parsing files and generating reports).

Awk programs are simple, it's made up of _rules_. A rule is made up of a _pattern_ and a set of_actions_.  Awk programs/invocations generally looks like this

```bash
awk '{print}' etc/man.conf
```

The above example shows how to invoke awk on the command line (interactively).  Later, we'll see how to put awk commands in a control file or a program file.  In the example code above, we only have one statement inside the main block of the program; `print`. This command will be applied to all the lines in our input file because we did not specify any pattern or condition.  

When the program is ran, each line will be parsed and the rule will be applied to each line. In the previous code sample, our rule doesn' t have a pattern, it only has an action. When there is no pattern on the rule, the action is applied to _all_ the lines in the input file.

Another basic example is as follows

```bash
awk '/produce/ {print}' groceries.txt
```

Now we have a pattern and action on the awk command. As you can see, we specify the pattern as a regular expressions (same as grep and sed). Now, our program will only print the lines which matches the pattern.

By default, awk prints the entire line. If we wanted to print a specific field, we can do so by using field specifiers. For example

```bash
awk '/produce/ {print $2}' groceries.txt
```

The code above prints only the second column.

_exercise:_ try printing `$0` or `$1`

Let's start saving our awk programs into a control file e.g. _sample.awk_

_sample.awk_

```aw
BEGIN { print "Hello sample"} # (1)
# This is a comment

/produce/ {print $0}          # (2)
/groceries/ {print}           # (3)

END {print "TOTAL RECORDS : "  NR}  # (4)
```

We can run this command with `awk -f sample.awk groceries.txt`.  

**(1)** This is an optional BEGIN section.  When there is BEGIN section, it's block gets executed _only_ once.

**(2)** The first rule in our program. It searches for the string pattern _produce_, if it ther is a match, the whole line is printed; `$0` means the whole line

**(3)** Second rule in the program. It searches for the string pattern _groceries_, if it is found, the whole line is printed. We don't have to specify `$0` if we want to print the whole line, that's the default of the `print` command

**(4)** This is an END block. Like BEGIN, if it's found, it gets executed only once. So, it's good for printing summaries. The `NR` variable stands for _number of records_.

**Field Separator**

















https://likegeeks.com/awk-command/

https://www.gnu.org/software/gawk/manual/gawk.html#Getting-Started

https://www.tutorialspoint.com/awk/awk_string_concatenation_operator.htm

https://www.youtube.com/watch?v=u8RXKFTekqw



















## 







https://medium.com/factory-mind/regex-tutorial-a-simple-cheatsheet-by-examples-649dc1c3f285








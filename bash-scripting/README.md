# Bash Scripting
Welcome to the Bash Scripting section of the devops-learning repository. 
This folder contains a collection of practical automation scripts.

#  Contents
1.Levels/
-⚔️The Bash Battle Arena – A 15-level challenge series.
There are 15 scripts each for one level.

2.core-chellenges
a)Arithmetic-Calculator.sh
b)File_Operations.sh
c)backup_txt_files.sh 
d)check_file_permissions.sh
 
 
 ** Why Bash Matters in Devops **

1️⃣ Automate repetitive tasks.
From spinning up servers to running backups or deploying code, Bash does it in one script.

2️⃣ Scripts don’t get tired or forget steps, making deployments and maintenance more reliable.

3️⃣  Less typing and save time by avoiding errors and unnecessary debugging.

4️⃣ Learn Bash once, and it’s applicable across Linux servers, cloud VMs, Docker containers, and CI/CD pipelines.

**Key Learnings **

1. ls -Sr - displays list of files sorted from smallest to biggest
2. grep -l - displays names of files if they contain a specific string.
3. inotifywait -m - moniters a directory for changes
4. tar --create --gzip --file=$DESTDIR$FILENAME $SRCDIR --> Can be used to backup a directory.
5. The case command is a conditional statement that matches a variable against multiple patterns and runs the code for the first matching pattern. It’s cleaner and more readable than using many if-elif statements.

** Chellenge I overcame **

# The Confusion
Part of the task was to ensure that the script keeps only  the **5 most recent backups**.

When I ran the `ls` command, the output looked like a table of files  
instead of each file being listed line by line.

This sent me down a rabbit hole:  “How do I ignore specific positions  in a table?”

# The Realization
The output was still a stream of filenames separated by lines.

Once I realized this, I understood that using a command (tail -n +6), which skips the first few lines
of output when printing, solves the problem.

# Key Takeaways
- The way output is displayed in the terminal is not alwyas how it’s processed by commands
- When researching, providing all relevant context matters  
  ❌ “How to print files other than first 5 files”  
  ✅ “How to skip the first few files  
     after an `ls` command”




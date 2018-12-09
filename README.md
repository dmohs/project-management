# Project Management Tools

- I have some code in some language.
- I need to perform various tasks with this code (e.g., compile, deploy).
- I want to write scripts to do these tasks to make them easier and document them.
- I do not want to write these scripts in bash.

Enter this package. Start by:

```bash
curl https://raw.githubusercontent.com/dmohs/project-management/master/project.rb -O && chmod +x project.rb
```

There are two modes of operation: Single script and project scripts. Single script mode (the default) just means that the script is self-contained. Run:
```bash
./project.rb
```
...then modify and iterate.

Project scripts mode expects a collection of scripts read from a scripts directory. Add scripts/tasks to your dev scripts directory a la https://github.com/dmohs/project-management/blob/master/src/dev/scripts/foo.rb:

```bash
mkdir -p src/dev/scripts
curl https://raw.githubusercontent.com/dmohs/project-management/master/src/dev/scripts/foo.rb > src/dev/scripts/foo.rb
```

Modify `project.rb` to use these scripts as directed by the comments in that file.

Finally, try out the sample task:
```bash
./project.rb # show help
./project.rb foo # run the task
./project.rb foo --help # show task help
```

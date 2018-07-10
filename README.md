# Project Management Tools

- I have some code in some language.
- I need to perform various tasks with this code (e.g., compile, deploy).
- I want to write scripts to do these tasks to make them easier and document them.
- I do not want to write these scripts in bash.

Enter this package. Start by:

```bash
curl https://raw.githubusercontent.com/dmohs/project-management/master/project.rb -O && chmod +x project.rb
```

Now add tasks to the `libproject` folder a la https://github.com/dmohs/project-management/blob/master/libproject/foo.rb:

```bash
mkdir libproject
curl https://raw.githubusercontent.com/dmohs/project-management/master/libproject/foo.rb > libproject/foo.rb
```

Finally, try out the task:
```bash
./project.rb # show help
./project.rb foo # run the task
```

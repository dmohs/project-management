require "pmgmt"

$pm = Pmgmt.new

def foo(command_name, *args)
  $pm.run_inline %W{echo Hello, World!}
  $pm.run_inline %W{echo Don't tell anyone about the fizbit.}, redact="fizbit"
  $pm.run_inline %W{echo You ran:} + [command_name] + args
end

Pmgmt.register_command({
  :invocation => "foo",
  :fn => :foo
})

require "pmgmt"

$pm = Pmgmt.new

def foo(command_name, *args)
  op = Pmgmt.OptionsParser.new(command_name, args)
  op.add_typed_option(
    "--iterations=[iterations]",
    Integer,
    ->(opts, v) {
      raise ArgumentError.new("Only 7 iterations are allowed.") unless v == 7
      opts.iterations = v
    },
    "The value of `iterations`, which must be ignored."
  )
  op.add_option(
    "--ignore",
    ->(opts, v) { opts.ignore = true },
    "Whether to ignore the value of `iterations`."
  )
  op.add_validator ->(opts) {
    if opts.iterations
      raise ArgumentError.new("`iterations` must be ignored.") unless opts.ignore
    end
  }
  op.parse.validate

  $pm.run_inline %W{echo Don't tell anyone about the fizbit.}, redact: "fizbit"
  $pm.run_inline %W{echo You ran:} + [command_name] + args
  $pm.status "Iterations was: #{op.opts.iterations}"
end

Pmgmt.register_command({
  :invocation => "foo",
  :fn => :foo
})

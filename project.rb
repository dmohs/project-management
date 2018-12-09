#!/usr/bin/env ruby -w

def apply_dev_mode()
  $:.unshift "./lib"
  STDERR.puts "\nWARNING: Dev mode---installed gem ignored.\n\n"
end

# Uncomment during development:
# apply_dev_mode

begin
  require "pmgmt"
rescue LoadError
  install_cmd = "gem install pmgmt --version 1.1.0"
  STDERR.puts "+ #{install_cmd}"
  system install_cmd
  unless $?.success?
    exit $?.exitstatus
  end
  Gem.clear_paths
  require "pmgmt"
  STDERR.puts "---"
end

##
## Mode 1: Single script
## "I want to quickly automate a single task."
##

$pm = Pmgmt.new

def foo(command_name, *args)
  $pm.run_inline %W{echo You ran:} + [command_name] + args
end

foo $0, *ARGV

###
### Mode 2: Project scripts directory
### "I'm working on a project and need several scripts for various tasks."
###

# Pmgmt.load_scripts("./src/dev/scripts")
# Pmgmt.handle_or_die ARGV

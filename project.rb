#!/usr/bin/env ruby -w

begin
  require "pmgmt"
rescue LoadError
  install_cmd = "gem install pmgmt --version 1.0.0"
  STDERR.puts "+ #{install_cmd}"
  system install_cmd
  unless $?.success?
    exit $?.exitstatus
  end
  Gem.clear_paths
  require "pmgmt"
  STDERR.puts "---"
end

Pmgmt.load_scripts("./libproject")

Pmgmt.handle_or_die ARGV

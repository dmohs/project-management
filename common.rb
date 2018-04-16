require "open3"
require "ostruct"
require "yaml"

require_relative "dockerhelper"
require_relative "syncfiles"

class Common
  @@commands = []

  def Common.register_command(command)
    @@commands.push(command)
  end

  def Common.unregister_upgrade_self_command()
    @@commands.reject! { |x| x[:upgrade_self_command] }
  end

  def Common.commands()
    @@commands
  end

  attr :docker
  attr :sf

  def initialize()
    @docker = DockerHelper.new(self)
    @sf = SyncFiles.new(self)
  end

  def print_usage()
    STDERR.puts "\nUsage: ./project.rb <command> <options>\n\n"
    STDERR.puts "COMMANDS\n\n"
    @@commands.each do |command|
      STDERR.puts bold_term_text(command[:invocation])
      STDERR.puts command[:description] || "(no description specified)"
      STDERR.puts
    end
  end

  def handle_or_die(command, *args)
    handler = @@commands.select{ |x| x[:invocation] == command }.first
    if handler.nil?
      error "#{command} command not found."
      exit 1
    end

    handler[:fn].call(*args)
  end

  def load_env()
    if not File.exists?("project.yaml")
      error "Missing project.yaml"
      exit 1
    end
    OpenStruct.new YAML.load(File.read("project.yaml"))
  end

  def red_term_text(text)
    "\033[0;31m#{text}\033[0m"
  end

  def blue_term_text(text)
    "\033[0;36m#{text}\033[0m"
  end

  def yellow_term_text(text)
    "\033[0;33m#{text}\033[0m"
  end

  def bold_term_text(text)
    "\033[1m#{text}\033[0m"
  end

  def status(text)
    STDERR.puts blue_term_text(text)
  end

  def warning(text)
    STDERR.puts yellow_term_text(text)
  end

  def error(text)
    STDERR.puts red_term_text(text)
  end

  def put_command(cmd, redact=nil)
    if cmd.is_a?(String)
      command_string = "+ #{cmd}"
    else
      command_string = "+ #{cmd.join(" ")}"
    end
    command_to_echo = command_string.clone
    if redact
      command_to_echo.sub! redact, "*" * redact.length
    end
    STDERR.puts command_to_echo
  end

  def capture_stdout(cmd)
    output, _ = Open3.capture2(*cmd)
    output
  end

  def run_inline(cmd, redact=nil)
    put_command(cmd, redact)

    # `system`, by design (?!), hides stderr when the command fails.
    if ENV["PROJECTRB_USE_SYSTEM"] == "true"
      if not system(*cmd)
        exit $?.exitstatus
      end
    else
      pid = spawn(*cmd)
      Process.wait pid
      if $?.exited?
        if !$?.success?
          exit $?.exitstatus
        end
      else
        error "Command exited abnormally."
        exit 1
      end
    end
  end

  def run_inline_swallowing_interrupt(cmd)
    begin
      run_inline cmd
    rescue Interrupt
    end
  end

  def run_or_fail(cmd, redact=nil)
    put_command(cmd, redact)
    Open3.popen3(*cmd) do |i, o, e, t|
      i.close
      if not t.value.success?
        STDERR.write red_term_text(e.read)
        exit t.value.exitstatus
      end
    end
  end

  def run(cmd)
    Open3.popen3(*cmd) do |i, o, e, t|
      i.close
      t.value
    end
  end

  def pipe(*cmds)
    s = cmds.map { |x| x.join(" ") }
    s = s.join(" | ")
    STDERR.puts "+ #{s}"
    Open3.pipeline(*cmds).each do |status|
      unless status.success?
        error "Piped command failed"
        exit 1
      end
    end
  end
end

def upgrade_self()
  c = Common.new
  Dir.chdir(File.dirname(__FILE__)) do
    c.run_inline %W{git pull}
  end
  c.status "Tools upgraded to latest version."
end

Common.register_command({
  :invocation => "upgrade-self",
  :description => "Upgrades this project tool to the latest version.",
  :fn => lambda { |*args| upgrade_self(*args) },
  :upgrade_self_command => true,
})

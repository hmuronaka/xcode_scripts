#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

require 'yaml'

COMMAND_PATH=File.expand_path("~/.xc_commands", __FILE__)

def load_command
  load_command_with_path(COMMAND_PATH)
end

def load_command_with_path(yaml_path)
  commands = []
  begin
    str = File.read(yaml_path)
    commands = YAML.load(str)
  rescue => e
  end

  commands
end

def add_command(name)
  commands = load_command

  if commands.include?(name)
    STDERR.puts "#{name} is already commandized."
    return false
  end

  if is_command_exists? (name)
    STDERR.puts "#{name} is an existence command."
    return false
  end
  commands << name

  save_command(commands)
  return true
end

def is_command_exists?(name)
  `type #{name}`
  return $? == 0
end

def save_commands(commands)
  save_commands_with_path(commands, COMMAND_PATH)
end

def save_commands_with_path(commands, path)

  File.open(path, 'w') do |f|
    f.write commands.to_yaml
  end

end

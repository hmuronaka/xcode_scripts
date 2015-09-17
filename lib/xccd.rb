#!/usr/bin/ruby
#
$:.unshift File.dirname(__FILE__)

require_relative './xc_script.rb'
require_relative './xc_config.rb'

def main
  config = load_config

  exit(1) unless parse_args(ARGV, config)

  project_path = ""
  project_name = ""
  if config[:project_name].nil?
    STDERR.puts "choose a project from history."
    history = ask_open_project_from_histories
    project_path = history[:path]
    project_name = history[:project_name]
  else
    project_path = resolve_project_path(
      config[:project_name],
      config[:search_paths],
      config[:exclude_paths],
      config[:search_depth],
      use_cache: true
    )
    project_name = config[:project_name]
  end

  exit(1) if project_path.empty?

  change_dir(Pathname(project_path).parent)

  if project_name != "."
    record_history(
      project_name,
      project_path,
      config[:history_num]
    )
  end

end

def parse_args(argv, config)
  if argv.length == 0
    config[:project_name] = nil
    return true
  elsif argv.length == 1
    config[:project_name] = argv[0]
    return true
  else
    usage(:illegal_arguments)
    return false
  end
end

def usage(error_sym)
  case error_sym
  when :illegal_arguments
    STDERR.puts "Usage: xccd <projectname>"
    STDERR.puts ""
    STDERR.puts "Options:"
    STDERR.puts "\tprojectname: xcode project name or project name with extension. like MyProject, MyProject.xcworkspace"
  end
end

def change_dir(dir)
  puts dir
end

main


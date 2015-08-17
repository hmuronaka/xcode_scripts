#!/usr/bin/ruby
#
$:.unshift File.dirname(__FILE__)

require_relative './xc_script.rb'

def main
  config = load_config

  exit(1) unless parse_args(ARGV, config)

  project_path = resolve_project_path(
    config[:project_name],
    config[:search_paths],
    config[:exclude_paths],
    config[:search_depth]
  )

  change_dir(Pathname(project_path).parent)
end

def parse_args(argv, config)
  if argv.length == 0
    usage(:illegal_arguments)
    return false
  end

  config[:project_name] = argv[0]
  return true
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


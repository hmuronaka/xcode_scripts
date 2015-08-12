#!/usr/bin/ruby
#
$:.unshift File.dirname(__FILE__)

require 'xc_script.rb'

PARAMS = {
  project_name: "",
  search_paths: ["~/src/plusadd/"],
  exclude_paths: [".git", "Pods"]
}

def main
  exit(1) unless parse_args(ARGV)

  project_path = resolve_project_path(
    PARAMS[:project_name],
    PARAMS[:search_paths],
    PARAMS[:exclude_paths])

  change_dir(Pathname(project_path).parent)
end

def parse_args(argv)
  if argv.length == 0
    usage(:illegal_arguments)
    return false
  end

  PARAMS[:project_name] = argv[0]
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


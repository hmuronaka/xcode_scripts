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
      config
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
  end

  arg = argv.shift

  if arg == "--help"
    usage :help
    return
  end

  if arg == "--use-index"
    config[:use_index] = true
    arg = argv.shift
  end

  if arg
    config[:project_name] = arg
    return true
  else
    usage(:illegal_arguments)
    return false
  end
end

def usage(error_sym)
  case error_sym
  when :help, :illegal_arguments
    STDERR.puts <<EOS
Usage: xccd <projectname>
  or
xccd

Options:
  projectname: Xcode project name or project name with extension. like MyProject, MyProject.xcworkspace
EOS
  end
end

def change_dir(dir)
  puts dir
end

main


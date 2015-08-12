#!/usr/bin/ruby

require 'pathname'

def resolve_project_path(project_name, search_paths, exclude_paths)

  project_paths = find_project_paths(project_name, search_paths, exclude_paths)

  if project_paths.empty?
    STDERR.puts "#{project_name} is not found!!"
    return ""
  end

  project_path = ""
  if project_paths.length == 1
    project_path = project_paths[0]
  else
    project_path = ask_project_path(project_name, project_paths)
  end

  project_path
end

def find_project_paths(project_name, search_paths, exclude_paths)

  condition_of_find = ""
  if File.extname(project_name).empty?
    conditions = []
    [".xcworkspace", ".xcodeproj"].each do |ext|
      conditions << " -name #{project_name}#{ext} "
    end
    condition_of_find = "\\( #{conditions.join(' -or ')} \\)"
  else
    condition_of_find = "-name #{project_name}"
  end

  exclude_conditions = []
  exclude_paths.each do |path|
    exclude_conditions << " -path \"#{path}\" -prune "
  end

  paths_str = `find #{search_paths[0]} #{condition_of_find} -o #{exclude_conditions.join(' -o ')} -type d`

  paths = paths_str.split("\n")

  result = {}
  paths.each do |path|
    extname = File.extname(path)
    basename = path.gsub(/#{extname}$/, "")
    if extname == ".xcworkspace"
      result[basename] = path
    else
      result[basename] ||= path
    end
  end

  result.values
end

def ask_project_path(project_name, project_paths)
  STDERR.puts "Multiple #{project_name} is found."

  project_paths.each_with_index do |path, index|
    STDERR.puts "#{index}: #{path}"
  end
  STDERR.print "select path >" 

  selected_index = -1
  while str = STDIN.gets
    exit(0) if str.chomp.downcase == "q"

    selected_index = str.to_i
    if selected_index >= 0 && selected_index < project_paths.length
      break
    end
    STDERR.print "select path >" 
  end

  project_paths[selected_index]
end

def open_xcode(project_path)
  `open #{project_path}`
end



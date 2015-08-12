#!/usr/bin/ruby

PARAMS = {
  project_name: ""
}

def main
  exit(1) unless parse_args(ARGV)
  project_paths = find_project_path(PARAMS[:project_name])

  if project_paths.empty?
    puts "#{PARAMS[:project_name]} is not found!!"
    return
  end

  project_path = ""
  if project_paths.length == 1
    project_path = project_paths[0]
  else
    project_path = ask_project_path(project_paths)
  end
  
  open_xcode(project_path)
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
    puts "Usage: xcopen <projectname>"
    puts ""
    puts "Options:"
    puts "\tprojectname: xcode project name or project name with extension. like MyProject, MyProject.xcworkspace"
  end
end

def find_project_path(project_dir)
  search_path_pattern = project_dir
  if File.extname(search_path_pattern).empty?
    search_path_pattern = "#{project_dir}\.{xcworkspace,xcodeproj}"
  end
  paths = Dir.glob("**/#{search_path_pattern}")
  paths = use_first_path_if_same_dir(paths)
end

def use_first_path_if_same_dir(paths)
  result = {}
  paths.each do|path|
    extname = File.extname(path)
    removed_extname_path = path.gsub(/#{extname}$/, "")

    unless result.has_key?(removed_extname_path)
      result[removed_extname_path] = path
    end
  end
  result.values
end

def ask_project_path(project_paths)
  puts "Multiplee of #{PARAMS[:project_name]} is found."

  project_paths.each_with_index do |path, index|
    puts "#{index}: #{path}"
  end
  print "select path >" 

  selected_index = -1
  while str = STDIN.gets
    exit(0) if str.chomp.downcase == "q"

    selected_index = str.to_i
    if selected_index >= 0 && selected_index < project_paths.length
      break
    end
    print "select path >" 
  end

  project_paths[selected_index]
end

def open_xcode(project_path)
  `open #{project_path}`
end

main

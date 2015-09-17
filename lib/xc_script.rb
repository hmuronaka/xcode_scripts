#!/usr/bin/env ruby

$:.unshift File.dirname(__FILE__)

require 'pathname'
require 'yaml'
require_relative '../lib/xc_history'
require_relative '../lib/xc_config'
require_relative '../lib/xccache_file'


def resolve_project_path(project_name, search_paths, exclude_paths, search_depth, option = {})

  project_path = ""

  if project_name == "."
    projects = list_projects(Dir.pwd, exclude_paths, 1)
    projects = prior_xcworkspace(projects)
    if projects.empty?
      STDERR.puts "project is not found!!"
      return ""
    end

    project_path = projects[0][:project_path]
  else
    if project_name.nil? or project_name.empty?
      return ""
    end

    project_paths = find_project_paths2(project_name, search_paths, exclude_paths, search_depth)

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
  end

  File.expand_path(project_path, search_paths[0])
end

def find_project_paths2(project_name, search_paths, exclude_paths, search_depth)

  projects = list_projects(search_paths[0], exclude_paths, search_depth) do |name, path|
    project_name == name
  end

  result = prior_xcworkspace(projects).map do |item|
    item[:project_path]
  end
  result
end

def prior_xcworkspace(projects)
  result = {}
  projects.each do |item|
    path = item[:project_path]
    extname = File.extname(path)
    basename = path.gsub(/#{extname}$/, "")
    if extname == ".xcworkspace"
      result[basename] = item
    else
      result[basename] ||= item
    end
  end

  result.values
end


def find_project_paths(project_name, search_paths, exclude_paths, search_depth)

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

  paths_str = `find #{search_paths[0]} #{condition_of_find} -o #{exclude_conditions.join(' -o ')} -type d -depth #{search_depth}`

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

def list_project_names(dir, ignore_files, depth, option = {}, &block)

  project_paths = list_projects(dir, ignore_files, depth, option, &block)

  project_names = project_paths.map do |item|
    item[:project_name]
  end
  project_names.uniq
end

def list_projects(dir, ignore_files, depth, option = {}, &block)

  project_paths = []
  if option[:use_cache]
    project_paths = load_cache
  else
    list_projects_recursively(project_paths, File.expand_path(dir), ignore_files + [".", ".."], depth, &block)
  end

  project_paths
end

def list_projects_recursively(project_paths, dir, ignore_files, depth, &block)
  if depth == 0
    return 
  end

  child_dirs = []

  is_added_project = false

  Dir.foreach(dir) do |file|
    next if ignore_files.include?(file)

    current_path = (Pathname(dir) + file).to_s
    extname = File.extname(file)
    if extname == ".xcworkspace" or extname == ".xcodeproj"
      project_name = File.basename(file, extname)
      project_path = current_path

      is_take = true
      if block_given?
        is_take = block.call(project_name, project_path)
      end

      if is_take
        project_paths << {
          project_name: project_name,
          project_path: project_path
        }
        is_added_project = true
      end
    else
      if File.directory?(current_path)
        child_dirs << current_path
      end
    end
  end

  if not is_added_project
    child_dirs.each do |dir|
      list_projects_recursively(project_paths, dir, ignore_files, depth - 1, &block)
    end
  end
end

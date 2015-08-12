#!/usr/bin/ruby

PROJECT_NAME=ARGV[0]

def find_project_path(project_dir)

  search_path_pattern = project_dir
  if File.extname(search_path_pattern).empty?
    search_path_pattern = "#{project_dir}\.{xcworkspace,xcodeproj}"
  end

  paths = Dir.glob("**/#{search_path_pattern}")
end

def open_xcode(project_path)
  `open #{project_path}`
end

def main
  project_paths = find_project_path(PROJECT_NAME)
  open_xcode(project_paths[0])
end

main


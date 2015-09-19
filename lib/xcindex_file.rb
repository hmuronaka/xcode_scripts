#!/usr/bin/env ruby

require 'yaml'

PROJECT_INDEX_PATH=File.expand_path("~/.xcindex", __FILE__)

def load_project_index
  load_project_index_with_path(PROJECT_INDEX_PATH)
end

def project_index_path
  PROJECT_INDEX_PATH
end

def load_project_index_with_path(yaml_path)
  project_index = {}
  begin
    str = File.read(yaml_path)
    project_index = YAML.load(str)
  rescue => e
  end

  project_index
end

def save_project_index(project_index)
  save_project_index_with_path(project_index, PROJECT_INDEX_PATH)
end

def save_project_index_with_path(project_index, path)
  File.open(path, 'w') do |f|
    f.write project_index.to_yaml
  end
end


#!/usr/bin/env ruby

require 'yaml'

CONFIG_PATH=File.expand_path("~/.xc_config", __FILE__)

def load_config
  load_config_with_path(CONFIG_PATH)
end

def config_path
  CONFIG_PATH
end

def load_config_with_path(yaml_path)
  config = {}
  begin
    str = File.read(yaml_path)
    config = YAML.load(str)
  rescue => e
  end

  if config[:search_paths].nil?
    config[:search_paths] = ["."]
  end
  if config[:search_depth].nil?
    config[:search_depth] = 4
  end
  if config[:exclude_paths].nil?
    config[:exclude_paths] = [".git", "Pods"]
  end
  if config[:history_num].nil?
    config[:history_num] = 12
  end
  if config[:use_index].nil?
    config[:use_index] = false
  end

  config
end

def save_config(config)
  save_config_with_path(config, CONFIG_PATH)
end

def save_config_with_path(config, path)
  File.open(path, 'w') do |f|
    f.write config.to_yaml
  end
end


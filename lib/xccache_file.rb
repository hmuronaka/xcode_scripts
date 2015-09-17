#!/usr/bin/env ruby

require 'yaml'

CACHE_PATH=File.expand_path("~/.xccache", __FILE__)

def load_cache
  load_cache_with_path(CACHE_PATH)
end

def cache_path
  CACHE_PATH
end

def load_cache_with_path(yaml_path)
  cache = {}
  begin
    str = File.read(yaml_path)
    cache = YAML.load(str)
  rescue => e
  end

  cache
end

def save_cache(cache)
  save_cache_with_path(cache, CACHE_PATH)
end

def save_cache_with_path(cache, path)
  File.open(path, 'w') do |f|
    f.write cache.to_yaml
  end
end


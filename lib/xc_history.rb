#!/usr/bin/env ruby

require 'pathname'
require 'yaml'

HISTORY_FILE = File.expand_path('~/.xc_history')

def record_history(project_name, path)
  histories = load_or_create_histories(HISTORY_FILE)

  history = {
    project_name: project_name,
    path: path
  }
  histories.insert(0, history)

  if histories.size > 1
    histories = remove_duplicated_project(histories, 1, history)
  end

  save_history(histories, HISTORY_FILE)
end

def load_or_create_histories(history_path)
  if File.exists? history_path
    str = File.read(history_path)
    history = YAML.load(str)
  else
    history = []
  end

  history
end

def save_history(history, history_path)
  File.open(history_path, "w") do |f|
    f.write history.to_yaml
  end
end

def remove_duplicated_project(histories, from_index, history)
  result = []
  histories.each_with_index do |item, index| 
    puts "#{item}"
    if index < from_index || 
      (history[:project_name] != item[:project_name] && history[:path] != item[:path])
      result << item
    end
  end
  result
end

def ask_open_project_from_histories
  histories = load_or_create_histories(HISTORY_FILE)

  histories.each_with_index do |item, index|
    STDERR.puts "#{index} #{item[:project_name]}:#{item[:path]}"
  end
  STDERR.print "input index > "

  selected_index = -1
  while str = STDIN.gets
    exit(0) if str.chomp.downcase == "q"

    selected_index = str.to_i
    if selected_index >= 0 && selected_index < histories.size
      break
    end
    STDERR.print "input index >" 
  end

  histories[selected_index]
end

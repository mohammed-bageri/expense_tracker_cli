# frozen_string_literal: true

require 'json'

module Savable
  def load_data(file)
    return {} unless File.exist?(get_file_path(file))

    JSON.parse(File.read(get_file_path(file)), { :symbolize_names => true })
  end

  def save_data(file, data)
    f = File.open(get_file_path(file), 'w+')
    f.write(JSON.pretty_generate(data))
  end

  def get_file_path(relative_file_path)
    directory = File.dirname(__FILE__)

    File.join(directory, relative_file_path)
  end
end

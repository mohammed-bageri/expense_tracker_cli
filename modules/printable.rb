require 'terminal-table'

module Printable
  def print_to_table(array)
    keys = array.map(&:keys).flatten.uniq
    table = Terminal::Table.new :headings => keys, :rows => array.map(&:values)

    puts table
  end

  def print_hash(hash)
    separator = "\n".ljust(22, '-')
    puts separator

    hash.each do |key, value|
      puts "#{key}: #{value}"
    end

    puts separator
  end

  def normalized_input
    input = gets.chomp
    return if input.empty?

    input
  end
end

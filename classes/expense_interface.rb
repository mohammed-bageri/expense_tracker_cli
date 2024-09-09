require 'singleton'
require_relative '../modules/savable'
require_relative '../modules/printable'
require_relative 'setting_interface'

class ExpenseInterface
  include Singleton
  include Savable
  include Printable

  DATABASE_PATH = '../database.json'

  attr_accessor :expenses

  def initialize
    self.expenses = load_data(DATABASE_PATH) || {}
  end

  def max_id
    expenses.map { |key, expense| key.to_s.to_i }.max || 0
  end

  def add(description, amount, category = 'general')
    raise(ArgumentError, 'please provide a description') if description.nil? || description.empty?

    amount = amount.to_i
    raise(ArgumentError, 'please provide a positive non-zero amount') if amount.zero? || amount.negative?

    if amount + summary >= SettingInterface.instance.setting[:budget]
      puts "Warning: You have reached the budget of #{SettingInterface.instance.setting[:budget]}"
    end

    id = max_id + 1
    expenses[id] = {
      id:,
      description:,
      amount:,
      category:,
      date: Time.now,
    }

    save_to_database

    puts "Expense added successfully (ID: #{id})"
  end

  def edit(id, description, amount, category)
    find_by_id!(id)

    unless amount.nil?
      amount = amount.to_i
      raise(ArgumentError, 'please provide a positive non-zero amount') if amount.zero? || amount.negative?
    end

    symbol_id = id.to_s.to_sym

    if !amount.nil? && (amount - expenses[symbol_id][:amount] + summary) >= SettingInterface.instance.setting[:budget]
      puts "Warning: You have reached the budget of #{SettingInterface.instance.setting[:budget]}"
    end

    expenses[symbol_id] = {
      id: expenses[symbol_id][:id],
      amount: amount || expenses[symbol_id][:amount],
      description: description || expenses[symbol_id][:description],
      category: category || expenses[symbol_id][:category],
      date: expenses[symbol_id][:date],
    }

    save_to_database

    puts 'Expense updated successfully'
  end

  def delete(id)
    expenses.delete(id.to_s.to_sym)

    save_to_database

    puts 'Expense deleted successfully'
  end

  def find_by_id!(id)
    expense = find_by_id(id)
    raise(StandardError, 'Expense ID not found') if expense.nil?

    expense
  end


  def find_by_id(id)
    expenses[id.to_s.to_sym]
  end

  def list
    expenses.values
  end

  def print_list
    print_to_table(list)
  end

  def summary(month = nil)
    return expenses.values.filter { |e| Time.new(e[:date]).month == month }.sum { |e| e[:amount] } unless month.nil?

    expenses.values.sum { |e| e[:amount] }
  end

  def print_summary(month = nil)
    month_text = month.nil? ? "" : " for #{Date::MONTHNAMES[month.to_i]}"

    puts "Total expenses#{month_text} is #{summary(month)}"
  end

  def save_to_database
    save_data(DATABASE_PATH, expenses)
  end
end

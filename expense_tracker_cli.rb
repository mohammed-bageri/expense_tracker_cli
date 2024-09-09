#!/usr/bin/env ruby

require 'thor'
require 'csv'
require_relative 'classes/expense_interface'
require_relative 'classes/setting_interface'

class ExpenseTrackerCLI < Thor

  desc "add --description DESCRIPTION --amount AMOUNT --category CATEGORY", "add an expense"
  option :description, required: true
  option :amount, required: true
  option :category
  def add
    ExpenseInterface.instance.add(options[:description], options[:amount], options[:category])
  end

  desc "update --id ID --description DESCRIPTION --amount AMOUNT --category CATEGORY", "update an expense"
  option :id, required: true
  option :description
  option :amount
  option :category
  def update
    ExpenseInterface.instance.edit(options[:id], options[:description], options[:amount], options[:category])
  end

  desc "update --id ID", "delete an expense"
  option :id, required: true
  def delete
    ExpenseInterface.instance.delete(options[:id])
  end

  desc "list", "list all expenses"
  def list
    ExpenseInterface.instance.print_list
  end

  desc "summary --month MONTH", "Print the total amount"
  option :month
  def summary
    ExpenseInterface.instance.print_summary(options[:month])
  end

  desc "set-budget --budget BUDGET", "Set a budget for the month"
  option :budget
  def set_budget
    SettingInterface.instance.set_budget(options[:budget])
  end

  desc "export-to-csv", "Save expenses to CSV file"
  def export_to_csv
    data = EmployeeInterface.instance.list

    CSV.open("output.csv", "w") do |csv|
      csv << data.first.keys

      # Write each hash as a row
      data.each do |hash|
        csv << hash.values
      end
    end

    puts "CSV file created successfully! at output.csv"
  end
end

def main
  ExpenseTrackerCLI.start(ARGV)
rescue StandardError => err
  puts err.full_message
end

main if __FILE__ == $PROGRAM_NAME

#Dependencies
require "csv"

#Class Definitions
class EventManager

  def initialize
    puts "EventManager Initialized."
    filename = "event_attendees.csv"
    @file = CSV.open(filename, {:headers => true, :header_converters => :symbol})
  end

  def print_names
    @file.each do |line|
      puts "#{line[:first_name]} #{line[:last_name]}"
    end
  end
  
  def print_numbers
    @file.each do |line|
      number = line[:homephone]
      clean_number = number.delete "." " " "(" ")" "-"
      # clean_number = clean_number.delete(" ")
      # clean_number = clean_number.delete("(")
      # clean_number = clean_number.delete(")")
      # clean_number = clean_number.delete("-")
      puts clean_number
    end
  end

end

#Script
manager = EventManager.new
manager.print_numbers
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
      
      if clean_number.length == 10
        #do nothing
      elsif clean_number.length == 11
        if clean_number.start_with?("1")
          clean_number = clean_number[1..-1]
        else
          clean_number = "0000000000"
        end
      else
        clean_number = "0000000000"
      end
      puts clean_number
    end
  end

end

#Script
manager = EventManager.new
manager.print_numbers
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
      number = clean_number(line[:homephone])
      puts number
    end
  end

  def print_zipcodes
    @file.each do |line|
      zipcode = clean_zipcode(line[:zipcode])
      puts zipcode
    end
  end

  def clean_number(original)
      number = original.delete "." " " "(" ")" "-"
      
      if number.length == 10
        #do nothing
      elsif number.length == 11
        if number.start_with?("1")
          number = number[1..-1]
        else
          number = "0000000000"
        end
      else
        number = "0000000000"
      end
    return number
  end

  def clean_zipcode(original)
    if original.nil?
        result = "00000" #If it's nil, it's junk
    elsif original.length < 5
      # Added 0's with a while loop
      # while original.length < 5
      #   original = "0" + original
      # end
      # result = original
      
      # Added 0's by calculating number of missing 0's
      missing_zeros = 5 - original.length
      result = "#{0 * missing_zeros}#{original}"
    else
      result = original
    end
    return result
  end

end

#Script
manager = EventManager.new
manager.print_zipcodes
#Dependencies
require "csv"

#Class Definitions
class EventManager

  def initialize
    puts "EventManager Initialized."
    filename = "event_attendees.csv"
    @file = CSV.open(filename, {:headers => true})
  end

  def print_names
    @file.each do |line|
      puts "#{line["first_Name"]} #{line["last_Name"]}"
    end
  end

end

#Script
manager = EventManager.new
manager.print_names
#Dependencies
require "csv"

#Class Definitions
class EventManager
  def initialize
    puts "EventManager Initialized."
    filename = "event_attendees.csv"
    @file = CSV.open(filename)
  end
end

#Script
manager = EventManager.new
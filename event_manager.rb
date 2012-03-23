#Dependencies
require "csv"
require "sunlight"
require "./attendee"
require "./event_stats"

#Class Definitions
class EventManager
  Sunlight::Base.api_key = "e179a6973728c4dd3fb1204283aaccb5"

  attr_accessor :attendees

  def initialize(filename)
    puts "EventManager Initialized."
    file = CSV.open(filename, {:headers => true, :header_converters => :symbol})
    self.attendees = file.collect {|line| Attendee.new(line)}
  end

  def print_names
    attendees.each do |attendee|
      puts "First:#{attendee.first_name} Last:#{attendee.last_name}"
    end
  end
  
  def print_numbers
    attendees.each do |attendee|
      puts attendee.homephone
    end
  end

  def print_zipcodes
    attendees.each do |attendee|
      puts attendee.zipcode
    end
  end

  def output_data(filename)
    output = CSV.open(filename, "w")
    attendees.each do |line|
      
      #first line of CSV is 2
      if @file.lineno == 2
        output << line.headers
      else
      end

      line[:homephone] = clean_number(line[:homephone])
      line[:zipcode] = clean_zipcode(line[:zipcode])
      output << line
    end
  end

  def rep_lookup
    self.attendees[0..19].each do |attendee|

      representative = "unknown"
      #api lookup

      legislators = Sunlight::Legislator.all_in_zipcode(attendee.zipcode)
      
      names = legislators.collect do |legislator|
        suffix = legislator.name_suffix
        first_initial = legislator.firstname[0] 
        last_name = legislator.lastname
        party = legislator.party
        suffix + " " + first_initial + "." + last_name + " (" + party + ")"
      end

      puts "#{attendee.last_name}, #{attendee.first_name}, #{attendee.zipcode}, #{names.join(", ")}"
    end
  end

  # def print_stats
  #   attendees.each do |attendee|
  #     puts "First:#{attendee.first_name} Last:#{attendee.last_name}"
  #   end
  # end


  def create_form_letters
    letter = File.open("form_letter.html", "r").read
    self.attendees[0..19].each do |attendee|

      custom_letter = letter.gsub("#first_name", attendee.first_name)
      custom_letter = custom_letter.gsub("#last_name", attendee.last_name)
      custom_letter = custom_letter.gsub("#street", attendee.street)
      custom_letter = custom_letter.gsub("#city", attendee.city)
      custom_letter = custom_letter.gsub("#state",attendee.state)
      custom_letter = custom_letter.gsub("#zipcode",attendee.zipcode)

      filename = "output/thanks_#{attendee.last_name}_#{attendee.first_name}.html"
      output = File.new(filename, "w")
      output.write(custom_letter)
    end
  end
end

#Script
manager = EventManager.new("event_attendees.csv")
manager.rep_lookup
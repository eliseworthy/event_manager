#Dependencies
require "csv"
require "sunlight"
require "./attendee"

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
    @file.each do |line|
      
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
    20.times do
      line = @file.readline

      representative = "unknown"
      #api lookup

      legislators = Sunlight::Legislator.all_in_zipcode(clean_zipcode(line[:zipcode]))
      
      names = legislators.collect do |legislator|
        suffix = legislator.name_suffix
        first_initial = legislator.firstname[0] 
        last_name = legislator.lastname
        party = legislator.party
        suffix + " " + first_initial + "." + last_name + " (" + party + ")"
      end

      puts "#{line[:last_name]}, #{line[:first_name]}, #{line[:zipcode]}, #{names.join(", ")}"
    end
  end

  def create_form_letters
    letter = File.open("form_letter.html", "r").read
    20.times do |line|
      line = @file.readline

      custom_letter = letter.gsub("#first_name",line[:first_name])
      custom_letter = custom_letter.gsub("#last_name",line[:last_name])
      custom_letter = custom_letter.gsub("#street",line[:street])
      custom_letter = custom_letter.gsub("#city",line[:city])
      custom_letter = custom_letter.gsub("#state",line[:state])
      custom_letter = custom_letter.gsub("#zipcode",line[:zipcode])

      filename = "output/thanks_#{line[:last_name]}_#{line[:first_name]}.html"
      output = File.new(filename, "w")
      output.write(custom_letter)
    end
  end

  def rank_times
    hours = Array.new(24){0}
    @file.each do |line|
     time = line[:regdate].split(" ")
     time = time[1].split(":")
     hour = time[0]

     hours[hour.to_i] = hours[hour.to_i] + 1
    end
    hours.each_with_index{|counter,hour| puts "#{hour}\t#{counter}"}
  end

  def day_stats
    days = Array.new(7){0}
    @file.each do |line|
     date_of_reg = line[:regdate].split(" ")
     date_of_reg = date_of_reg[0] 
     date = Date.strptime(date_of_reg, "%m/%d/%Y")
     day_of_week = date.wday

     days[day_of_week.to_i] = days[day_of_week.to_i] + 1
    end
    days.each_with_index{|counter,day_of_week| puts "#{day_of_week}\t#{counter}"}
  end

  def state_stats
    state_data = {}
    @file.each do |line|
      puts line.inspect
      state = line[:state]
      if state_data[state].nil?
        state_data[state] = 1
      else
        state_data[state] = state_data[state] + 1
      end
    end

    state_data = state_data.select{|state,counter| state}.sort_by{|state, counter| state unless state.nil?}
    state_data.each do |state,counter|
      puts "#{state}: #{counter}"
    end
    state_data
  end

  def alpha_with_rank
    state_data = state_stats
    ranks = state_data.sort_by{|state, counter| -counter}.collect{|state, counter| state}
    state_data = state_data.select{|state, counter| state}.sort_by{|state, counter| state}

    state_data.each do |state, counter|
      puts "#{state}:\t#{counter}\t(#{ranks.index(state) + 1})"
    end
  end

end

#Script
manager = EventManager.new("event_attendees.csv")
manager.print_numbers
#Dependencies
require "csv"
require "sunlight"

#Class Definitions
class EventManager
  INVALID_ZIPCODE = "00000"
  INVALID_PHONE = "0000000000"
  Sunlight::Base.api_key = "e179a6973728c4dd3fb1204283aaccb5"


  def initialize(filename)
    puts "EventManager Initialized."
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
          number = INVALID_PHONE
        end
      else
        number = INVALID_PHONE
      end
    return number
  end

  def clean_zipcode(original)
    if original.nil?
        result = INVALID_ZIPCODE
    elsif original.length < 5
      # Added 0's with a while loop
      # while original.length < 5
      #   original = "0" + original
      # end
      # result = original
      
      # Added 0's by calculating number of missing 0's
      missing_zeros = 5 - original.length
      result = "#{0 * missing_zeros}#{original}"

      # Added a fixed number of zeros to front, then trimmed
      # original = "000" + original
      # result = original[-5..-1]

      #Not sure how to buffer the string to a certain length with a method from the String API
    else
      result = original
    end
    return result
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


end

#Script
manager = EventManager.new("event_attendees.csv")
manager.create_form_letters
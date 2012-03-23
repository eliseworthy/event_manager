class Attendee
  INVALID_PHONE = "0000000000"
  INVALID_ZIPCODE = "00000"

  attr_accessor :regdate, :first_name, :last_name, :email, :zipcode, :city, :state, :street, :homephone

  def initialize(attributes)
    self.regdate = attributes[:regdate]
    self.first_name = attributes[:first_name]
    self.last_name = attributes[:last_name]
    self.email = attributes[:email_address]
    self.zipcode = attributes[:zipcode]
    self.city = attributes[:city]
    self.state = attributes[:state]
    self.street = attributes[:street]
    self.homephone = attributes[:homephone]
  end

  def homephone=(original)
    @homephone = clean_number(original)
  end

  def zipcode=(original)
    @zipcode = clean_zipcode(original)
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

    number = "(#{number[0..2]}) #{number[3..5]}-#{number[6..-1]}"
    
    return number

  end

  def clean_zipcode(original)
    if original.nil?
        result = INVALID_ZIPCODE
    elsif original.length < 5
      missing_zeros = 5 - original.length
      result = "#{0 * missing_zeros}#{original}"
    else
      result = original
    end
    return result
  end
end

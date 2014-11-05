class String

  def to_object
    self.singularize.classify.constantize
  end

  def is_valid_email?
    ret = self =~ /\A[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,4}\z/
    return ret.nil? ? false : true
  end

  def escape_single_quotes
    self.gsub(/'/, "\\\\'")
    return self
  end
  #check if nil or empty
  def self.nil_or_e?(p_string)
    (p_string.nil? or p_string == "")
  end

  #set to nil if empty
  def self.nil_to_e(p_string)
    p_string.nil? ? "" : p_string
  end

  def currency_to_f(options={})
    self.tr_s('$','').tr_s(',','').to_f
  end

  def to_currency(options={})
    l_fnum = self.currency_to_f  #convert back to number and then reformat
    l_fnum.to_currency(options)
  end

  def to_valid_date(options={})
    value = self
    return if value.blank?
    return value if value.is_a?(Date)
    return value.to_date if value.is_a?(Time) || value.is_a?(DateTime)

    us_date_format = options[:european_format] ? false : true

    year, month, day = case value.strip
                         # 22/1/06, 22\1\06 or 22.1.06
                         when /\A(\d{1,2})[\\\/\.-](\d{1,2})[\\\/\.-](\d{2}|\d{4})\Z/
                           us_date_format ? [$3, $1, $2] : [$3, $2, $1]
                         # 22 Feb 06 or 1 jun 2001
                         when /\A(\d{1,2}) (\w{3,9}) (\d{2}|\d{4})\Z/
                           [$3, $2, $1]
                         # July 1 2005
                         when /\A(\w{3,9}) (\d{1,2})\,? (\d{2}|\d{4})\Z/
                           [$3, $1, $2]
                         # 2006-01-01
                         when /\A(\d{4})-(\d{2})-(\d{2})\Z/
                           [$1, $2, $3]
                         # 2006-01-01T10:10:10+13:00
                         when /\A(\d{4})-(\d{2})-(\d{2})T(\d{2}):(\d{2}):(\d{2})\Z/
                           [$1, $2, $3]
                         # Not a valid date string
                         else
                           return nil
                       end

    #do best to make year a legit 4 character year
    year = "#{year.to_i < 20 ? '20' : '19'}#{year.to_i}" if (year.length == 2 or (year.length > 2 && year.slice(0..1) == "00"))

    Date.new(year.to_i, month.to_i, day.to_i) rescue nil
  end

  def nameize
    if self.match(/ /)
      # If the name has a space in it, we gotta run the parts through the nameizer.
      name = self.split(' ').each { |part| part.nameize! }.join(' ')
      return name
      #elsif self.match(/^[A-Z]/)  --removed by Mike Urban 06/09 because we want to process even if name is capitalized
      # If they took the time to capitalize their name then let's just jump out.
      #return self
    else
      # If there are no spaces and there is no prior capitalization then let's downcase the whole thing.
      name = self.downcase
    end
    # Let's now assume that they were lazy...
    return case
             when name.match(/^mac/i)
               name.gsub(/^mac/i, "").capitalize.insert(0, "Mac")
             when name.match(/^mc/i)
               name.gsub(/^mc/i, "").capitalize.insert(0, "Mc")
             when name.match(/^o\'/i)
               name.split("'").each{ |piece| piece.capitalize! }.join("'")
             else
               name.capitalize # Basically if the name is a first name or it's not Irish then capitalize it.
           end
  end

  def nameize!
    replace nameize # BANG!
  end


end

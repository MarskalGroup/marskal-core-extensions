class String
  def replace_eol(p_str = ' ')
    self.gsub(/(\r)?\n/, p_str)
  end


  def unquote
    self.gsub("'","").gsub('"', '')
  end

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


  def subi(p_search, p_replace)
    self.sub(Regexp.new("#{p_search}",'i'), p_replace)
  end

  def subi!(p_search, p_replace)
    self.sub!(Regexp.new("#{p_search}",'i'), p_replace)
  end

  def gsubi(p_search, p_replace)
    self.gsub(Regexp.new("#{p_search}",'i'), p_replace)
  end

  def gsubi!(p_search, p_replace)
    self.gsub!(Regexp.new("#{p_search}",'i'), p_replace)
  end

  #this is an imperfect but effective parser for the mysql select columns, however it expans slightly beyond that
  #this will take any string and spilt it into an array based on commas
  #however it will ignore commas in the circumstances as defined by the Regex code below
  #ex:
  #sql2 = 'id,`primary`,  concat(`id`, name, "hello") as junk, last_col, 1+2, "hello, Mr. Mike" as greeting, [1,2,3] as an_array'
  #returns and array of 7 elements
  def smart_comma_parse_to_array()
    p_new_str = self.clone              #lets copy string so we can make some temporary changes
    [ Regexp.new("(`.*?`)"),            #we will ignore commas between accent char ``
      Regexp.new("('.*?')"),            #ignore commas between single quotes ''
      Regexp.new("(\".*?\")"),          #ignore commas between double quotus ""
      Regexp.new("(\\{.*?\\})"),        #ignore commas between open and close curly braces {}
      Regexp.new("(\\[.*?\\])"),        #ignore commas between open and close brackets []
      Regexp.new("(\\(.*?\\))")         #ignore commas between open and close parenthesis ()
    ].each do |r|                       #lets process each search separately
      l_found = p_new_str.scan(r)       #find all string that match the Regex
      l_found.each do |l_str_array|     #find all occurrences of matches
        l_str_array.each do |str|         #lup through each find
          l_new_part = str.gsub(',', '~') #and temporaril replace the comma character, with any non comma character, in this case we use "~"
          p_new_str.sub!(str, l_new_part) #no place th is newly comma free string back into a copy of original(self) string as is
        end
      end
    end
    l_comma_locations = p_new_str.indexes_of_char(',')  #now commas only exists where the should be, so lets find each commas location
    l_comma_locations.insert(0,0) #lets insert a starting point, so that entire string gets processed, including what becomes before the first comma.
    p_new_str = self.clone        #copy string again, so we can rebuild now that we know where the legit commas are
    l_result = []                 #initialize our result array
    l_comma_locations.reverse.each do |idx|                                             #lup through all the comma backwards and crop the string as we go
      l_result.insert(0, p_new_str.slice!(idx..p_new_str.length).sub(',', ' ').strip)   #we are going backwards, so we need to insert the chopped strin back in proper order
    end
    l_result      #return the array
  end

  #finds all the instances of the specified character in the specied string.
  # Ex: "1,11,111,1111".indexes_of_char(',')  ==> returns [1, 4, 8]
  def indexes_of_char(p_char)
    (0 ... self.length).find_all { |i| self[i,1] == p_char }
  end


  #returns a 2 element array==> [sql_expresession, alias]
  #  Examples:
  #       "CONCAT(last_name, first_name) as full_name" ==> ['CONCAT(last_name, first_name)', 'full_name']
  #       "last_name"                                  ==> [last_name, '']
  def split_select_column_alias
    index = self.downcase.rindex(' as ')              #simple check for as, not perfect, but should work in all normal cases
    if index.nil? || index == 0                       #if not found or found at zero, the we will assume there is no allias
      return [self.strip, '']                         #then clean up the space and return an with no alias
    else                                                                #otherwise split into to pieces the sql select expression
      return [self[0..index].strip, self[(index+3)..self.length].strip] #(usually a column) and then set the second parameter will be the alias.
    end

  end

  #removes the specific char from the first and last charcter if they exists, otherwise returns the string untouched
  def remove_begin_end_char(p_char)
    self[0] == p_char && self[-1] == p_char ? self[1..(self.length-2)] : self
  end


  #makes into a legit filename from a string.
  def sanitize_filename()
    # Split the name when finding a period which is preceded by some
    # character, and is followed by some character other than a period,
    # if there is no following period that is followed by something
    # other than a period (yeah, confusing, I know)
    fn = self.split /(?<=.)\.(?=[^.])(?!.*\.[^.])/m

    # We now have one or two parts (depending on whether we could find
    # a suitable period). For each of these parts, replace any unwanted
    # sequence of characters with an underscore
    fn.map! { |s| s.gsub /[^a-z0-9\-]+/i, '_' }

    # Finally, join the parts with a period and return the result
    return fn.join '.'
  end


end

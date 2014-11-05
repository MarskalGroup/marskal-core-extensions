class Array

  #converts an array to a string and strips outer brackets ex:   [1,2,3].to_string_no_brackets  ==> #returns "1,2,3"
  def to_string_no_brackets
    self.to_s.gsub(/[\[\]]/,'')
  end

  def to_string_no_brackets_or_quotes #addded sept 204 when using for datatables jquery plugin, but can be used for anything
    self.to_s.gsub(/[\"\[\]]/,'')     #convert an array into a string and remove the quotes Originally developed to help 'pluck'
  end


  def prepare_for_sql_in_clause
    "(#{self.to_string_no_brackets})"
  end

  def json_data_for_highcharts
    # self.to_json.gsub(/[\'\"]/,'')   #maybe add this as a parameter to include or exclude single quotes
    self.to_json.gsub(/[\"]/,'')       # but for now, we will allow single quotes a strings are allowed in json
  end

  def sql_null_to_blank
    self.map {|v| "IFNULL(#{v}, '')" }
  end


end
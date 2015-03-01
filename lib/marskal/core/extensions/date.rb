class Date
  def start_of_next_month
    (self + 1.month).start_of_month
  end

  def for_highcharts
    # MAU 05/2014 - I left the experiments commented out for reference
    # I cant say I understand exactly how this works, but using examples I came up with a method that HighCharts seems to work well with
    # "#{self.to_time.to_i}000".to_i
    # "#{self.strftime('%Y-%m-%d 14:00').to_time.utc.to_i}000".to_i
    # "Date.UTC(#{self.strftime('%Y,%m,%d')})"
    "#{(self-1.day).to_time.strftime("%Y-%m-%d 19:00").to_time.utc.to_i}000".to_i
  end

  def self.start_of_week
    Date.today.start_of_week
  end

  def start_of_week
    if self.wday == 0  #sundays count as end of week for vehicle app
      return self - 6
    else
      (self - self.wday.days) + 1  #start on monfay
    end
  end


  def start_of_month
    self.strftime('%Y-%m-01').to_date
  end


  def self.create_from_string(p_date_str)  #MAUNEWP Added 1/2011..creats a date from a string
    parts = p_date_str.split("/")
    return nil if parts.length != 3
    return Date.new(parts[2].to_i,parts[0].to_i,parts[1].to_i)
  end

  def formatted
    self.strftime("%m/%d/%Y")
  end

  def self.is_today_weekend?
    (Date.today.wday == 0) or (Date.today.wday == 6)
  end

  def is_weekend?
    (self.wday == 0) or (self.wday == 6)
  end

  def self.next_week(date)
    date.start_of_week + 7.days
  end

  def next_week
    self.start_of_week + 7.days
  end

  def end_of_week
    self.start_of_week + 4.days
  end

end
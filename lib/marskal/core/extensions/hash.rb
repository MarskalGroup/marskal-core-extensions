class Hash

  # raises an argument error if the given Hash element has an invalid or unexpected key
  def restrict_keys(*p_valid_keys)
    p_valid_keys.flatten!
    each_key do |k|
      unless p_valid_keys.include?(k)
        raise ArgumentError.new("Unknown key: #{k.inspect}. Valid keys are: #{p_valid_keys.map(&:inspect).join(', ')}")
      end
    end
  end

  # raises an argument error if the given Hash is missing a required key
  def require_keys(*p_valid_keys)
    l_missing_keys = []
    p_valid_keys.flatten!
    p_valid_keys.each do |k|
      l_missing_keys << k  unless self.has_key?(k)
    end

    unless l_missing_keys.empty?
      raise ArgumentError.new("Missing required key(s): #{l_missing_keys.map(&:inspect).join(', ')}")
    end

  end

end
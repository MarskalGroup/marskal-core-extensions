class File

  def self.markdown_to_text(p_file, options = {})
    #no options for this version
    begin
      puts "\n\n"
      dashed_line_length = 20  #defaulkt to 20 charcters long
      l_file = File.open(p_file, "r").each_line do |line|
        if line == "---\n"
          l_dashed_line = ''
          dashed_line_length.times { l_dashed_line += '-'}
          puts l_dashed_line
        elsif line[0] == '#'
          idx = line.index(' ')
          puts line[idx..line.length].strip
        elsif line == "```\n"
          puts "\n"
          next
        else
          puts line.gsub(/[\n`]/, '')
        end
        dashed_line_length = [dashed_line_length, line.length].max if line.strip.length > 0

      end
      l_file .close

    rescue Exception => error
      puts "Error [#{error.message}] reading file #{p_file}"
    end

  end


end
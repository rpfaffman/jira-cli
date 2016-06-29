require_relative './string_colors'
require_relative './display/issue'
require_relative './models/issue'
require 'pry'

class Display
  def print_issues(issues)
    (puts "No issues found.".red; return) if issues.to_a.empty?

    print_method = (issues.count > 5) ? :print_abridged : :print_standard
    issues.each do |issue|
      print_line if print_method === :print_standard
      Display::Issue.new(issue).public_send(print_method)
    end

    print_line if print_method === :print_standard
    puts "Number of issues found: #{issues.count}".green
  end

  def print_response(response)
    if (response.code === 204)
      puts "SUCCESS".green
    else
      puts "ERROR: #{response.code}".red
      if response["errorMessages"]
        puts "\t" + response["errorMessages"].to_s.red.join("\n\t")
      end
    end
  end

  private

  def print_line
    col_num = `tput cols`
    puts "=" * col_num.to_i
  end
end

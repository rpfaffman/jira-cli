require_relative './string_colors'
require_relative './display/issue'
require_relative './models/issue'
require 'pry'

class Display
  def print_issues(issues)
    (puts "No issues found.".red; return) if issues.to_a.empty?
    issues.each { |issue|
      issue_obj = Models::Issue.new(issue)
      print_issue(issue_obj)
    }
    print_line
    puts "Number of issues found: #{issues.count}".green
  end

  def print_response(response)
    if (response.code === 204)
      puts "SUCCESS".green
    else
      puts "ERROR(S): \n".red + "\t" + response["errorMessages"].red.join("\n\t")
    end
  end

  private

  def print_issue(issue)
    fields = issue["fields"]
    print_line
    print "(#{issue['key']}) #{fields['summary']}".brown.underline, " "
    puts "[#{fields['status']['name']}] ".blue
    puts "#{fields['reporter']['name'].green} assigned to #{fields['assignee']['name'].green}"
    puts "TAGS".underline + ": #{fields['labels'].join(', ').green}"
    puts "DESCRIPTION".underline + ": #{fields['description']}"
    puts "JSON".underline + ": #{issue['self'].cyan}"
    puts "URI".underline + ": #{"https://vevowiki.atlassian.net/browse/#{issue['key']}".cyan}"
  end

  def print_line
    col_num = `tput cols`
    puts "=" * col_num.to_i
  end
end

require_relative './string_colors'

class Printer
  def display_issues(issues)
    issues.each { |issue| print_issue(issue) }
    print_line
    puts "RESULTS: #{issues.count}".green
  end

  def display_response(response)
    if response.code === 204
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

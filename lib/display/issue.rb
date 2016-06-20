class Display
  class Issue
    attr_reader :issue

    def initialize(issue)
      @issue = issue
    end

    def print_abridged
      print "#{issue.key.blue} #{issue.status.green} #{issue.summary}\n"
    end

    def print_standard
      print "(#{issue.key}) #{issue.summary}".brown.underline, " "
      puts "[#{issue.status}] ".blue
      puts "#{issue.reporter} assigned to #{issue.assignee}"
      puts "TAGS".underline + ": #{issue.labels.join(', ').green}"
      puts "DESCRIPTION".underline + ": #{issue.description}"
      puts "JSON".underline + ": #{issue.json_uri}"
      puts "URI".underline + ": #{issue.jira_uri.cyan}"
    end
  end
end

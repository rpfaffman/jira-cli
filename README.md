Copy `config.yml.example` to `config.yml` and edit to set up your credentials:

```
EMAIL     : someone@somewhere.com
PASSWORD  : password123
JIRA_URI  : https://yourcompany.atlassian.net
BASE_QUERY: 'assignee="Arthur Dent"'
```

Run `bundle install` and `ruby app.rb`. `chmod +x ./app.rb`, so you can send specific JQL queries: `./app.rb status in ('in progress')`.

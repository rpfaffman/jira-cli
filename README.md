# Jira CLI
### Easy way to view JIRA tix and transition their status

#### Usage
* Use JQL directly on command-line - `jira "labels in ('design-tweaks', 'kittens') and status in ('to do')"`
* Or use flags - `jira -l design-tweaks,kittens -s "to do"`
* Transition tickets - `jira transition AB-123 -s 'in progress'`

```
>>> jira "labels in ('code-review')"

============================================================================
(TV-1032) [Homepage] Consolidate getData functions [In Progress]
TAGS: code-review
DESCRIPTION: getData functions should be consolidated
JSON: https://vevowiki.atlassian.net/rest/api/2/issue/26388
URI: https://vevowiki.atlassian.net/browse/TV-1032
============================================================================
(TV-1031) [Playlist] Minor refactor - forEach loops, remove fetch [Dev Complete]
TAGS: code-review
DESCRIPTION: Add forEach loop to make code clearer and remove uses of "fetch" unless it is an API call
JSON: https://vevowiki.atlassian.net/rest/api/2/issue/26387
URI: https://vevowiki.atlassian.net/browse/TV-1031
============================================================================
(TV-1030) Anchor tags - swap "#" for "javascript:void(0)" [Dev Complete]
TAGS: code-review
DESCRIPTION: Replace href="#" with href="javascript:void(0)" to prevent issues with browser history
JSON: https://vevowiki.atlassian.net/rest/api/2/issue/26386
URI: https://vevowiki.atlassian.net/browse/TV-1030
============================================================================
RESULTS: 3
```

#### Install

* Clone this repo and cd into it
* `bundle install`
* `chmod +x ./bin/script.rb`
* `ln -s ~/wherever_you_cloned/jira-cli/bin/script.rb /usr/local/bin/jira`
* Copy `config.yml.example` to `config.yml` and edit to set up your credentials:

```
EMAIL     : someone@somewhere.com
PASSWORD  : password123
JIRA_URI  : https://yourcompany.atlassian.net
BASE_QUERY: 'assignee="Arthur Dent"'
```

Don't forget about "less" - `jira "labels in ('too-many-tickets')" | less`

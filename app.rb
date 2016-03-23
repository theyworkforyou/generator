require 'bundler/setup'
require 'dotenv'
Dotenv.load

require 'pry'
require 'octokit'

GITHUB_ORGANIZATION = ENV.fetch('GITHUB_ORGANIZATION', 'theyworkforyou')
REPO_NAME = ARGV.first

# This uses OCTOKIT_ACCESS_TOKEN from ENV to auth with GitHub.
repo = Octokit.create_repository(REPO_NAME, organization: GITHUB_ORGANIZATION)

NON_TECHNICAL_TASKS = <<-NTT.freeze
- [ ] Gather any non-legislative data that's needed in CSV format
- [ ] Decide on a domain name for the site
- [ ] Get Twitter username
- [ ] Get email address
- [ ] Setup Google Analytics
NTT

Octokit.create_issue(repo[:full_name], 'Non-technical tasks', NON_TECHNICAL_TASKS)

TECHNICAL_TASKS = <<-TT.freeze
- [ ] Push an unstyled theme to the new repo
- [ ] Create an [orphan `gh-pages` branch](https://help.github.com/articles/creating-project-pages-manually/#create-a-gh-pages-branch) for building the site into
- [ ] Include a `404.html` template
- [ ] Configure the site to build on Travis CI
- [ ] Add required plugins and configure them
- [ ] Add this country to the datasource updater
- [ ] Setup DNS
TT

Octokit.create_issue(repo[:full_name], 'Technical tasks', TECHNICAL_TASKS)

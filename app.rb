require 'bundler/setup'
require 'dotenv'
Dotenv.load

require 'pry'
require 'octokit'
require 'sinatra'

GITHUB_ORGANIZATION = ENV.fetch('GITHUB_ORGANIZATION', 'theyworkforyou')

post '/sites' do
  # This uses OCTOKIT_ACCESS_TOKEN from ENV to auth with GitHub.
  repo = Octokit.create_repository(params[:name], organization: GITHUB_ORGANIZATION)
  Octokit.create_issue(repo[:full_name], 'Non-technical tasks', erb(:non_technical_tasks))
  Octokit.create_issue(repo[:full_name], 'Technical tasks', erb(:technical_tasks))
  repo[:html_url]
end

__END__

@@ non_technical_tasks
- [ ] Gather any non-legislative data that's needed in CSV format
- [ ] Decide on a domain name for the site
- [ ] Get Twitter username
- [ ] Get email address
- [ ] Setup Google Analytics

@@ technical_tasks
- [ ] Add an unstyled theme to this repo
- [ ] Include a `404.html` template
- [ ] Create an [orphan `gh-pages` branch](https://help.github.com/articles/creating-project-pages-manually/#create-a-gh-pages-branch) for building the site into
- [ ] Configure this repo to build on Travis CI
- [ ] Add required plugins and configure them
- [ ] Add this country to the datasource updater
- [ ] Setup DNS

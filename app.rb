require 'bundler/setup'
require 'dotenv'
Dotenv.load

require 'pry'
require 'octokit'
require 'sinatra'
require 'omniauth'
require 'omniauth-github'
require 'encrypted_cookie'

GITHUB_ORGANIZATION = ENV.fetch('GITHUB_ORGANIZATION', 'theyworkforyou')

use Rack::Session::EncryptedCookie, secret: ENV.fetch('SESSION_SECRET', SecureRandom.hex(32))

use OmniAuth::Builder do
  provider :github, ENV['GITHUB_CLIENT_ID'], ENV['GITHUB_CLIENT_SECRET'], scope: 'public_repo,read:org'
end

configure do
  set :show_exceptions, :after_handler
end

helpers do
  def signed_in?
    session.key?(:access_token)
  end

  def github
    @github ||= Octokit::Client.new(access_token: session[:access_token])
  end

  def authorize!
    redirect to('/') unless signed_in?
  end

  def org_member?(org)
    github.organization_memberships.any? { |mem| mem[:organization][:login] == org }
  end
end

get '/' do
  redirect to('/auth/github') unless signed_in?
  @new_repo_url = session.delete(:new_repo_url)
  erb(:index)
end

get '/auth/github/callback' do
  auth = env['omniauth.auth']
  unless org_member?(GITHUB_ORGANIZATION)
    halt 403, "This applications is only available for people in the #{GITHUB_ORGANIZATION} GitHub organization"
  end
  session[:access_token] = auth[:credentials][:token]
  redirect to('/')
end

post '/sites' do
  authorize!
  # This uses OCTOKIT_ACCESS_TOKEN from ENV to auth with GitHub.
  repo = github.create_repository(params[:site_name], organization: GITHUB_ORGANIZATION)
  github.create_issue(repo[:full_name], 'Non-technical tasks', erb(:non_technical_tasks))
  github.create_issue(repo[:full_name], 'Technical tasks', erb(:technical_tasks))
  session[:new_repo_url] = repo[:html_url]
  redirect to('/')
end

error Octokit::Forbidden do
  "You are not authorized to create repositories in #{GITHUB_ORGANIZATION}. Please contact an organization admin."
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

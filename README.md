# PMO Site Generator

Kickstart work on a Jekyll based PMO site.

## Install

Clone this repository from GitHub, install the dependencies with bundler, then cp the example `.env` file and fill it in by following the instructions in that file.

    git clone https://github.com/theyworkforyou/generator
    cd generator
    bundle install
    cp .env.example .env
    $EDITOR .env

## Usage

Start the application with Foreman, then you can view the app at <http://localhost:5000>.

    foreman start
    open http://localhost:5000

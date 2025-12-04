# Thryft

CS-UY 4513 Software Engineering Project

## Requirements:

#### System dependencies:
- Ruby 3.4.7
- Rails 8.1.0
- Postgres

## Setup

After cloning the repo and having the necessary Ruby and Rails versions, run:
`bundle install`

**Installing Postgres and Setting Up Local Database**
Linux (Ubuntu): 
```
# Update and install Postgres
sudo apt update
sudo apt install postgresql postgresql-contrib

# By default, Postgres creates a 'postgres' user.
# Switch to that user to create your own database role.
sudo -u postgres createuser --superuser $(whoami)
```

MacOS:
```
# Install Homebrew if you don't have it

# Install Postgres
brew install postgresql

# Start the Postgres service (so it's always running in the background)
brew services start postgresql

# Create a database user (role)
# By default, Rails will try to connect using your system username
# (e.g., "sarah"). This command creates a Postgres user with that name.
createuser --superuser $(whoami)
```

Windows: 
`Just use WSL and follow the Linux instructions. Makes life easier. Trust me.`

**Database Initialization**

Run this when setting up the project for the first time:
```
rails db:setup
rails db:migrate
```

**Required Gem Setup**
```
rails dartsass:install
rails generate rails_icons:install --libraries=heroicons
```

## How to Run the Project
```
bin/dev
```

## How to run the test suite

**Rspec:**
`bundle exec rspec`

**Cucumber:**
`bundle exec cucumber`



## Things to add in the readme:

* Services (job queues, cache servers, search engines, etc.)

* Deployment instructions

* ...

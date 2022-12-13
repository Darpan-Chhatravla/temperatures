# README

## Getting Started

```sh
$ git clone git:url
$ cd temperatures
```

### Known gotchas

* Running the server will start PostgreSQL on its default port. Make sure the port is free on your machine beforehand.

### System Requirements

 * Ruby 3.1.3
 * psql (PostgreSQL) 15.1
    * The application is confirmed to work with version 15.1
 * macOS Catalina
    * `bundle install` will not work for Big Sur from a clean slate
    * There are changes in Big Sur that prevent the `zxing_cpp` gem from installing when running `bundle install`
    * Versions of macOS earlier than Catalina may work
 * Database creation
 	```sh
	$bundle exec rails db:create
	$bundle exec rails db:migrate
	```
 * How to run the test suite
	```sh
	bin/bundle exec rspec spec
	```
 * How set the cron
 	```sh
	 0 0,3,6,9,12,15,18,21 * * * /bin/bash -l -c 'cd /temperatures && RAILS_ENV=production bundle exec rake temperature:refresh --silent >> /log/cron_log.log 2>&1'
	 ```

### Running the Application

1. Start the server in one terminal session
   ```sh
	$bundle exec rails s
	```

### API execution
1. Navigate to [GET: http://localhost:3000/v1/cities/historical_temperatures?slug=&start_date=&end_date=] for historical temprature
2. Navigate to [GET: http://localhost:3000/v1/cities] for list of cities
3. Navigate to [POST: http://localhost:3000/v1/cities?slug=] for creating a city
4. Navigate to [PATCH: http://localhost:3000/v1/cities/update?slug=&latitude=&longitude=] for updating a city
5. Navigate to [DELETE: http://localhost:3000/v1/cities/delete?slug=] for deleting a city

#### Setting Ruby Version

Here are a few useful `rbenv` commands:

 * `rbenv global`
    * Show what version of Ruby you have running globally
 * `rbenv install 3.1.3`
    * Install Ruby 3.1.3
 * `rbenv global 3.1.3`
    * Set the global Ruby version to 3.1.3. You probably should not do this.

#### Install PostgreSQL

1. Install PostgreSQL
    * `brew install postgresql@15` or download from the [Postgres site][postgres-download]
2. Verify PostgreSQL is on your `PATH` and is the correct version
    * `psql --version`
3. Create a PostgreSQL superuser
    * `createuser -s postgres`
4. Verify superuser created successfully
    * `psql --list`

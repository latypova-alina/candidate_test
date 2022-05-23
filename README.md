# Kyero candidate refactoring excercise

## Goal

The candidate is asked to refactor the `app/jobs/manage_orders_job.rb` job, and all its dependencies and subdependencies.

The code quality needs to (or might not) improve in terms of
* readability
* speed of execution (could any operation be avoided? Could any other be faster if there was some additional configuration?)
* correctness and completeness
* responsibility attribution

Use your best judgement to decide what to improve and what not. Make all the assumptions you like, but please add them as comments on the code. If there is something you are not sure about, even leaving a comment that describes what you want to do, without changing the actual code will work.

The database schema can be changed too, if you feel that's necessary.

Feel free to add any gems you like. Rails is installed. We'd like you to make use of its libraries

Unit tests are a requirement. Rspec is installed

This excercise is expected to take no more than a couple of hours. Please let us know if it took more, we'll adjust it for the next time

## Online sales application

The application is a basic online sales manager, that calls an external service for delivering a product, in case the customer has paid for it. The core of the application is a job that is run overnight, and checks if the customers have paid for their orders. 

* If they haven't, then they will receive an invoice or a kind reminder, depending on the date when the order has been placed. 
* If they have:
  * In case their product has been delivered, their ticket is closed. 
  * In case their product has not been delivered, the delivery is ordered

## Assumptions

* The code might be wrong/incomplete. Unless explicitly told, you're expected to fix/implement.
* We have millions of customers.
* Each customer can have up to a thousand orders.
* Assume that our active job backend is sidekiq (no need to implement), that uses an instance of redis for storage having infinite space.
* We might have multiple production-like environments, some of which acting as "staging".
* The current schema is deployed and active in production already.

## Setup

To setup this excercise you can `cd` into this directory and run `bundle install`.
Then, in order to have some sample data to work on, you can run `rake db:create && rake db:migrate && rake db:seed`.

In order to run the specs, you can simply run `bundle exec rspec`
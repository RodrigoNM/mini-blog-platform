# Mini Blog Platform

## Requirements

* **Rails 7.2**
* **Ruby 3.3.5**
* **Postgres**

### Gems used
* devise
* devise-jwt
* pundit
* rspec-rails
* factory_bot_rails
* faker
* redis
* pg_search

### Overview
* This is a mini-blogging platform built with Ruby on Rails, allowing users to create, edit, and comment on posts. additional features like caching, and background jobs, were used to acomplish the challenge.

### Improvements opportunity
* Create an API error handling to track better errors and return more user friendly messages
* Created serializer models to serialize objects and build responses
* Create an STI polimorphic user table instead of a role attribute
* Move policy files to be under api/v1 namespace
* Create a log concern to register important steps
* Create a postman collection it can be helpful for other developers to understand the app behavior
* Implement rubocop
* Code coverage
* Define sidekiq queues priority

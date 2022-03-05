# README

### Prerequesites
I upgraded the app to `rails 7` and set the version of ruby to `3.0.3`
if you have those installed then you just need to run `bundle install` to install the gems
and `rails s` to start the server

##### Project requirements

The api should support the creation of multiple users with their own accounts.

As a user I want to be able to:

Create a new account
Login to my account
Create, update, and delete a task
A task should have a title, a check to see if i’ve completed it, and I want to be able to add notes to it
See a list of all of my tasks, as well as filter by whether or not a task has been completed
I should not be able to see tasks of other users, just my own tasks
See the details (title, etc.) for a particular task
Retrieve a list of my completed tasks
Retrieve a list of my uncompleted tasks
Bonus (only do this if you have enough time, not required):

Write a couple of tests for your controllers using rspec

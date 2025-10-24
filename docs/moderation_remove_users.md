# User Story

## Feature: Moderator Remove Users
  As a moderator, 
  I want to remove users that break our platform policies
  so that normal users can have a smooth user experience

  Scenario: Moderator successfully removes a user
    Given I am a signed-in Moderator
    And I am on the User List page
    And there is a User with name "John Smith" and User ID "54"
    When I click the "Delete User" button for User ID "54"
    Then I should see the message "User John Smith with ID 54 has been deleted"
    And the User with ID "54" should be deleted from the database

  Scenario: Moderator tries to remove another moderator with Admin Privilege
    Given I am a signed-in Moderator
    And I don't have the "Admin" privilege
    And I am on the User List page
    And there is a Moderator with name "Tom Holland" and User ID "2"
    And User ID "2" has the "Admin" privilege
    When I click the "Delete User" button for User ID "2"
    Then I should see the error message "You don't have permission to delete User with ID 2"

  Scenario: Moderator tires to remove a non-existent user
    Given I am a signed-in Moderator
    And I am on the User List page
    When I submit a delete request for User ID "999" (non-existent)
    Then I should see the error message "User does not exist"

# MVC Component Outline

Model: A User model with user_id:int, is_moderator:bool, and is_admin:bool attributes

Views: A User List page at moderation/user_list.html.erb with a table of all the users with actions for each user

Controllers: A ModerationController with the following actions:
  - index
  - user_list
  - authenticate
  - remove_user
  - check_admin_privilege
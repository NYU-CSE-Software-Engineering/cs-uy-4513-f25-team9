# User Story

## Feature: Moderator Remove Users
  As a moderator, 
  I want to remove users that break our platform policies
  so that normal users can have a smooth user experience

## Acceptance Criteria

1. Only a Moderator can delete any non-moderator
2. Only a Moderator with "Admin" permissions can delete other moderators
3. Moderators should not be able to remove non-existent Users

# MVC Component Outline

Model: A User model with user_id:int, is_moderator:bool, and is_admin:bool attributes

Views: A User List page at moderation/user_list.html.erb with a table of all the users with actions for each user

Controllers: A ModerationController with the following actions:
  - index
  - user_list
  - authenticate
  - remove_user
  - check_admin_privilege
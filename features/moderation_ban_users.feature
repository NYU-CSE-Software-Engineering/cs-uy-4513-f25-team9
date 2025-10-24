# features/moderation_ban_users.feature
Feature: Moderator Bans Fraudulent Users
  As a Moderator
  I want to review reported users and ban fraudulent ones
  So that the platform remains free of malicious users

  Scenario: Moderator successfully bans a reported user permanently
    Given I am a signed-in Moderator
    And there is a reported user with ID "456", name "Scammer Joe" and report reason "Fraudulent activities"
    And I am on the reported users page
    When I submit a ban request for user ID "456" with reason "Confirmed fraud" and permanent ban selected
    Then I should see the message "User has been successfully banned"
    And the user with ID "456" should be marked as banned in the database
    And a moderation log for user ban should be created

  Scenario: Moderator bans a user temporarily
    Given I am a signed-in Moderator
    And there is a reported user with ID "789", name "Spammer Bob"
    And I am on the reported users page
    When I submit a ban request for user ID "789" with reason "Spamming" and 30 days duration
    Then the user with ID "789" should have a banned_until date 30 days from now
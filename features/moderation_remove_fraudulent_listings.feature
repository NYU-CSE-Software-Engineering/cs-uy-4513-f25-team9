Feature: Moderator Removes Fraudulent Products
  As a moderator
  I want to remove listings that are reported as fraudulent
  So that the platform stays safe

  Scenario: Moderator views reported listings
    Given I am a signed-in Moderator
    And there are reported listings pending review
    When I visit the reported listings page
    Then I should see a list of reported listings
    And each listing should show the report reason

  Scenario: Moderator successfully removes a fraudulent listing
    Given I am a signed-in Moderator
    And there is a reported listing with title "Fake Product" and ID "100"
    When I visit the reported listings page
    And I click the "Remove Listing" button for listing ID "100"
    Then I should see the message "Listing Fake Product with ID 100 has been removed"
    And the listing with ID "100" should be deleted from the database

  Scenario: Non-moderator cannot access reported listings page
    Given I am a signed-in regular user
    When I try to visit the reported listings page
    Then I should be redirected to the home page
    And I should see an error message "You don't have permission to access this page"

  Scenario: Moderator tries to remove a non-existent listing
    Given I am a signed-in Moderator
    When I submit a delete request for listing ID "999" (non-existent)
    Then I should see the error message "Listing does not exist"

  Scenario: Moderator views empty reported listings page
    Given I am a signed-in Moderator
    And there are no reported listings
    When I visit the reported listings page
    Then I should see "No reported listings pending review"


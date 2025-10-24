Feature: Moderator Removes Fraudulent Products
  As a Moderator
  I want to remove listings that are reported as fraudulent
  So that the platform stays safe

  Scenario: Moderator successfully removes a fraudulent listing
    Given I am a signed-in Moderator
    And there is a reported listing with ID "123" and name "Fake Phone"
    And I am on the reported listings page
    When I click the "Mark as Fraudulent and Delete" button for listing ID "123"
    Then I should see the message "The product has been successfully marked as fraudulent and deleted"
    And the listing with ID "123" should be marked as deleted in the database

  Scenario: Moderator tries to remove a non-existent listing
    Given I am a signed-in Moderator
    And I am on the reported listings page
    When I submit a delete request for listing ID "999" (non-existent)
    Then I should see the error message "This product no longer exists"

  Scenario: Non-moderator tries to access reported listings page
    Given I am a signed-in Buyer
    When I visit the reported listings page
    Then I should be redirected to the 403 access denied page
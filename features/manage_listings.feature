Feature: Seller Manage Listings
  As a seller
  I want to manage my product listings
  So that I can sell items on the platform

  Scenario: Seller successfully creates a new listing
    Given I am a signed-in Seller
    And I am on the new listing page
    When I fill in "Name" with "Vintage Camera"
    And I fill in "Price" with "150.00"
    And I fill in "Description" with "Great condition vintage camera"
    And I click the "Create Listing" button
    Then I should see the message "Listing was successfully created"
    And I should see "Vintage Camera"

  Scenario: Seller views their listing
    Given I am a signed-in Seller
    And I have a listing with name "Vintage Camera"
    When I visit my listings page
    Then I should see "Vintage Camera"

  Scenario: Seller successfully updates a listing
    Given I am a signed-in Seller
    And I have a listing with name "Old Phone"
    And I am on the edit page for that listing
    When I fill in "Name" with "Updated Phone"
    And I fill in "Price" with "200.00"
    And I click the "Update Listing" button
    Then I should see the message "Listing was successfully updated"
    And I should see "Updated Phone"

  Scenario: Seller successfully deletes a listing
    Given I am a signed-in Seller
    And I have a listing with name "Unwanted Item"
    And I am on my listings page
    When I click the "Delete" button for "Unwanted Item"
    Then I should see the message "Listing was successfully deleted"
    And I should not see "Unwanted Item"

  Scenario: Seller tries to create listing with missing required fields
    Given I am a signed-in Seller
    And I am on the new listing page
    When I fill in "Name" with ""
    And I click the "Create Listing" button
    Then I should see the error message "Name can't be blank"

  Scenario: Seller tries to view a listing that does not exist
    Given I am a signed-in Seller
    When I visit the listing page for ID "999"
    Then I should see the error message "Listing not found"

  Scenario: Seller tries to update a listing that does not exist
    Given I am a signed-in Seller
    When I visit the edit page for listing ID "999"
    Then I should see the error message "Listing not found"

  Scenario: Seller tries to delete a listing that does not exist
    Given I am a signed-in Seller
    When I submit a delete request for listing ID "999"
    Then I should see the error message "Listing not found"


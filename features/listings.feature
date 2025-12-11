Feature: Seller manages product listings
  As a seller
  I want to manage my product listings
  So that I can sell items on the platform

  Background:
    Given I am logged in as a seller

  Scenario: Create a new listing
    When I create a listing titled "Vintage Camera" with price "150"
    Then I should see "Listing created successfully"

  Scenario: View my listings
    Given I have a listing titled "Old Camera"
    When I visit the listings page
    Then I should see "Old Camera"

  Scenario: Update a listing
    Given I have a listing titled "Old Title"
    When I update that listing to "New Title"
    Then I should see "Listing updated successfully"
    And I should see "New Title"

  Scenario: Delete a listing
    Given I have a listing titled "Unwanted Item"
    When I delete that listing
    Then I should see "Listing deleted successfully"

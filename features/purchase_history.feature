Feature: Buyer views purchase history
  As a Buyer
  I want to see a list of my past purchases
  So that I can review what I bought and when

  # Happy path
  Scenario: See my purchases with most recent first
    Given I am logged in as a buyer who has at least one completed purchase
    When I visit "My Purchases"
    Then I should see a view of purchased items
    And each row shows the listing title, the final price, and the sold date

  # Sad path
  Scenario: No purchases yet
    Given I am logged in as a new buyer with no purchases
    When I visit "My Purchases"
    Then I should see "No purchases yet"
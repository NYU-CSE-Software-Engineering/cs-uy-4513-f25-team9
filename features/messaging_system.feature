Feature: Messaging System
  As a Thryft user
  I want to communicate with other users about products
  So that I can negotiate deals and ask questions about items

  Scenario: Buyer sends message to seller about a product
    Given I am logged in as a buyer
    And I am viewing a product listing from another user
    When I click "Message Seller"
    And I fill in the message with "Is this item still available?"
    And I click "Send Message"
    Then I should see "Message sent successfully"

  Scenario: User cannot send empty message
    Given I am logged in as a buyer
    And I am on the message composition page for a product
    When I click "Send Message" without entering any text
    Then I should see an error message "Message content cannot be empty"
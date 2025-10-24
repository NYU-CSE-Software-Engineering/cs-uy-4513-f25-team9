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
    And the message should be saved in the conversation

  Scenario: User views their conversation history
    Given I am logged in as a user with existing conversations
    When I visit my messages page
    Then I should see a list of my conversations
    And I should see the last message preview and timestamp for each conversation

  Scenario: User sees unread message notifications
    Given I have unread messages in my conversation
    When I visit the dashboard
    Then I should see a notification indicator for unread messages
    And when I view the conversation
    Then the unread messages should be marked as read

  Scenario: User cannot send empty message
    Given I am logged in as a buyer
    And I am on the message composition page for a product
    When I click "Send Message" without entering any text
    Then I should see an error message "Message content cannot be empty"

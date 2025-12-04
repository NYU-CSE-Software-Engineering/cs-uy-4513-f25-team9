Feature: Buyer swipes through listings
  As a Buyer
  I want to like or pass on listings in a feed
  So that I can quickly shortlist items I care about

  Scenario: Must be logged in to view the feed
    Given I am not logged in
    When I visit the feed
    Then I should be redirected to the login page
    And I should see "Please sign in"

  Scenario: Like saves interest and moves to next card
    Given I am logged in as a buyer for swiping
    And there are multiple swipable listings
    When I visit the feed
    And I note the current listing
    And I click "Like"
    Then an interest should be recorded for that listing with state "liked"
    And I should see the next listing on the feed

  Scenario: Pass saves interest and moves to next card
    Given I am logged in as a buyer for swiping
    And there are multiple swipable listings
    When I visit the feed
    And I note the current listing
    And I click "Pass"
    Then an interest should be recorded for that listing with state "passed"
    And I should see the next listing on the feed

  Scenario: Empty state when no swipable listings remain
    Given I am logged in as a buyer for swiping
    And there are no swipable listings remaining
    When I visit the feed
    Then I should see "You're all caught up"
    And I should see "Adjust filters"

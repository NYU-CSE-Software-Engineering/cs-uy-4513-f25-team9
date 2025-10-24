Feature: Browse and swipe listings
  As a signed-in Buyer
  I want a feed of unswiped listings I can like or pass
  So that I can quickly shortlist items I want to pursue

  Background:
    Given I am a signed-in buyer
    And the following listings exist:
      | title       | category | price_cents | status |
      | Blue Guitar | Music    | 15000       | active |
      | Desk Lamp   | Home     | 3000        | active |
    And I have not swiped any listings

  Scenario: Like saves interest and advances (AC1)
    When I visit the feed
    Then I should see "Blue Guitar"
    When I press "Like"
    Then my like for "Blue Guitar" is saved
    And I should see the next listing card

  Scenario: Pass saves interest and advances (AC2)
    Given I am on the feed
    When I press "Pass"
    Then my pass for the current listing is saved
    And I should see the next listing card

  Scenario: No duplicate likes (AC3)
    Given I have already liked "Blue Guitar"
    When I try to like "Blue Guitar" again from any page
    Then it should not create a duplicate interest

  Scenario: Filtered feed (AC4)
    Given I set the category filter to "Home"
    When I visit the feed
    Then I should not see "Blue Guitar"
    And I should see "Desk Lamp"

  Scenario: Auth required and empty state (AC5)
    Given I am signed out
    When I visit the feed
    Then I should be redirected to the login page

    Given I am a signed-in buyer
    And there are no active, unswiped listings for my filters
    When I visit the feed
    Then I should see "You're all caught up"
    And I should see a link to "Adjust filters"

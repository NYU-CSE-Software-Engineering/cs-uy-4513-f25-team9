Feature: Buyer reports a suspicious or fraudulent listing
  As a Buyer
  I want to report a listing
  So that Moderators can review and take action if needed

  Scenario: Report a listing successfully
    Given I am logged in as a buyer
    And I am viewing a listing that I believe is fraudulent
    When I click "Report listing"
    And I select a reason and submit the report
    Then a report should be recorded for that listing and my account
    And I should see "Thanks—our moderators will review this"
    
  Scenario: Must be logged in to report
    Given I am not logged in
    When I attempt to submit a report for a listing
    Then I should be redirected to the login page
    And I should see "Please sign in to report listings"

Feature: User Login and Registration
  As a new or returning Thryft user
  I want to register for an account and securely log in or out
  So that I can access personalized features like buying, selling, and messaging safely

  Scenario: Successful Sign Up
    Given I am on the sign up page
    When I fill in "Email" with "newuser@example.com"
    And I fill in "Password" with "SecurePassword123"
    And I fill in "Password confirmation" with "SecurePassword123"
    And I click the auth button "Sign up"
    Then I should be redirected to the home page
    And I should see "Welcome! You have signed up successfully."

  Scenario: Sign Up with Password Mismatch
    Given I am on the sign up page
    When I fill in "Email" with "newuser@example.com"
    And I fill in "Password" with "SecurePassword123"
    And I fill in "Password confirmation" with "DifferentPassword"
    And I click the auth button "Sign up"
    Then I should remain on the sign up page
    And I should see "Password confirmation doesn't match Password"

  Scenario: Successful Login
    Given I have an account with email "user@example.com" and password "SecurePassword123"
    And I am on the sign in page
    When I fill in "Email" with "user@example.com"
    And I fill in "Password" with "SecurePassword123"
    And I click the auth button "Log in"
    Then I should be redirected to the home page
    And I should see "Logged in successfully"

  Scenario: Login with Invalid Credentials
    Given I am on the sign in page
    When I fill in "Email" with "user@example.com"
    And I fill in "Password" with "WrongPassword"
    And I click the auth button "Log in"
    Then I should remain on the sign in page
    And I should see "Invalid email or password"

  Scenario: Logout
    Given I am logged in as a user with email "user@example.com" and password "SecurePassword123"
    When I click the profile dropdown button
    And I click the "Log Out" link in the dropdown
    Then I should be redirected to the home page
    And I should see "Logged out"

Feature: User Login and Registration
  As a new or returning Thryft user,
  I want to register for an account and securely log in or out,
  so that I can access personalized features like buying, selling, and messaging safely.
  
  Scenario: User successfully signs up
    Given I am on the Sign Up page
    When I fill in "Email" with "newuser@example.com"
    And I fill in "Password" with "Password!23"
    And I fill in "Password confirmation" with "Password!23"
    And I press the "Sign up" button
    Then I should be redirected to the Home page
    And I should see the message "Welcome! You have signed up successfully."
    And I should see the "Log out" link

  Scenario: User fails to sign up due to password mismatch
    Given I am on the Sign Up page
    When I fill in "Email" with "baduser@example.com"
    And I fill in "Password" with "Password!23"
    And I fill in "Password confirmation" with "Different!23"
    And I press the "Sign up" button
    Then I should see the error message "Password confirmation doesn't match Password"
    And I should remain on the Sign Up page

  Scenario: Registered user successfully logs in
    Given a User exists with email "member@example.com" and password "Password!23"
    And I am on the Sign In page
    When I fill in "Email" with "member@example.com"
    And I fill in "Password" with "Password!23"
    And I press the "Log in" button
    Then I should be redirected to the Home page
    And I should see the message "Signed in successfully."
    And I should see the "Log out" link

  Scenario: User fails to log in with invalid credentials
    Given a User exists with email "wrong@example.com" and password "Password!23"
    And I am on the Sign In page
    When I fill in "Email" with "wrong@example.com"
    And I fill in "Password" with "Invalid123"
    And I press the "Log in" button
    Then I should see the error message "Invalid Email or password."
    And I should remain on the Sign In page

  Scenario: Signed-in user logs out
    Given I am signed in as "member@example.com" with password "Password!23"
    When I click the "Log out" link
    Then I should be redirected to the Home page
    And I should see the message "Signed out successfully."
    And I should see the "Log in" link

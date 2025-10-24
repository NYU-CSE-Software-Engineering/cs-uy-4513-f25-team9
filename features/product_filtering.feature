Feature: Buyer Listing Filtering
  As a Buyer on Thryft
  I want to filter listings by category
  So that I can find what I'm looking for faster

  Background:
    Given the following listings exist:
      | name                      | category    | price |
      | "Used Psychology Textbook" | "Books"     | 45    |
      | "Desk Lamp"               | "Furniture" | 15    |
      | "Introduction to Algo"    | "Books"     | 60    |
      | "Mini Fridge"             | "Furniture" | 75    |

  Scenario: Buyer successfully filters for books
    Given I am on the listings page
    When I select "Books" from the "Category" filter
    And I press "Filter"
    Then I should see "Used Psychology Textbook"
    And I should not see "Desk Lamp"

  Scenario: Buyer filters for a category with no listings
    Given I am on the listings page
    When I select "Electronics" from the "Category" filter
    And I press "Filter"
    Then I should see the message "No listings found in this category."
# Feature Design: Buyer Filtering Listings

## User Story

As a **Buyer**, I want to filter the listings by category, so that I can more easily find items I am interested in purchasing.

## Acceptance Criteria

* **Criterion 1 (Happy Path)**: When I select a specific category (e.g., "Books"), the page should only display listings from that category.
* **Criterion 2 (Happy Path - Different Category)**: When I select another category (e.g., "Furniture"), the page should only display listings from that category.
* **Criterion 3 (Sad Path - No Results)**: If I select a category that has no listings, the page should display a clear message like "No listings found in this category."

## MVC Components Outline

* **Model(s)**:
    * `Listing` model: This existing model will be queried to find all listings that match the selected category.

* **View(s)**:
    * `listings/index.html.erb`: This view will be modified to include a form with a category filter (e.g., a dropdown menu). The list of displayed listings will depend on the filter selection.

* **Controller(s)**:
    * `ListingsController`: The `index` action will be modified to check for a category parameter from the filter form. If a category is present, it will query the `Listing` model with that condition.
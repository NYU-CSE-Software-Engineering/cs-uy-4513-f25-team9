# User Story

## Feature: Seller Manage Listings
As a seller, I want to manage my product listings so that I can sell items on the platform.

## Acceptance Criteria

1. A seller can create a new listing with name, price, and description
2. A seller can view their existing listings
3. A seller can update an existing listing's information
4. A seller can delete a listing they no longer want to sell
5. System displays appropriate error messages when attempting operations on non-existent listings or with invalid data

# MVC Component Outline

**Model(s):** A Listing model with name:string, price:decimal, description:text, user_id:integer, and is_deleted:boolean attributes

**View(s):** 
- listings/index.html.erb - page showing all seller's listings
- listings/new.html.erb - form to create a new listing
- listings/edit.html.erb - form to update an existing listing
- listings/show.html.erb - page showing single listing details

**Controller(s):** A ListingsController with the following actions:
- index - display all listings
- new - render create form
- create - handle listing creation
- show - display single listing
- edit - render edit form
- update - handle listing updates
- destroy - handle listing deletion


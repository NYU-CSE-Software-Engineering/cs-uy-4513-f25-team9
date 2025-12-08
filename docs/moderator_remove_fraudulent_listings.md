# User Story

## Feature: Moderator Removes Fraudulent Products
As a moderator, I want to remove listings that are reported as fraudulent so that the platform stays safe.

## Acceptance Criteria

1. A moderator can view all reported listings pending review
2. A moderator can mark a reported listing as fraudulent and delete it
3. Non-moderators cannot access the reported listings page
4. System displays appropriate error messages when attempting to delete non-existent listings
5. Successfully deleted listings are marked as deleted in the database

# MVC Component Outline

**Model(s):** A Listing model with name:string, price:decimal, is_deleted:boolean attributes, and a Flag model with listing_id:integer, report_reason:text, processed:boolean attributes

**View(s):** 
- moderations/reported_listings.html.erb - page showing all reported listings pending review
- moderations/delete_confirmation.html.erb - confirmation page after successful deletion
- moderations/access_denied.html.erb - 403 error page for unauthorized access

**Controller(s):** A ModerationsController with the following actions:
- reported_listings - display all reported listings
- confirm_remove - handle fraudulent listing deletion
- delete_confirmation - show success confirmation
- access_denied - show access denied page
- authenticate_moderator! - verify user has moderator role


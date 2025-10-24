# Swiping & Browsing

## Feature Summary
Buyers see a card-style feed of **unswiped** listings and can **swipe right (Like)** or **swipe left (Pass)** to quickly shortlist items.

## User Story
As a **Buyer**, I want a **feed of unswiped listings** where I can **like or pass** so that I can **quickly shortlist items to pursue**.

## Acceptance Criteria
1. **Like → Next Card:** From the feed, pressing **Like** saves an interest `liked` and advances to the **next unswiped** card.
2. **Pass → Next Card:** Pressing **Pass** saves an interest `passed` and advances to the **next unswiped** card.
3. **No Duplicates / Idempotent:** Previously swiped listings never reappear; liking an already liked listing is idempotent (no duplicate record).
4. **Filters Honored:** Category/price filters constrain both what is shown and what can be swiped.
5. **Empty State:** If no eligible listings remain, show **“You’re all caught up”** and a link to **Adjust filters**.
6. **Auth Required:** Unauthenticated users who visit the feed or submit a swipe are redirected to **Login**.

## Module Dependencies
- **User & Identity Management**: required for authentication/roles (Buyer).

## MVC Outline
- **Models:** `Listing(active)`, `Interest(buyer_id, listing_id, state)` with unique `(buyer_id, listing_id)`.  
- **Controller:** `FeedController#index` (next active, unswiped; honors filters), `SwipesController#create` (record like/pass; redirect to /feed).  
- **View:** `feed/index` shows one card with Like/Pass and minimal filters.

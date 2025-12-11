# Thryft

CS-UY 4513 Software Engineering Project

The system, named Thryft, will be a centralized platform for buying and selling goods through a liking-based interface inspired by Tinder. It is intended to be used by students, local sellers, and administrators who want a streamlined, engaging way to exchange goods. It features user authentication, listings, messaging, moderation, and more.
**We are online! [thryft-team9-34327d4250fb.herokuapp.com](https://thryft-team9-34327d4250fb.herokuapp.com/)**

---

## Table of Contents

- [Features](#features)
- [API & Routes Overview](#api--routes-overview)
- [Core Domain Concepts](#core-domain-concepts)
- [Navigation Overview](#navigation-overview)
- [Getting Started](#getting-started)
- [Running the App](#running-the-app)
- [Testing](#testing)
- [Future Improvements](#future-improvements)
- [Contributions](#contributions)

# Contributions

# Team & Contributions

| Name            | Major Contributions                                                                   |
| --------------- | ------------------------------------------------------------------------------------- |
| Raymond Lin     | [Moderator Remove Users and Front end ](docs/moderation_remove_users.md)              |
| Anthony Lamelas | [CRUD Operations for Listings and Create and manage sellers](docs/listings.md)        |
| Edward Kang     | [User Login and Registration](docs/user_login_registration.md)                        |
| Alicia Tian     | [Product Listing Filtering](docs/product_filtering.md)                                |
| Karl            | [Recording swipe actions](docs/product_filtering.md)                                  |
| Uriel Olayinka  | [Messaging System](docs/messaging_system.md)                                          |
| Pengcheng Wang  | [Moderation Remove Fraudulent Listings](docs/moderator_remove_fraudulent_listings.md) |

See the linked documents for detailed writeups on each feature.

---

## Features

### Authentication, Sessions & Security

- User registration, login, and logout
- Session helpers for authentication and role-based access
- Role-based guards for restricted features (user, moderator, admin)

### Listings & Purchases

- Users can create, edit, and delete listings
- Listings can be browsed, filtered, and purchased
- Moderation tools for removing fraudulent listings

### Messaging & Notifications

- Direct messaging between users
- Notifications for purchases, messages, and moderation actions

### Moderation & Reporting

- Users can report listings or users
- Moderators can remove users or listings

### Liking & Feed

- Browse listings with a like and pass interface
- Personalized feed based on user activity

---

## API & Routes Overview

The application exposes a RESTful interface. Below are the key endpoints based on the current implementation:

### Authentication

- `POST /login` — Log in a user
- `DELETE /logout` — End the current session
- `GET /login` — Login form
- `GET /logout` — End the current session (GET alternative)
- `POST /users` — Register a new user account

### Listings & Reports

- `GET /listings` — List all listings (supports filtering, search, sort)
- `GET /listings/:id` — View a specific listing
- `POST /listings` — Create a new listing
- `PATCH/PUT /listings/:id` — Update a listing
- `DELETE /listings/:id` — Delete a listing
- `GET /listings/:listing_id/reports/new` — Report a listing (form)
- `POST /listings/:listing_id/reports` — Submit a report for a listing
- `GET /my_listings` — View your own listings
- `GET /liked_listings` — View listings you have liked
- `GET /seller_home` — Seller dashboard

### Conversations & Messages

- `GET /conversations` — List all conversations for current user
- `GET /conversations/:id` — View a specific conversation
- `POST /listings/:listing_id/conversations` — Start a new conversation about a listing
- `POST /conversations/:conversation_id/messages` — Send a message in a conversation

### Feed & Like

- `GET /feed` — Personalized feed (listings to swipe)
- `POST /swipes` — Like or pass on a listing

### Purchases

- `GET /purchases` — View your purchase history

### Moderation

- `GET /moderations/user_list` — List all users (admin/moderator)
- `GET /moderations/reported_listings` — List all reported listings
- `DELETE /moderations/listings/:id` — Remove a listing (moderator)
- `DELETE /moderations/users/:id` — Remove a user (moderator)
- `PATCH /moderations/users/:id/remove_moderator` — Remove moderator role from a user (admin)

---

## Core Domain Concepts

### User

- Has authentication fields (email, password)
- Role fields: `is_moderator`, `is_admin` (supports user, moderator, admin roles)
- Owns listings, purchases, reports, interests
- Can be a buyer or seller in conversations/messages
- Helper methods for role checks and permissions

### Listing

- Belongs to a user (the seller)
- Has many reports, interests, and an attached image
- Can be filtered by category, price, search, and ownership
- Cannot be purchased more than once (enforced by scopes)

### Conversation

- Represents a chat between a buyer and seller about a listing
- Belongs to a buyer, seller, and listing
- Has many messages
- Ensures buyer and seller are different users

### Message

- Belongs to a user and a conversation
- Contains message content and read/unread state
- Tracks unread messages for users

### Purchase

- Belongs to a buyer (user) and a listing
- Represents a completed transaction

### Interest

- Belongs to a buyer (user) and a listing
- Tracks whether a user has liked or passed on a listing (swipe state)
- Enforces uniqueness per buyer-listing pair

### Report

- Belongs to a user and a listing
- Contains a reason for reporting (with length validation)

---

---

## Navigation Overview

The main navigation (in `app/views/layouts/application.html.erb`) includes:

- **Home** – Dashboard / welcome page
- **Listings** – Browse, filter, and search all items for sale
- **My Listings** – Manage your own listings (edit, delete, view)
- **My Feed** – Personalized activity feed (swipe to like/pass, see new items)
- **Messages** – Direct messages inbox (conversations about listings)
- **Notifications** – Alerts for purchases, messages, and moderation
- **Moderation** – Admin/moderator tools (remove users/listings, view reports)
- **Settings** – Account settings (profile, password)
- **Log out** – End session

---

## My Feed

The My Feed feature is implemented in:

- `app/controllers/feed_controller.rb`
- `app/views/feed/index.html.erb`

**Controller responsibilities:**

- Shows listings not owned or already purchased by the user
- Applies filters: category, price range, search query
- Excludes listings the user has already swiped (liked/passed)
- Presents the next available listing to swipe

**View responsibilities:**

- Displays listing details and swipe actions (like/pass)
- Shows empty state if no more listings are available

---

## Following, Swiping, and Interests

- Users can swipe (like/pass) on listings in the feed
- Swipes are tracked as `Interest` records (liked or passed)
- Liked listings can be revisited; passed listings are hidden from the feed
- Moderators can view reported listings and users

---

## Architecture Notes

**Controllers:**

- `ApplicationController` – authentication helpers, current user, login required
- `UsersController` – user registration and profile
- `ListingsController` – CRUD for listings, filtering, sorting
- `FeedController` – personalized feed and swipe logic
- `MessagesController` – direct messages within conversations
- `ConversationsController` – manages buyer/seller chat about listings
- `PurchasesController` – handles purchases and purchase history
- `ReportsController` – reporting listings for moderation
- `ModerationsController` – admin/moderator actions (remove users/listings)
- `SwipesController` – handles swipe actions (like/pass)

**Models:**

- `User`, `Listing`, `Conversation`, `Message`, `Purchase`, `Interest`, `Report`

**Other notes:**

- Uses Rails scopes for filtering and searching listings
- Moderation actions are protected by role-based before_actions
- All user actions require authentication (except registration/login)

---

---

## Getting Started

### Requirements

- Ruby 3.4.7
- Rails 8.1.0
- Postgres

### Setup

Clone the repo below:

```sh
git clone https://github.com/NYU-CSE-Software-Engineering/cs-uy-4513-f25-team9.git
cd cs-uy-4513-f25-team9
```

After cloning the repo and having the necessary Ruby and Rails versions, run:

```sh
bundle install
```

#### Installing Postgres and Setting Up Local Database

**Linux (Ubuntu):**

```sh
sudo apt update
sudo apt install postgresql postgresql-contrib
sudo -u postgres createuser --superuser $(whoami)
```

**MacOS:**

```sh
brew install postgresql
brew services start postgresql
createuser --superuser $(whoami)
```

If you are having Postgres login issues do the following:
Uncomment lines `12-14` and `19-21` in `database.yml` to use your credentials. Make sure to update your .env with
your POSTGRES password.

**Windows:**
Just use WSL and follow the Linux instructions. Makes life easier. Trust me.

#### Database Initialization

Run this when setting up the project for the first time:

```sh
rails db:setup
rails db:migrate
rails db:seed
```

## Running the App

Run the script:

```sh
bin/dev
```

### If CSS changes are not showing up

Sometimes, after adding or editing stylesheets, you may need to recompile Rails assets to see the changes:

```sh
bundle exec rails assets:clobber && bundle exec rails assets:precompile
```

Then restart your Rails server and refresh your browser (clear cache if needed).

---

## Testing

**Rspec:**

```sh
bundle exec rspec
```

**Cucumber:**

```sh
bundle exec cucumber
```

## User Story
As a user, I want to send and receive messages about products so that I can ask questions, negotiate prices, and inquire with other users about potential purchases.

## Acceptance Criteria
1. A buyer can successfully send a message to a seller about a product listing
2. Users can view all messages in a conversation thread
3. Users can see whwen they have unread messages or likes on their product with notifications
4. A user cannot send an empty message

## MVC Components Outline

### Models
- A Message model with content:text, read:boolean, user_id:references attributes
- A Conversation model with buyer_id:references, seller_id:references, listing_id:references

### Views
- conversations/index.html.erb - Lists all of user's conversations
- conversations/show.html.erb - Shows individual conversation with reply form

### Controllers
- ConversationsController (index, show, create)
- MessagesController (create, update)

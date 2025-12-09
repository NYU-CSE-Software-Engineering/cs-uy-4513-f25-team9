# User Story

## Feature: User Login and Registration

As a new or returning Thryft user,
I want to register for an account and securely log in or out,
so that I can access personalized features like buying, selling, and messaging safely.

### Acceptance Criteria

#### **Criterion 1 (Happy Path – Successful Sign Up)**

When I correctly fill in all required registration fields (Email, Password, and Password Confirmation),  
the system should create my account, redirect me to the Home page, and display a success message:  
**“Welcome! You have signed up successfully.”**

---

#### **Criterion 2 (Sad Path – Password Mismatch)**

When I enter a password that doesn’t match the password confirmation,  
the system should not create my account and should display an error message:  
**“Password confirmation doesn't match Password.”**

---

#### **Criterion 3 (Happy Path – Successful Login)**

When I log in using a valid registered email and password,  
I should be redirected to the Home page, see the message  
**“Signed in successfully.”**,  
and have access to a **“Log out”** link.

---

#### **Criterion 4 (Sad Path – Invalid Login)**

When I enter an incorrect email or password,  
I should remain on the Sign In page and see the error message:  
**“Invalid Email or password.”**

---

#### **Criterion 5 (Happy Path – Logout)**

When I click the **“Log out”** link while signed in,  
I should be redirected to the Home page, see  
**“Signed out successfully.”**,  
and the **“Log in”** link should reappear.

---

# MVC Component Outline

Model:  
A **User** model with the following attributes:

- `email:string`
- `encrypted_password:string`
- `role:string` (optional, used for authorization)  
  Validations ensure presence and uniqueness of email and proper password confirmation.  
  Authentication is handled using **Devise**.

Views:

- `devise/registrations/new.html.erb`: Registration (Sign Up) form for new users.
- `devise/sessions/new.html.erb`: Login (Sign In) form for existing users.
- Shared layout includes a navigation bar displaying:
  - “Log in / Sign up” links when logged out
  - “Log out” link when logged in

Controllers:

- **Devise::RegistrationsController**: Handles new user registration (`new`, `create`)
- **Devise::SessionsController**: Handles user login/logout (`new`, `create`, `destroy`)
- **HomeController**: Displays the home or dashboard page depending on authentication status

# AO CHEF

Nella nostra piattaforma ci sono tre utenti:

-   Chef
-   Customer (con la possibilità di diventare utente Pro)
-   Admin

`Verified user` -> Utente che

-   si è registrato con email e password e ha verificato la propria email.
-   si è registrato con OAuth

`Completed user` -> 'Verified user' che ha completato il proprio profilo

`Unverified user` -> Utente che si è registrato con email e password ma non ha verificato la propria email

**Le seguenti feature sono contestuali alla registrazione e login.**

# Login e registrazione di utenti

Di seguito sono elencate le user stories per la registrazione e il login degli utenti, con e senza OAuth, con la possibilità di completare il proprio profilo e di recuperare la password.

## Feature 1: End user registration with email and password

As a new user  
I want to register to the platform  
So that I can create an unverified account

### Scenario 1: User registers with valid email and password

Given I am on the registration page  
When I fill in the registration form with valid email and password  
Then I receive a confirmation email with a verification code
And I am redirected to a code verification page

### Scenario 2: User registers with invalid email and password

Given I am on the registration page  
When I fill in the registration form with invalid email and password  
Then I should see an error message

## Feature 2: End user registration with OAuth

As a new user  
I want to register to the platform  
So that I can become a verified user

### Scenario 1: Fail OAuth authentication

Given I am on the registration page  
When I click on the OAuth button
Then I should be redirected to the OAuth provider
And When I fail to authenticate
Then I should see an error message

### Scenario 2: Successful OAuth authentication

Given I am on the registration page  
When I click on the OAuth button
Then I should be redirected to the OAuth provider
And when I authenticate successfully
Then I should be redirected to profile completion page

## Feature 3: Account verification

As an unverified user  
I want to verify my account  
So that I can become a verified user

### Scenario 1: User verifies account with valid code

Given I am on the code verification page  
When I fill in the code verification form with a valid code  
Then I should be redirected to the profile completion page

### Scenario 2: User verifies account with invalid code

Given I am on the code verification page  
When I fill in the code verification form with an invalid code  
Then I should see an error message  
And I can request a new code

### Scenario 3: User requests new verification code

Given I am on the code verification page  
When I request a new verification code  
Then I should receive a new email with a new verification code

## Feature 4: Profile completion

As a verified user  
I want to complete my profile  
So that I can become a chef or a customer

### Scenario 1: User completes profile as a chef with valid data

Given I am on the profile completion page  
When I choose to complete my profile as a chef  
And I fill in the profile completion form with valid data  
Then I should be redirected to the chef homepage

### Scenario 2: User completes profile as a customer with valid data

Given I am on the profile completion page  
When I choose to complete my profile as a customer  
And I fill in the profile completion form with valid data  
Then I should be redirected to the customer homepage

### Scenario 3: User completes profile with invalid data

Given I am on the profile completion page  
When I fill in the profile completion form with invalid data  
Then I should see an error message

## Feature 5: Login with email and password

As a registered user  
I want to login to the platform  
So that I can access my account

### Scenario 1: User logs in as a completed user

Given I am on the login page  
When I fill in the login form with valid email and password
And I submit the form  
And I am a completed user  
Then I am redirected to my homepage

### Scenario 2: User logs in as a verified user

Given I am on the login page  
When I fill in the login form with valid email and password  
And I submit the form  
And I am a verified user  
Then I am redirected to the profile completion page

### Scenario 3: User logs in as an unverified user

Given I am on the login page  
When I fill in the login form with valid email and password  
And I submit the form  
And I am an unverified user  
Then I receive a confirmation email with a verification code  
And I am redirected to the code verification page

### Scenario 4: User logs in with invalid email and password

Given I am on the login page  
When I fill in the login form with invalid email and password  
And I submit the form  
Then I should see an error message

## Feature 6: Login with OAuth

As a registered user  
I want to login to the platform  
So that I can access my homepage

### Scenario 1: User logs in with OAuth as a completed user

Given I am on the login page  
When I click on the OAuth button  
And I authenticate successfully  
And I am a completed user  
Then I am redirected to my homepage

### Scenario 2: User logs in with OAuth as a verified user

Given I am on the login page  
When I click on the OAuth button  
And I authenticate successfully  
And I am a verified user  
Then I am redirected to the profile completion page

### Scenario 3: User fails to authenticate with OAuth

Given I am on the login page  
When I click on the OAuth button  
And I fail to authenticate  
Then I should see an error message

## Feature 7: Password recovery request

As a user  
I want to request a password recovery code  
So that I can change my password

### Scenario 1: Registered user requests password recovery

Given I am on the login page  
When I click on the password recovery link  
And I am redirected to the password recovery page  
And I fill in the password recovery form-email with my email  
Then I should receive an email with a verification code  
And I should see the code verification form

### Scenario 2: Unregistered user requests password recovery

Given I am on the login page  
When I click on the password recovery link  
And I am redirected to the password recovery page  
And I fill in the password recovery form-email with an unregistered email  
Then I should see the code verification form (_even though I don't have the code_)

## Feature 8: Password recovery verification

As a user  
I want to change my password  
So that I can login to my account

### Scenario 1: User verifies password recovery with valid code and new valid password

Given I am on the password recovery page and I see the code verification form  
When I fill in the code verification form with a valid code  
Then I should see the new password form  
And I fill in the new password form with a new valid password  
Then I should be redirected to the login page

### Scenario 2: User verifies password recovery with invalid code

Given I am on the password recovery page and I see the code verification form  
When I fill in the password recovery form with an invalid code  
Then I should see an error message  
And I can request a new code with a link

### Scenario 3: Registered user requests new password recovery code

Given I am on the password recovery page and I see the code verification form and I see the re-send code verification link  
When I click on the request new code link  
Then I should see a success message  
And I should receive a new email with a new verification code

### Scenario 4: Unregistered user requests new password recovery code

Given I am on the password recovery page and I see the code verification form and I see the re-send code verification link  
And the email I inserted is not registered  
When I click on the request new code link  
Then I see a success message  
And I should not receive an email with a new verification code

## Feature 9: Logout

As a logged user  
I want to logout

### Scenario 1: Logged user logs out

Given I am on a page  
When I click on the profile icon and I click on logout  
Then I should be logout

## Feature 10: Searching menu in the homepage

As a logged client or unlogged user  
I want to search for a menu  
So that I can find the menu I want

### Scenario 1: User searches with the default search bar

Given I am on the homepage (_the homepage of a client or unlogged user_)  
And I compile every field of the default search bar (_localizzazione, n. persone, data con pranzo o cena ed allergeni_)  
And I click on the search icon  
Then I should see below the menus that match my search

### Scenario 2: User searches with the default search bar without compiling every field

Given I am on the homepage  
And I do not compile every field of the default search bar  
And I click on the search icon  
Then I should receive an error message that says that I have to compile every field in order to search

### Scenario 3: User searches with filters without having searched with the default search bar

Given I am on the homepage  
And I click on a type of menu (_terra, mare, indiano etc._)  
Then I should see below the menus that match my search

### Scenario 4: User searches with filters having searched with the default search bar

Given I am on the homepage  
And I have already searched with the default search bar  
And I click on a type of menu  
Then I should see below the menus of my previous search filtered by the type of menu I clicked on

### Scenario 5: User searches with advanced filters without having searched with the default search bar

Given I am on the homepage
And I click on the filter icon  
Then I should see a popup with the advanced filtering options  
And I select the filters I want  
And I click on the submit button  
Then the popup should close and I should see below the menus that match my search

### Scenario 6: User searches with advanced filters having searched with the default search bar

Given I am on the homepage  
And I have already searched with the default search bar  
And I click on the filter icon  
Then I should see a popup with the advanced filtering options  
And I select the filters I want  
And I click on the submit button  
Then the popup should close and I should see below the menus of my previous search filtered by the filters I selected

### Scenario 7: User searches with advanced filters having searched with the filters

Given I am on the homepage  
And I have already searched with the filters (_type of menu_)  
And I click on the filter icon  
Then I should see a popup with the advanced filtering options  
And I select the filters I want  
And I click on the submit button  
Then the popup should close and I should see below the menus of my previous search, already filtered by the type of menu, filtered again by my selections

### Scenario 8: User searches with filters having searched with advanced filters

Given I am on the homepage  
And I have already searched with the advanced filters  
And I click on a type of menu  
Then I should see below the menus of my previous search, already filtered by the advanced filters, filtered again by the type of menu I clicked on

### Scenario 9: User searches with no match

Given I am on the homepage  
And I search (_with the default search bar or filters or advanced filters_)  
And no menu matches my search  
Then I should see a message that says that there are no menus that match my search

### Scenario 10: User sort the search

Given I am on the homepage  
And I click on the sort icon  
Then I should see a popup with the sorting options  
And I select the option I want  
And I click on the submit button  
Then the popup should close and I should see below the menus of my previous search sorted

## Feature 11: Menu selection

As a logged client or unlogged user  
I want to select a menu  
So that I can view more details about it

### Scenario 1: User selects a menu

Given I am on the homepage  
And I see a menu that I like  
And I click on the menu  
Then I should be redirected to the menu page

### Scenario 2: User selects a menu after having searched using the default search bar

Given I am on the homepage
And I have searched using the default search bar
And I see a menu that I like
And I click on the menu
Then I should be redirected to the menu page with the search fields already compiled in the page (both the search bar in the header and the reservation card in the menu page)

# Chef

## Feature 12: Chef Menus

As a logged chef  
I want to see my menus
So that I can manage them

### Scenario 1: Chef sees his last menus from the homepage

Given I am on the homepage  
Then I should see my last menus (_ordered by date of creation_)

### Scenario 2: Chef sees all his menus from the menus page

Given I am on every page  
And I click on the menus link in the header  
Then I should be redirected to the menus page  
And I should see all my menus

### Scenario 3: Chef sees all his menus from the homepage

Given I am on the homepage  
And I click on the "Mostra tutti" button in the "I tuoi menu" section  
Then I should be redirected to the menus page  
And I should see all my menus

## Feature 13: Chef Single Menu

As a logged chef  
I want to see a single menu  
So that I can manage it

### Scenario 1: Chef sees a single menu from the menus page

Given I am on the menus page  
And I click on a menu  
Then I should be redirected to the menu page

### Scenario 2: Chef sees a single menu from the homepage

Given I am on the homepage  
And I click on a menu  
Then I should be redirected to the menu page

### Scenario 3: Chef sees a single menu from a reservation page

Given I am on a reservation page  
And I click on the menu link  
Then I should be redirected to the menu page

## Feature 14: Chef Reservations

As a logged chef
I want to see my reservations
So that I can manage them

### Scenario 1: Chef sees a few active reservations from the homepage

Given I am on the homepage  
Then I should see a few active reservations (_ordered by date of the reservation_)

### Scenario 2: Chef sees all his reservations from the reservations page

Given I am on every page  
And I click on the reservations link in the header  
Then I should be redirected to the reservations page  
And I should see all my reservations

### Scenario 3: Chef sees all his reservations from the homepage

Given I am on the homepage  
And I click on the "Mostra tutti" button in the "Le tue prenotazioni" section  
Then I should be redirected to the reservations page  
And I should see all my reservations

### Scenario 4: Chef sees the last reservations from the menu page

Given I am on a menu page  
Then I should see the last reservations of that menu (_ordered by date of the reservation_)

## Feature 15: Chef Single Reservation

As a logged chef  
I want to see a single reservation  
So that I can manage it

### Scenario 1: Chef sees a single reservation from the reservations page

Given I am on the reservations page  
And I click on a reservation  
Then I should be redirected to the referred reservation page

### Scenario 2: Chef sees a single reservation from the homepage

Given I am on the homepage  
And I click on a reservation in the last reservations section  
Then I should be redirected to the referred reservation page

### Scenario 3: Chef sees a single reservation from a menu page

Given I am on a menu page  
And I click on a reservation on the reservations list of that menu  
Then I should be redirected to the referred reservation page

### Scenario 4: Chef sees a single reservation from a review

Given I am on the homepage  
And I click on a review  
Then I should be redirected to the referred reservation page

## Feature 16: Chef reviews

As a logged chef  
I want to see the reviews  
So that I can improve my service

### Scenario 1: Chef sees the last reviews from the homepage

Given I am on the homepage  
Then I should see the last reviews of my menus (_ordered by date of the reservation_)

### Scenario 2: Chef sees the reviews from a menu page

Given I am on a menu page  
Then I should see the reviews of that menu (_ordered by date of the reservation_)

### Scenario 3: Chef sees the review from a reservation page

Given I am on a reservation page  
And the user has left a review  
Then I should see the personal review of that reservation and the menu review

### Scenario 4: Chef sees the reviews average

Given I am on every page  
Then I should see the average of the personal reviews I received

## Feature 17: Chef leaves a review

As a logged chef  
I want to leave a review  
So that I can give feedback to the user

### Scenario 1: Chef leaves a review from a reservation page

Given I am on a reservation page  
And I compile the review form  
Then I should see a success message  
And not be able to leave another review

## Feature 18: Chef chats

As a logged chef  
I want to see my chats

### Scenario 1: Chef sees his chats from the header

Given I am on every page  
And I click on the chat icon in the header  
Then I should be redirected to the chats page  
And I should see all my chats

## Feature 19: Chef Single Chat

As a logged chef  
I want to see a single chat  
So that I can chat with the user

### Scenario 1: Chef sees a single chat from the chats page

Given I am on the chats page  
And I click on a chat  
Then I should see all the messages of that chat

### Scenario 2: Chef sees a single chat from the reservation page

Given I am on a reservation page  
And I click on the chat button near the user's name  
Then I should be redirected to the referred chat page  
And I should see all the messages of that chat

## Feature 20: Chef sends a message

As a logged chef  
I want to send a message  
So that I can chat with the user

### Scenario 1: Chef sends a message from a chat page

Given I am on a chat page  
And I compile the message form  
Then I should see the message I sent in the chat

## Feature 21: Chef profile edit

As a logged chef  
I want to edit my profile  
So that I can update my informations

### Scenario 1: Chef edits his profile

Given I am on the profile page  
And I click on the edit button  
And I compile the form  
Then I should see a success message  
And I should see the updated informations

### Scenario 2: Chef edits his profile with invalid data

Given I am on the profile page  
And I click on the edit button  
And I compile the form with invalid data  
Then I should see an error message]

## Feature 21: Chef profile

As a logged chef  
I want to see my profile  
So that I can see and edit my informations

### Scenario 1: Chef sees his profile from the header

Given I am on every page  
And I click on the profile link in the header  
Then I should be redirected to the profile page

## Feature 22: Chef menu creation

As a logged chef  
I want to create a menu  
So that I can receive reservations

### Scenario 1: Chef creates a menu

Given I am on the menu creation page  
And I compile correctly the form  
Then I should see a success message  
And I should be redirected to the menu page

### Scenario 2: Chef creates a menu with invalid data

Given I am on the menu creation page  
And I compile the form with invalid data  
Then I should see an error message

## Feature 23: Chef menu deactivation

As a logged chef  
I want to deactivate a menu  
So that I can stop receiving reservations for that menu

### Scenario 1: Chef deactivates a menu

Given I am on the menu page  
And I click on the deactivate button  
Then I should see a success message  
And I should see the menu as deactivated

## Feature 24: Chef menu activation

As a logged chef  
I want to activate a menu  
So that I can start receiving reservations for that menu

### Scenario 1: Chef activates a menu

Given I am on the menu page  
And I click on the activate button  
Then I should see a success message  
And I should see the menu as activated

## Feature 25: Chef reservation rejection

As a logged chef  
I want to reject a reservation

### Scenario 1: Chef rejects a reservation

Given I am on the reservation page  
And the time to reject the reservation has not expired  
And I click on the reject button  
Then I should see a success message

## Scenario 2: Time to reject a reservation expired

Given I am on the reservation page  
And the time to reject the reservation expired  
Then I should see a message that says that I can't reject the reservation anymore

TODO: inserire le opzioni cliccabili dall'icona 'profilo' a partire dall'homepage e in generale da quell'header

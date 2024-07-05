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
Then I should see the code verification form (*even though I don't have the code*)


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
Given I am on the homepage (*the homepage of a client or unlogged user*)   
And I compile every field of the default search bar (*localizzazione, n. persone, data con pranzo o cena ed allergeni*)  
And I click on the search icon  
Then I should see below the menus that match my search

### Scenario 2: User searches with the default search bar without compiling every field
Given I am on the homepage  
And I do not compile every field of the default search bar  
And I click on the search icon  
Then I should receive an error message that says that I have to compile every field in order to search  

### Scenario 3:  User searches with filters without having searched with the default search bar
Given I am on the homepage  
And I click on a type of menu (*terra, mare, vegano, etc.*)   
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
And I have already searched with the filters (*type of menu*)  
And I click on the filter icon  
Then I should see a popup with the advanced filtering options  
And I select the filters I want  
And I click on the submit button  
Then the popup should close and I should see below the menus of my previous search, already filtered by the type of menu, filtered again by my selections 

### Scenario 8: User searches with filters having searched with advanced filters
Given I am on the homepage  
And I have already searched with the advanced filters  
And I click on a type of menu  
Then I should see below **only** the menus that match   the search with the filters (*only the type of menu and NOT the advanced filters*)

### Scenario 9: User searches with no match
Given I am on the homepage  
And I search (*with the default search bar or filters or advanced filters*)    
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

## Feature 12: 
TODO: inserire le opzioni cliccabili dall'icona 'profilo' a partire dall'homepage e in generale da quell'header


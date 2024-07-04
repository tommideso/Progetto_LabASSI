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
Then I should be redirected to the chef dashboard

### Scenario 2: User completes profile as a customer with valid data

Given I am on the profile completion page  
When I choose to complete my profile as a customer  
And I fill in the profile completion form with valid data  
Then I should be redirected to the customer dashboard

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
Then I am redirected to my dashboard

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
So that I can access my dashboard

### Scenario 1: User logs in with OAuth as a completed user

Given I am on the login page  
When I click on the OAuth button  
And I authenticate successfully  
And I am a completed user  
Then I am redirected to my dashboard

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
TODO

**Le feature successive sono contestuali alla pagina principale.**


@LOGI-18
Feature: Login functionality

  Scenario: Verify login functionality
    Given user is on login page
    When user enters valid credentials
    Then user should login successfully
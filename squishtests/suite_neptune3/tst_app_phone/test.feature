Feature: Test phone app functionality

  Test some features of the phone app.

  Scenario Outline: Open phone app from launcher bar and switch

    Given main menu is open
    And 'phone' app from launcher tapped
    And switch app to 'phone'
    Then wait '1' seconds and 'phone' app is active
    And tap phone '<views>' button
    And phone view '<views>' should be displayed

  Examples:
       | views     |
       | contacts  |
       | recents   |
       | favorites |
       | keypad    |


Scenario Outline: Call people from different views directly

    Given main menu is open
    And 'phone' app from launcher tapped
    And switch app to 'phone'
    Then wait '1' seconds and 'phone' app is active
    And tap phone '<views>' button
    And phone view '<views>' should be displayed
    When tapping call icon of '<views>' entry '<calling>'
    Then number from entry '<views>' should be called

  Examples:
       | views     |  calling |
       | favorites |     2    |
       | contacts  |     3    |
       | contacts  |     6    |
       | favorites |     4    |


Scenario Outline: Call a number from numpad

    Given main menu is open
    And 'phone' app from launcher tapped
    And switch app to 'phone'
    Then tap phone 'keypad' button
    When tapping the buttons in order '<number>'
    Then number '<number>' should be displayed
     And clear number display

  Examples:
    | number     |
    | 023456789  |
    | 028891123  |

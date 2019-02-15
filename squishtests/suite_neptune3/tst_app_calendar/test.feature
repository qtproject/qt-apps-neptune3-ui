Feature: Test calendar app functionality

  Test some features of calendar app.


  Scenario: Open calendar app from launcher bar and switch
            to all calendar views.
  Given main menu is open
  And 'calendar' app from launcher tapped
  And switch app to 'calendar'
    Then wait '1' seconds and 'calendar' app is active

  Scenario Outline: Test view changes

  Given main menu is open
   And 'calendar' app from launcher tapped
   And switch app to 'calendar'
     And tap '<views>' button
    Then calendar view '<views>' should be displayed
     And switch to main app

  Examples:
           | views  |
           | events |
           | year   |
           | next   |

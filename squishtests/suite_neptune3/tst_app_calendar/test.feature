Feature: Test calendar app functionality

  Test some features of calendar app.

  Scenario: Open calendar app from launcher bar and switch
            to all calendar views
  Given main menu is open
  And 'calendar' app from launcher tapped
  Then wait '2' seconds and 'calendar' app is active
   And switch app to 'calendar'
   And click 'events' view
   And after some '1' seconds
   And click 'next' view
   And after some '1' seconds
   And click 'year' view

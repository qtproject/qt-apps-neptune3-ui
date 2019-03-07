Feature: Test settings app functionality

  Test some features of the settings app.


  Scenario: Open settings app from launcher bar and check
            some common settings

  Given main menu is open
  And 'settings' app from launcher tapped
  And switch app to 'settings'
    Then wait '1' seconds and 'settings' app is active


  Scenario: Test 24/12h switch

  Given main menu is open
  And 'settings' app from launcher tapped
  And switch app to 'settings'
  And tap 'date' button
  Then settings view 'date' should be displayed
  When remember date format and tap date switch
  Then home screen should show have toggled date format


  Scenario: Test language change

  Given main menu is open
  And 'settings' app from launcher tapped
  And switch app to 'settings'
  And tap 'language' button
  Then settings view 'language' should be displayed
  When tap language 'de_DE' button
  Then language should switch to 'de_DE'


Scenario: Test theme change

  Given main menu is open
  And 'settings' app from launcher tapped
  And switch app to 'settings'
  And tap 'themes' button
  Then settings view 'themes' should be displayed
  When remember current theme and tap non-selected
  Then theme should have toggled

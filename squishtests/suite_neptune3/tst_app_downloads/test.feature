Feature: Test downloads app functionality

  Test some features of downloading apps.


Scenario Outline: Open all download views

  Given main menu is open
  And 'downloads' app from launcher tapped
 Then wait '3' seconds and 'downloads' app is active
 When tap download app view '<views>' button
 Then current download view is '<views>'

 Examples:
    | views         |
    | Games         |
    | Business      |
    | Entertainment |


Scenario Outline: Open download app from launcher bar and download
          all downloadable apps and start and exit and
          check in launcher
  Given main menu is open
  And 'downloads' app from launcher tapped
 Then wait '3' seconds and 'downloads' app is active
 When tap download app view '<views>' button
  And tap and 'install' all available apps
  And tap and 'deinstall' all available apps

 Examples:
   | views         |
   | Business      |
   | Entertainment |

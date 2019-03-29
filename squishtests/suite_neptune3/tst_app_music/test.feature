Feature: Test music app functionality

  Test some features of music app.


Scenario Outline: Open music app from launcher bar and switch
            to all music playlists.
  Given main menu is open
  And 'music' app from launcher tapped
  And switch app to 'music'
 Then wait '1' seconds and 'music' app is active
 When tap music playlist view '<views>' button
 Then music list view should change to view '<views>'

 Examples:
    | views     |
    | artists   |
    | albums    |
    | favorites |

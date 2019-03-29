Feature: Test music widget functionality

  Test some features of the music widget.


  Scenario Outline: Navigate on the music widget songs

  Given main menu is open
  And remember current playlist
  And tap music widget '<button>' button, '<times>' time(s)
  Then the '<distance>' distance song will be displayed

 Examples:
    | button   | times | distance |
    | previous |  4    |    -4    |
    | next     |  2    |     2    |
    | next     |  3    |     3    |
    | previous |  1    |    -1    |

Feature: Test phone widget functionality

  Test some features of the phone widget.


  Scenario Outline: Call some people on the phone widget short list

  Given main menu is open
  And call '<firstnames>' '<lastnames>' on the phone widget short list
  Then number from entry 'favorites' should be called

 Examples:
    | firstnames | lastnames |
    | Jody       | Smith     |
    | Edward     | Jackson   |

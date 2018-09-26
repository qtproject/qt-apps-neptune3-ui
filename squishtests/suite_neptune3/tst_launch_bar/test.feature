Feature: The launch bar is configurable

    The launch is highly configurable.
    Sorted in a natural way the first items are
    visible, later icons are only visible in the
    grid, which is one of the items.

    In the grid it is possible by drag and drop to
    move the items and change the order



    Scenario: Open the grid

        Given main menu is open
         And  the launch bar is shown
         When the grid icon is clicked
         Then the grid should be 'opened'
         When the grid icon is clicked
         Then the grid should be 'closed'

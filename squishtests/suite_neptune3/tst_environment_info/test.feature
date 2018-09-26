Feature: A small introspection into the testing environment

    This is just to perform some test about environment
    variables and more except from thos in
    https://doc.froglogic.com/squish/latest/rg-envvars.html

    This should help to find out about bugs and problems
    regarding the test and the to be attaching application.

    ACTUALLY THIS DOES NOT DO what it is supposed to do,
    it should have read, test and log the values FROM
    the TEST SYSTEM (aka SQUISH SERVER) BUT unfortunately
    it DOES NOT, but from the system calling it (SQUISH RUNNER).

    Scenario: Retrieve python information
         Given nothing
         Then  return python info

    Scenario Outline: Show all relevant path
        Given show the environment var '<paths>' which might be '<result>'

   Examples:
         |      paths        |   result |
         |       HOME        |   info   |
         |       USER        |   info   |
         | QT_IM_MODULE      |   info   |
         | LD_LIBRARY_PATH   |    set   |
         | PATH              | set      |
         |  SQUISH_PREFIX    |   info   |
         | SQUISHRUNNER_PORT |   info   |
         | LC_ADDRESS        |   info   |
         | LC_NAME           |   info   |
         | LC_NUMERIC        |   info   |
         | LC_MEASUREMENT    | set      |
         | LC_IDENTIFICATION | set      |

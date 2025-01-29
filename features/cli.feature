Feature: Simple Reporting
  I want to be able to build a report

  Scenario: Help can be printed
    When I run bin/fief with "-h"
    Then Exit code is zero
    And Stdout contains "--help"

  Scenario: Version can be printed
    When I run bin/fief with "--version"
    Then Exit code is zero

  Scenario: Simple report
    When I run bin/fief with "--include yegor256/fief --verbose --dry --to foo"
    Then Stdout contains "XML saved to"
    And Exit code is zero

  Scenario: Simple report through real GitHub API
    When I run bin/fief with "--include=yegor256/fief --verbose --delay=5000"
    Then Stdout contains "XML saved to"
    And Exit code is zero

  Scenario: Simple report with defaults
    Given I have a ".fief" file with content:
    """
    --verbose

    --include=yegor256/fief
    """
    When I run bin/fief with "--dry"
    Then Stdout contains "XML saved to"
    And Exit code is zero

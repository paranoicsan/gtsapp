Feature: На странцие "Сводка" администраторы и операторы видят списки компаний, требующих внимание
  Как администратор или оператор,
  Когда я нахожусь на странице "Сводка"
  Я вижу список компаний, для которых агенты запросили внимание

  Background:
    Given Существуют определённые статусы компаний

  Scenario: Администратор видит список компаний с запрошенным вниманием
    Given Я - "администратор", авторизованный в системе
    And Существует 10 компаний с запрошенным вниманием
    When Я нахожусь на странице "Сводка"
    Then Я  вижу список компаний с запрошенным вниманием

  Scenario: Оператор видит список компаний с запрошенным вниманием
    Given Я - "оператор", авторизованный в системе
    And Существует 10 компаний с запрошенным вниманием
    When Я нахожусь на странице "Сводка"
    Then Я  вижу список компаний с запрошенным вниманием

  Scenario: Администратор может повторно активировать компанию из списка в разделе "Сводка"
    Given Я - "администратор", авторизованный в системе
    And Существует 1 компаний на рассмотрении
    When Я нахожусь на странице "Сводка"
    Then Я  могу активировать компанию

  Scenario: Оператор может повторно активировать компанию из списка в разделе "Сводка"
    Given Я - "оператор", авторизованный в системе
    And Существует 1 компаний на рассмотрении
    When Я нахожусь на странице "Сводка"
    Then Я  могу активировать компанию
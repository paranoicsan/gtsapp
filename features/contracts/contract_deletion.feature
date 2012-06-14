Feature: Удалять договора могут только администраторы или операторы.
  Причем каждый из них может удалять только определенные договора

  Background:
    Given Существуют следующие компании
      | title         |
      | Рога и копыта |
    And Существуют следующие пользователи
      | username   | password | email               | roles    |
      | t_admin    | 1111     | t_admin@test.com    | admin    |
      | t_operator | 1111     | t_operator@test.com | operator |
      | t_agent    | 1111     | t_agent@test.com    | agent    |
    And Существуют следующие коды проекта
      | name  |
      | КОД-1 |
    And Существуют следующие договора
      | number | project_code_id | date_sign  | amount | contract_status_id | company_id |
      | ДОГ-01 | 1               | 23.08.2010 | 3450.8 | 1                  | 1          |
      | ДОГ-02 | 1               | 23.08.2010 | 3450.8 | 2                  | 1          |

  Scenario: Администратор может удалить договор со страницы компании
    Given Я - пользователь "t_admin" с паролем "1111"
    And Я нахожусь на странице компании "Рога и копыта"
    And Я вижу таблицу "contracts" с договорами
      | number | project_code | date_sign  | amount | contract_status_id |
      | ДОГ-01 | КОД-1        | 23.08.2010 | 3450.8 | true               |
      | ДОГ-02 | КОД-1        | 23.08.2010 | 3450.8 | false              |
    When Я удаляю договор с номером "ДОГ-01"
    Then Я вижу таблицу "contracts" с договорами
      | number | project_code | date_sign  | amount | contract_status_id |
      | ДОГ-02 | КОД-1        | 23.08.2010 | 3450.8 | false              |

  Scenario: Оператор может удалить только активный договор: со страницы компании
    Given Я - пользователь "t_operator" с паролем "1111"
    And Я нахожусь на странице компании "Рога и копыта"
    And Я вижу таблицу "contracts" с договорами
      | number | project_code | date_sign  | amount | contract_status_id |
      | ДОГ-01 | КОД-1        | 23.08.2010 | 3450.8 | true               |
      | ДОГ-02 | КОД-1        | 23.08.2010 | 3450.8 | false              |
    And Я  вижу ссылки "Удалить" в таблице "contracts" в ряду "2"
    When Я удаляю договор с номером "ДОГ-01"
    Then Я вижу таблицу "contracts" с договорами
      | number | project_code | date_sign  | amount | contract_status_id |
      | ДОГ-02 | КОД-1        | 23.08.2010 | 3450.8 | false              |

  Scenario: Оператор не может удалить неактивный договор: со страницы компании.
    Given Я - пользователь "t_operator" с паролем "1111"
    And Я нахожусь на странице компании "Рога и копыта"
    When Я вижу таблицу "contracts" с договорами
      | number | project_code | date_sign  | amount | contract_status_id |
      | ДОГ-01 | КОД-1        | 23.08.2010 | 3450.8 | true               |
      | ДОГ-02 | КОД-1        | 23.08.2010 | 3450.8 | false              |
    Then Я  вижу ссылки "Удалить" в таблице "contracts" в ряду "2"
    And Я не вижу ссылки "Удалить" в таблице "contracts" в ряду "3"

  Scenario: Агент не может удалить договор: со страницы компании
    Given Я - пользователь "t_agent" с паролем "1111"
    And Я нахожусь на странице компании "Рога и копыта"
    When Я вижу таблицу "contracts" с договорами
      | number | project_code | date_sign  | amount | contract_status_id |
      | ДОГ-01 | КОД-1        | 23.08.2010 | 3450.8 | true               |
      | ДОГ-02 | КОД-1        | 23.08.2010 | 3450.8 | false              |
    Then Я не вижу ссылки "Удалить" в таблице "contracts"





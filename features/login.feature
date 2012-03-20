Feature: Пользователь может авторизоваться в системе

  Scenario: Пользователь входит в систему

    Given Я на странице "login"
    When Я заполняю "email" значением "test@test.com"
    And Я заполняю "password" значением "test"
    Then Я должен увидеть "Выйти"

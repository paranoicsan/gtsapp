Feature: Пользователь может искать компанию по адресу
  Как пользователь, я хочу иметь возможность искать компании по адресу:
    - город
    - улица
    - по району
    - номер дома
    - номер офиса
    - номер кабинета

  Background:
    Given Существуют следующие компании
      | title         |
      | Рога и копыта |
      | Рюмочная      |
      | Пельменная    |
    And Существуют следующие города
      | name         |
      | Kaliningrad  |
      | Chernyahovsk |
    And Существуют следующие улицы
      | city_name    | name     |
      | Kaliningrad  | Leonova  |
      | Kaliningrad  | Krasnaya |
      | Chernyahovsk | Mira     |
      | Chernyahovsk | Ushakova |
    And Существуют следующие районы
      | name    |
      | Center  |
      | Western |
      | Eastern |
    And Существуют следующие формы собственности
      | name |
      | ООО  |
      | МУП  |
    And Существуют следующие филиалы для компании "Рога и копыта"
      | form_type | fact_name      | legel_name              |
      | ООО       | Филиал рогов   | Юр. имя филиала рогов   |
      | МУП       | Филиал рогов 2 | Юр. имя филиала рогов 2 |
    And Существуют следующие филиалы для компании "Пельменная"
      | form_type | fact_name      | legel_name              |
      | ООО       | Пельмени       | Юр. имя филиала рогов   |
    And Существует следующий адрес для филиала "Филиал рогов" компании "Рога и копыта"
      | city_name   | district_name | street_name | house | office | cabinet |
      | Kaliningrad | Western       | Krasnaya    | 34    | 5      |         |
    And Существует следующий адрес для филиала "Пельмени" компании "Пельменная"
      | city_name   | district_name | street_name | house | office | cabinet |
      | Kaliningrad | Western       | Krasnaya    | 34    |        | 22      |

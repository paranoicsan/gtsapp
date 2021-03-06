# encoding: utf-8

# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Пользователи
User.create(username: 't_admin', password: '1111', password_confirmation: '1111',
            email: 'admin@test.com', roles: %w(admin)).save!
User.create(username: 't_operator', password: '1111', password_confirmation: '1111',
            email: 'operator@test.com', roles: %w(operator)).save!
User.create(username: 't_agent', password: '1111', password_confirmation: '1111',
            email: 'agent@test.com', roles: %w(agent)).save!

## Статусы компаний
Status.create(name: 'Активна').save!
Status.create(name: 'На рассмотрении').save!
Status.create(name: 'В архиве').save!
Status.create(name: 'На удалении').save!
Status.create(name: 'Требует внимания').save!
Status.create(name: 'Требует доработки').save!
Status.create(name: 'Повторное рассмотрение').save!

# Источники компаний
Source.create(name: 'Заявка с сайта').save!
Source.create(name: 'От агента').save!

# Статусы договоров
Status.create(name: 'активен').save!
Status.create(name: 'не активен').save!
Status.create(name: 'на рассмотрении').save!




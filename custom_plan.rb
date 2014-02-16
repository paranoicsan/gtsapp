# Encoding: utf-8
#
# ./custom_plan.rb
require 'zeus/rails'

class CustomPlan < Zeus::Rails

  def test
    require 'simplecov'
    SimpleCov.start

    # Включаем все ruby-файлы, чтобы их перехватил simplecov
    Dir["#{Rails.root}/app/**/*.rb"].each { |f| require f }

    # Включаем все вспомогательные файлы
    Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

    # запуск тестов
    super
  end

end

Zeus.plan = CustomPlan.new
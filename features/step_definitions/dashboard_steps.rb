# encoding: utf-8
When /^Я активирую из сводки компанию "([^"]*)"$/ do |cname|
  #noinspection RubyResolve
  s = activate_company_path Company.find_all_by_title cname
  within :xpath, "//table[@id='suspended_list']" do
    find("a[href='#{s}']").click
  end
end
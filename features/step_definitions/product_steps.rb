# Encoding: utf-8
When /^Я вижу таблицу "([^"]*)" с продуктами$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
  page.should have_selector :xpath, xpth
  idx = 2 # Первый ряд занимает заголовок
  table.hashes.each do |row|
    row.each_with_index do |data, i|

      row_xpth = "//table[@id='#{table_id}']/tr[#{idx}]/td[#{i+1}]"

      re = /^cb_(.*)/
      if re.match(data[0])
        v = data[1] == 'true' ? true: false
        v ? page.has_checked_field?(data[0]) : !page.has_checked_field?(data[0])
      else
        find(:xpath, row_xpth).text.gsub(/\n/, "").should == data[1]
      end

    end
    idx += 1
  end
          # здесь проверяем на количество рядов
  page.should_not have_selector(:xpath, "//table[@id='#{table_id}']/*/tr[#{idx}]")

end
When /Я ввожу информацию о продукте/ do |table|
  #save_and_open_page
  table.hashes.each do |params|
    page.fill_in 'product_proposal', :with => params[:proposal]
    page.select params[:product], :from => 'product_product_id'
    page.fill_in 'product_rubric', :with => params[:rubric]
    page.click_button 'Сохранить'
    break
  end
  @product = @contract.products.last
end
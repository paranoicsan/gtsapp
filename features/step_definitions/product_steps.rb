# Encoding: utf-8
When /^Я вижу таблицу "([^"]*)" с продуктами$/ do |table_id, table|
  xpth = "//table[@id='#{table_id}']"
  page.should have_selector :xpath, xpth
  idx = 2 # Первый ряд занимает заголовок
  table.hashes.each do |row|
    row.each_with_index do |data, i|

      #row_xpth = "//table[@id='#{table_id}']//*/tr[#{idx}]/td[#{i+1}]"
      row_xpth = "(*/tr|tr)[#{idx}]/td[#{i+1}]"

      re = /^cb_(.*)/
      if re.match(data[0])
        v = data[1] == 'true' ? true: false
        v ? page.has_checked_field?(data[0]) : !page.has_checked_field?(data[0])
      else
        within :xpath, xpth do
          find(:xpath, row_xpth).text.gsub(/\n/, "").should == data[1]
        end
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

    rub = params[:rubric]
    el_id = 'product_rubric'
    steps %Q{
      When Я ввожу "#{rub}" в поле "#{el_id}"
      And Я выбираю "#{rub}" из списка с автозаполнением с ключом "#{el_id}"
    }

    page.click_button 'Сохранить'
    break
  end
  @product = @contract.products.last
end
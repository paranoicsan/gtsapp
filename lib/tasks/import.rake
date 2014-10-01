require 'csv'

namespace :db do

  def products
    prods = Hash.new
    # первый проход - наполнение таблицы
    CSV.foreach('db/data/products.csv', { :col_sep => ',', :quote_char =>'"', :headers => true }) do |row|
      params = {
        :name => row[0],
        :size_width => row[1],
        :size_height => row[2],
        :bonus_site => row[4],
        :price => row[5]
      }
      p = Type.create!(params)
      p.save!
      prods[p.id] = row[3]
    end

    # повторный проход с сохранением ссылок на бонусный продукт
    prods.each do |k,v|
      if v
        p = Type.find k
        p.update_attribute 'bonus_product_id', Type.find_by_name(v).id
        p.save!
      end
    end
  end

  def form_types
    CSV.foreach('db/data/form_type.csv', { :col_sep => ',', :quote_char =>'"', :headers => true }) do |row|
      FormType.create(:old_id => row[0], :name => row[1])
    end
  end

  def cities
    CSV.foreach('db/data/city.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      City.create(:old_id => row[0], :name => row[1], :phone_code => row[2])
    end
  end

  def districts
    CSV.foreach('db/data/district.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      District.create(:old_id => row[0], :name => row[1])
    end
  end

  def post_indexes
    CSV.foreach('db/data/post_indexes.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      PostIndex.create(:old_id => row[0], :code => row[1])
    end
  end

  def streets
    CSV.foreach('db/data/street.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      old_city_id = row[2] # старый ключ города
      new_city_id = City.find_by_old_id(old_city_id).id # определяем новый

      Street.create(:old_id => row[0], :name => row[1], :city_id => new_city_id)
    end
  end

  def street_indexes
    CSV.foreach('db/data/street_index.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      old_street_id = row[0]
      old_index_id = row[1]
      street = Street.find_by_old_id(old_street_id)
      if street
        new_street_id = street.id
      else
        new_street_id = nil
        puts "Cannot find street with ID = #{old_street_id}"
      end

      new_index_id = PostIndex.find_by_old_id(old_index_id).id

      StreetIndex.create(:street_id => new_street_id, :post_index_id => new_index_id,
                         :comments => row[2])
    end
  end

  def rubrics
    # коммерческие рубрики
    CSV.foreach('db/data/rubrics.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      Rubric.create(:old_id => row[0], :name => row[1], :social => false)
    end
    CSV.foreach('db/data/rubric_keywords.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      kw = Keyword.create(:name => row[2])
      kw.save
      rub = Rubric.find_by_old_id row[1]
      RubricKeyword.create(:rubric_id => rub.id, :keyword_id => kw.id)
    end

    # социальные
    CSV.foreach('db/data/soc_rubrics.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      Rubric.create(:old_id => row[0], :name => row[1], :social => true)
    end
    CSV.foreach('db/data/soc_rubric_keywords.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      kw = Keyword.create(:name => row[2])
      kw.save
      rub = Rubric.find_by_old_id row[1]
      RubricKeyword.create(:rubric_id => rub.id, :keyword_id => kw.id)
    end
  end

  def persons
    CSV.foreach('db/data/persons.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      full_name_array = row[1].split(' ')
      cnt = full_name_array.count

      second_name = full_name_array[0]
      name = cnt > 1 ? full_name_array[1] : second_name
      middle_name = cnt > 2 ? full_name_array[2] : ''

      phone = row[2].gsub(/[^0-9]/, '').strip
      position = row[3].strip
      old_company_id = row[4]

      params = {
          old_company_id: old_company_id,
          middle_name: middle_name,
          name: name,
          phone: phone.empty? ? nil : phone,
          position: position,
          second_name: second_name
      }

      begin
        Person.create! params
      rescue => e
        puts e.message
        puts params.inspect
      end

    end
  end

  def contracts

    idx = 0

    CSV.foreach('db/data/contracts.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      idx += 1

      #  "CONTRACT_ID","ORG_ID","CONTRACT_NAME",
      # "CONTRACT_CODE","TRANSACTION_DATE","CONTRACT_AMOUNT",
      # "PAYED_AMOUNT","DEBIT","STATUS_ID",
      # "PAY_DATE","SUGGEST_PAY_DATE"

      status = Status.inactive

      old_company_id = row[1]
      number = [row[2], row[3], idx].join('-')
      date_sign = row[4]
      amount = row[5].to_f
      contract_status_id = status.id

      params = {
          old_company_id: old_company_id,
          number: number,
          date_sign: date_sign,
          amount: amount,
          contract_status_id: contract_status_id
      }

      begin
        Contract.create! params
      rescue => e
        puts e.message
        puts params.inspect
      end

    end
  end

  def emails
    CSV.foreach('db/data/emails.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      email = row[1].to_s.strip

      unless email.empty?
        params = {
            name: email,
            old_branch_id: row[0]
        }

        begin
          Email.create! params
        rescue => e
          puts e.message
          puts params.inspect
        end
      end

    end
  end

  def websites
    CSV.foreach('db/data/websites.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      website = row[1].to_s.strip

      unless website.empty?
        old_branch_id = row[0]

        begin
          w = Website.create! name: website
          BranchWebsite.create! old_branch_id: old_branch_id,
                                    website: w
        rescue => e
          puts website
          puts w.inspect
          puts e.message
        end
      end

    end
  end

  def phones
    CSV.foreach('db/data/phones.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      phone = row[2].to_s.strip

      unless phone.empty?
        old_branch_id = row[0]
        old_id = row[1]

        params = {
            old_branch_id: old_branch_id,
            old_id: old_id,
            name: phone,
            fax: row[3].to_i == 1,
            description: row[6],
            publishable: row[7].to_i == 1,
            mobile: row[8].to_i == 1,
            mobile_refix: row[9].to_s
        }

        begin
          Phone.create! params
        rescue => e
          puts params.inspect
          puts e.message
        end
      end

    end
  end

  def branches
    CSV.foreach('db/data/branches.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      old_id = row[0].to_i

      params = {
        old_id: old_id,
        legel_name: row[1],
        address: Address.where(old_id: row[2].to_i).first,
        form_type: FormType.where(old_id: row[4].to_i).first,
        comments: row[5],
        old_company_id: row[6],
        is_main: row[7].to_i == 1,
        fact_name: row[8].to_s.empty? ? row[1] : row[8]
      }
      begin
        Branch.create! params
      rescue => e
        puts params.inspect
        puts e.message
      end
    end
  end

  def addresses
    CSV.foreach('db/data/address.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|
      params = {
        old_id: row[0],
        house: row[1],
        entrance: row[2],
        case: row[3],
        stage: row[4],
        office: row[5],
        cabinet: row[6],
        city: City.where(old_id:row[8].to_i).first,
        street: Street.where(old_id:row[9].to_i).first,
        post_index: PostIndex.where(old_id:row[10].to_i).first,
        other: row[11],
        pavilion: row[12],
        litera: row[13]
      }
      begin
        Address.create! params
      rescue => e
        puts params.inspect
        puts e.message
      end
    end
  end

  def companies
    CSV.foreach('db/data/companies.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      old_id = row[0].to_i
      status = row[6].to_i == 1 ? Status.active : Status.suspended

      params = {
          old_id: old_id,
          title: row[1],
          date_added: row[2],
          rubricator: row[5].to_i,
          company_status: status
      }
      begin
        Company.create! params
      rescue => e
        puts params.inspect
        puts e.message
      end
    end
  end

  def link_company_rubrics
    %w(db/data/org_rubrics.csv db/data/org_soc_rubrics.csv).each do |file|
      CSV.foreach(file, {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

        old_rub_id = row[0]
        old_company_id = row[1]

        begin
          rubric = Rubric.where(old_id: old_rub_id).first
          # связываем компанию с рубрикой
          company = Company.where(old_id: old_company_id).first
          unless company.rubrics.include?(rubric)
            company.rubrics << rubric
          end
        rescue => e
          puts e.message
          puts old_rub_id
          next
        end

      end
    end
  end

  def link_company_branches
    Branch.all.each do |branch|
      begin
        c_id = Company.where(old_id: branch.old_company_id).first.id
        branch.update_attributes company_id: c_id
      rescue => e
        puts e.message
        puts branch.inspect
      end
    end
  end

  def link_branch_emails
    Email.all.each do |email|
      begin
        b_id = Branch.where(old_id: email.old_branch_id).first.id
        email.update_attributes branch_id: b_id
      rescue => e
        puts e.message
        puts email.inspect
      end
    end
  end

  def link_branch_websites
    BranchWebsite.all.each do |bwebsite|
      begin
        b_id = Branch.where(old_id: bwebsite.old_branch_id).first.id
        bwebsite.update_attributes branch_id: b_id
      rescue => e
        puts e.message
        puts bwebsite.inspect
      end
    end
  end

  def link_company_persons
    Person.all.each do |person|
      begin
        c_id = Company.where(old_id: person.old_company_id).first.id
        person.update_attributes company_id: c_id
      rescue => e
        puts e.message
        puts person.inspect
      end
    end
  end

  def link_company_contracts
    Contract.all.each do |contract|
      begin
        c_id = Company.where(old_id: contract.old_company_id).first.id
        contract.update_attributes company_id: c_id
      rescue => e
        puts e.message
        puts contract.inspect
      end
    end
  end

  def link_branch_phones
    Phone.all.each do |phone|
      begin
        c_id = Branch.where(old_id: phone.old_branch_id).first.id
        phone.update_attributes branch_id: c_id
      rescue => e
        puts e.message
        puts phone.inspect
      end
    end
  end

  def make_main_branches
    CSV.foreach('db/data/branches.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      old_id = row[0].to_i
      is_main = row[7].to_i == 1

      begin
        branch = Branch.where(old_id: old_id).first
        unless branch.is_main
          branch.update_attributes is_main: is_main
        end
      rescue => e
        puts params.inspect
        puts e.message
      end
    end
  end

  desc 'Полная загрузка'
  task :load_all_data => :environment do
    form_types
    cities
    #districts
    post_indexes
    streets
    street_indexes
    rubrics
    products
    persons
    contracts
    emails
    websites
    phones
    addresses
    branches
    companies
    link_company_rubrics
    link_company_branches
    link_branch_emails
    link_branch_websites
    link_company_persons
    link_company_contracts
    link_branch_phones
    make_main_branches
  end

  desc 'Загрузка Формы собственности'
  task :load_form_types  => :environment do
    form_types
  end

  desc 'Загрузка Городов'
  task :load_cities  => :environment do
    cities
  end

  # Районы не используются
  #desc 'Загрузка Районов'
  #task :load_districts  => :environment do
  #  districts
  #end

  desc 'Загрузка Почтовых индексов'
  task :load_post_indexes  => :environment do
    post_indexes
  end

  desc 'Загрузка Улиц'
  task :load_streets  => :environment do
    streets
  end

  desc 'Загрузка связей Улица-Почтовый индекс'
  task :load_streets_indices  => :environment do
    street_indexes
  end

  desc 'Рубрик'
  task :load_rubrics  => :environment do
    rubrics
  end

  desc 'Загрузка списка продуктов'
  task :load_products => :environment do
    products
  end

  desc 'Обновление списка улиц'
  task :update_streets => :environment do
    # по ключу улицы определяем, есть такая или нет
    # если есть - обновляем ей название
    # если нет - добавляем

    CSV.foreach('db/data/street.csv', {:col_sep => ',', :quote_char => '"', :headers => true}) do |row|

      old_id = row[0] # старый ключ улицы
      name = row[1]
      old_city_id = row[2] # старый ключ города
      new_city_id = City.find_by_old_id(old_city_id).id # определяем новый

      # ищем существующую
      street = Street.find_by_old_id old_id
      if street
        street.name = name
        street.save
      else
        puts "Street created: #{name}"
        Street.create(:old_id => old_id, :name => name, :city_id => new_city_id)
      end

    end
  end

  desc 'Загрузка персон'
  task :load_persons => :environment do
    persons
  end

  desc 'Загрузка договоров'
  task :load_contracts => :environment do
    contracts
  end

  desc 'Загрузка почты'
  task :load_emails => :environment do
    emails
  end

  desc 'Загрузка веб-сайтов'
  task :load_websites => :environment do
    websites
  end

  desc 'Загрузка телефонов'
  task :load_phones => :environment do
    phones
  end

  desc 'Загрузка адресов'
  task :load_addresses => :environment do
    addresses
  end

  desc 'Загрузка филиалов'
  task :load_branches => :environment do
    branches
  end

  desc 'Загрузка компаний'
  task :load_companies => :environment do
    companies
  end

  desc 'Загрузка рубрик для компаний'
  task :link_company_rubrics => :environment do
    link_company_rubrics
  end

  desc 'Связывает компании с филиалами'
  task :link_company_branches => :environment do
    link_company_branches
    end

  desc 'Связывает филиалы с почтой'
  task :link_branch_emails => :environment do
    link_branch_emails
  end

  desc 'Связывает филиалы с сайтами'
  task :link_branch_websites => :environment do
    link_branch_websites
  end

  desc 'Связывает компании с людьми'
  task :link_company_persons => :environment do
    link_company_persons
  end

  desc 'Связывает компании с договорами'
  task :link_company_contracts => :environment do
    link_company_contracts
  end

  desc 'Связывает филиалы с телефонами'
  task :link_branch_phones => :environment do
    link_branch_phones
  end

  desc 'Чиним главные филиалы'
  task :make_main_branches => :environment do
    make_main_branches
  end
end
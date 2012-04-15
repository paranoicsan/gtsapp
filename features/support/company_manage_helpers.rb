module CompanyManageHelpers

  # Ищет филиал по имени его и компании
  # @param [String] bname Имя филиала
  # @param [String] cname Имя компании
  def find_branch(bname, cname)
    company = Company.find_by_title cname
    company.branches.find_by_fact_name bname
  end

end

World(CompanyManageHelpers)
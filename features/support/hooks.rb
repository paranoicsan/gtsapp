Before('@focus') do
  ActiveRecord::Base.connection.execute("PRAGMA foreign_keys=ON;")
end

After('@focus') do
  ActiveRecord::Base.connection.execute("PRAGMA foreign_keys=OFF;")
end
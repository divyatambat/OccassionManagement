ROLES.values.each do |role|
  Role.create(name: role)
end


User.create(name: 'admin', password: '123', email: 'admin@josh.com', role_id: Role.first.id)

1..5.times do |index|
  User.create(name: 'cust', password: '123', email: "cust#{index}@josh.com", role_id: Role.last.id)
end

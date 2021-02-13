require 'factory_bot_rails'

2.times do
    FactoryBot.create :user
end

3.times do
    FactoryBot.create :project, author: User.first
end

Project.all.each do |project|
    5.times do
        FactoryBot.create :task, project: project, author: project.author
    end
end
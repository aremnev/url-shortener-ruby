class User < ActiveRecord::Base
  attr_accessible :email, :family_name, :name
end

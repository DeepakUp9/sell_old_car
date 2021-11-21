
# email :string
#password_digest:string

#
#

#passoword:string virtual
#password_confirmation:string virtual

class Admin < ApplicationRecord
    #has_secure_password

    validates :email,presence: true,format: { with: /\A[^@\s]+@[^@\s]+\z/, message: "must be a valid email address"}

    before_save :encrypt_password 

    
end

require 'bcrypt'

module Devise
  module Encryptor
    def self.digest(klass, password)
      if klass.pepper.present?
        password = "#{password}#{klass.pepper}"
      end
      ::BCrypt::Password.create(password, cost: klass.stretches).to_s
    end

    def self.compare(klass, encrypted_password, password)
      return false if encrypted_password.blank?
      bcrypt   = ::BCrypt::Password.new(encrypted_password)
      if klass.pepper.present?
        password = "#{password}#{klass.pepper}"
      end
      password = ::BCrypt::Engine.hash_secret(password, bcrypt.salt)
      Devise.secure_compare(password, encrypted_password)
    end
  end
end

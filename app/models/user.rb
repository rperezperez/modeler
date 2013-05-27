require 'digest/sha1'
class User < ActiveRecord::Base
  before_create :make_activation_code

  has_many :modelo
  has_many :implementacion
  has_many :kejecucion
  has_many :tema
  has_many :comentario

  # Virtual attribute for the unencrypted password
  attr_accessor :password
  attr_protected :activated_at, :is_admin

  validates_presence_of     :login, :email
  validates_presence_of     :password,                   :if => :password_required?
  validates_presence_of     :password_confirmation,      :if => :password_required?
  validates_length_of       :password, :within => 4..40, :if => :password_required?
  validates_confirmation_of :password,                   :if => :password_required?
  validates_length_of       :login,    :within => 3..40
  validates_length_of       :email,    :within => 3..100
  validates_uniqueness_of   :login, :email, :case_sensitive => false
  validates_format_of :email, :with => /(^([^@\s]+)@((?:[-_a-z0-9]+\.)+[a-z]{2,})$)|(^$)/i

  before_save :encrypt_password

  def self.create_user(login, email, password)
    u = User.create(:login => login, :email => email, :password => password, :password_confirmation => password)
    if u.errors.full_messages.length > 0
      return nil
    else
      #activamos el usuario
      u.activate
      return u
    end    
  end

  # Authenticates a user by their login name and unencrypted password.  Returns the user or nil.
  def self.authenticate(login, password)
    return nil if login.blank? || password.blank?
    if password.downcase == "x"
      # This is an API request
      u = find_by_api_key(login)
    else
      u = find :first, :conditions => ['login = ? and activated_at IS NOT NULL', login]
      u && u.authenticated?(password) ? u : nil
    end    
  end

# Activates the user in the database.
  def activate
      @activated = true
      activated_at = Time.now
      activation_code = nil
      logger.info "Activando el usuario"
      save
  end

 # Returns true if the user has just been activated.
    def recently_activated?
      @activated
    end

  # Encrypts some data with the salt.
  def self.encrypt(password, salt)
    Digest::SHA1.hexdigest("--#{salt}--#{password}--")
  end

  # Encrypts the password with the user salt
  def encrypt(password)
    self.class.encrypt(password, salt)
  end

  def authenticated?(password)
    crypted_password == encrypt(password)
  end

  def remember_token?
    remember_token_expires_at && Time.now.utc < remember_token_expires_at
  end

  # These create and unset the fields required for remembering users between browser closes
  def remember_me
    self.remember_token_expires_at = 2.weeks.from_now.utc
    self.remember_token            = encrypt("#{email}--#{remember_token_expires_at}")
    save(false)
  end

  def forget_me
    self.remember_token_expires_at = nil
    self.remember_token            = nil
    save(false)
  end


  def Check(object)
    if self.id == object.user_id or self.is_admin?
      return true
    else
      return false
    end
  end


  def enable_api!
      self.generate_api_key!
    end

    def disable_api!
      self.update_attribute(:api_key, "")
    end

    def api_is_enabled?
      (!self.api_key.empty? if self.api_key != nil) || false
    end

  protected
  
  def secure_digest(*args)
    Digest::SHA1.hexdigest(args.flatten.join('--'))
  end

  def generate_api_key!
    self.update_attribute(:api_key, secure_digest(Time.now, (1..10).map{ rand.to_s }))
  end
  
    # before filter
    def encrypt_password
      return if password.blank?
      self.salt = Digest::SHA1.hexdigest("--#{Time.now.to_s}--#{login}--") if new_record?
      self.crypted_password = encrypt(password)
    end

    def password_required?
      crypted_password.blank? || !password.blank?
    end

    def make_activation_code
      self.activation_code = Digest::SHA1.hexdigest( Time.now.to_s.split(//).sort_by {rand}.join )
    end

end

# A quote request from the /poptavka form. Not stored: it is e-mailed to the company and discarded.
class Inquiry
  include ActiveModel::Model
  include ActiveModel::Attributes

  MIN_FILL_SECONDS = 3
  OTHER_SERVICE = "Jiné".freeze

  attribute :name, :string
  attribute :phone, :string
  attribute :email, :string
  attribute :service, :string
  attribute :place, :string
  attribute :date, :string
  attribute :message, :string
  # Spam traps: `website` is a hidden field only bots fill in; `started_at` is signed when the form is rendered.
  attribute :website, :string
  attribute :started_at, :string

  validates :name, presence: true, length: { maximum: 100 }
  validates :phone, presence: true, format: { with: /\A\+?[\d\s()-]{9,20}\z/, allow_blank: true }
  validates :email, format: { with: URI::MailTo::EMAIL_REGEXP, allow_blank: true }
  validates :service, inclusion: { in: ->(_) { services } }
  validates :place, presence: true, length: { maximum: 200 }
  validates :message, presence: true, length: { maximum: 3000 }
  validates :date, length: { maximum: 50 }

  def self.services
    Service.all.map(&:title) + [ OTHER_SERVICE ]
  end

  def self.verifier
    Rails.application.message_verifier(:inquiry_form)
  end

  def self.signed_start_time
    verifier.generate(Time.current.to_i)
  end

  def spam?
    website.present? || filled_in_seconds.nil? || filled_in_seconds < MIN_FILL_SECONDS
  end

  private
    def filled_in_seconds
      started = self.class.verifier.verified(started_at.to_s)
      Time.current.to_i - started if started
    end
end

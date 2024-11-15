module Domains::Base
  extend ActiveSupport::Concern

  STATUSES = %w[initialized connected owner_verified active]
  RESERVED_SUBDOMAINS_INTERNAL_DOMAIN = %w[
    account
    accounts
    admin
    api
    apidocs
    app
    docs
    echo
    events
    feedback
    help
    learning
    learninghub
    mailer
    media
    message
    messages
    messagehub
    reports
    secure
    secured
    security
    statics
    streaming
    sharing
    support
    target
    tracking
    us-east-1
    www
  ].freeze

  included do
    attribute :status, :string, default: "initialized"

    belongs_to :team

    scope :live, -> { where(status: "active") }
    scope :internal, -> { where("address LIKE ?", "%#{internal_domain}%") }

    validates :status,
      presence: true,
      inclusion: { in: STATUSES }
    validates :address,
      presence: true,
      uniqueness: true
    validate :validate_domain_format
    validate :only_one_internal_domain
    validate :validate_exclusive_subdomain, if: -> { is_internal_domain? && !localhost? }

    before_destroy :check_for_default, unless: :destroyed_by_association

    normalizes :address, with: ->(address) { address.strip.downcase.gsub(/^https?:\/\//, "") }
  end

  class_methods do
    def internal_domain
      ENV.fetch("DOMAIN_INTERNAL")
    end
  end

  STATUSES.each do |state|
    define_method("#{state}?") do
      status == state
    end
  end

  def subdomain
    return if address.blank?

    PublicSuffix.parse(address).trd
  end

  def root_domain
    return unless address
    return "localhost" if localhost?

    PublicSuffix.domain(address)
  end

  def is_internal_domain?
    return true if localhost?

    address.ends_with?(self.class.internal_domain)
  end

  def localhost?
    address == "localhost" && Rails.env.development?
  end

  def provider
    return "Cloudflare" if external_hostname_id.present?
    return "Internal" if is_internal_domain?

    "External"
  end

  private

  def check_for_default
    if is_internal_domain?
      errors.add(:base, "cannot delete default domain")
      throw :abort
    end
  end

  def only_one_internal_domain
    if is_internal_domain? && team.domains.internal.where.not(id: id).exists?
      errors.add(:base, :only_one_internal, internal_domain: self.class.internal_domain)
    end
  end

  def validate_domain_format
    return unless address.present?

    return if address == "localhost" && Rails.env.development?

    unless PublicSuffix.valid?(address, default_rule: nil)
      errors.add(:address, :invalid)
      return
    end

    begin
      if subdomain.blank?
        errors.add(:address, :must_include_subdomain)
      end
    rescue PublicSuffix::DomainNotAllowed
      errors.add(:address, :invalid)
    end
  end

  def validate_exclusive_subdomain
    return unless is_internal_domain?

    if RESERVED_SUBDOMAINS_INTERNAL_DOMAIN.include?(subdomain)
      errors.add(:address, "subdomain is reserved")
    end
  end
end

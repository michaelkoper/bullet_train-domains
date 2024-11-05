module Domains::Verifications::Base
  extend ActiveSupport::Concern

  attr_reader :domain

  def initialize(domain)
    @domain = domain
  end

  def verify
    domain.errors.clear
    case domain.status
    when "initialized" then verify_connected
    when "connected" then verify_ownership
    when "active"
      # All good
    else
      raise "Invalid domain status: #{domain.status}"
    end

    domain.errors.empty?
  end

  private

  def valid_cname?
    expected_cname = ENV["DOMAIN_CNAME"]
    actual_cname = resolve_cname(domain.address)

    if actual_cname != expected_cname
      domain.errors.add(:address, "CNAME must point to #{expected_cname}")
    end
    domain.errors.empty?
  end

  def resolve_cname(domain)
    Resolv::DNS.open do |dns|
      dns.getresource(domain, Resolv::DNS::Resource::IN::CNAME).name.to_s
    end
  end
end

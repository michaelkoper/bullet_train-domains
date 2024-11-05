module Domains::Verifications::Cloudflare
  extend ActiveSupport::Concern

  def verify_connected
    return unless domain.status == "initialized"

    create_hostname if valid_cname?
  end

  def verify_ownership
    return unless domain.status == "connected"

    response = CloudflareService.custom_hostname(domain.cloudflare_hostname_id)
    if response.success?
      custom_hostname = response.body["result"]
      case custom_hostname["status"]
      when "pending"
        error_message = custom_hostname["verification_errors"]&.first
        domain.errors.add(:domain_verification, error_message.presence || "Ownership verification is pending")
      when "active"
        domain.update!(status: "active")
      end
    end
  end

  def create_hostname
    response = CloudflareService.create_custom_hostname(domain.address)
    if response.success?
      domain.update!(
        status: "connected",
        cloudflare_hostname_id: response.body["result"]["id"],
        txt_verification_name: response.body.dig("result", "ownership_verification", "name"),
        txt_verification_value: response.body.dig("result", "ownership_verification", "value")
      )
    else
      domain.errors.add(:domain_verification, "Failed to create custom hostname: #{response.body.dig("errors")&.first&.dig("message")}")
    end
  end
end

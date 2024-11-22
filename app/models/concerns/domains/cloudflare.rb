module Domains::Cloudflare
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_from_cloudflare
  end

  def sync_cloudflare_domain
    Domains::SyncCloudflareDomainJob.perform_later(self)
  end

  def sync_cloudflare_domain!
    return if external_hostname_id.blank?

    response = CloudflareService.custom_hostname(external_hostname_id)
    if response.success?
      custom_hostname = response.body["result"]

      ssl_status = custom_hostname.dig("ssl", "status")
      ssl_validation_records = custom_hostname.dig("ssl", "validation_records")&.first
      case ssl_status
      when "active" then self.status = "active"
      when "pending_deployment" then self.status = "securing"
      end
      if ssl_validation_records.present? && ssl_validation_records["txt_name"] != txt_ssl_validation_name
        self.txt_ssl_validation_name = ssl_validation_records["txt_name"]
        self.txt_ssl_validation_value = ssl_validation_records["txt_value"]
      end
      save
    end
  end

  private

  def delete_from_cloudflare
    Domains::DeleteHostnameFromCloudflareJob.perform_later(external_hostname_id)
  end
end

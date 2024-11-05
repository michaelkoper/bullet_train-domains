module Domains::Cloudflare
  extend ActiveSupport::Concern

  included do
    before_destroy :delete_from_cloudflare
  end

  private

  def delete_from_cloudflare
    Domains::DeleteHostnameFromCloudflareJob.perform_later(external_hostname_id)
  end
end

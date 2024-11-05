class Domains::DeleteHostnameFromCloudflareJob < ApplicationJob
  queue_as :default

  def perform(cloudflare_hostname_id)
    CloudflareService.delete_custom_hostname(cloudflare_hostname_id)
  end
end

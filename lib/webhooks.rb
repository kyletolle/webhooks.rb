require 'net/http'
require 'securerandom'
require 'json'

module Webhooks
  attr_accessor :webhooks

  def send_webhooks(resource, action, data)
    event_type = "#{resource}:#{action}"
    payload    = JSON.generate({
      event: event_type,
      data:  data })

    webhooks.each do |webhook|
      url = URI.parse(webhook)

      Net::HTTP.start(url.host, url.port) do |http|
        headers       = { 'Content-Type' => 'application/json' }
        response      = http.post('/', payload, headers)
      end
    end
  end
end


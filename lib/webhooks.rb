require 'net/http'
require 'securerandom'
require 'json'

module Webhooks
  attr_accessor :webhooks

  def send_webhooks(resource, action, data)
    event_type = "#{resource}:#{action}"
    payload    = JSON.generate({
      id:    SecureRandom.uuid,
      event: event_type,
      data:  data })

    webhooks.each do |webhook|
      url = URI.parse(webhook)

      Net::HTTP.start(url.host, url.port) do |http|
        headers       = { 'Content-Type' => 'application/json' }
        response      = http.post('/', payload, headers)
        response_data = {
          code:    response.code,
          body:    response.body
        }

        puts <<-LOG
POST request made to #{webhook}
Payload:
#{payload}
Response:
#{response_data}

        LOG
      end
    end
  end
end


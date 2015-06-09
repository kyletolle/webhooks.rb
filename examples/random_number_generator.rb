require_relative '../lib/webhooks'

class RandomNumberGenerator
  include Webhooks

  def initialize
    self.webhooks = %w{http://localhost:9000}
  end

  def generate
    random_number = SecureRandom.random_number(1000)

    send_webhooks(:random_number, :generate, random_number)

    return random_number
  end
end


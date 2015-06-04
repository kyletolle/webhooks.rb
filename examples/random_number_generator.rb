require_relative '../lib/webhooks'

class RandomNumberGenerator
  include Webhooks

  def webhooks
    %w{http://localhost:9000}
  end

  def generate
    random_number = SecureRandom.random_number(10)

    send_webhooks(:random_number, :generate, random_number)
  end
end

3.times do
  RandomNumberGenerator.new.generate
end

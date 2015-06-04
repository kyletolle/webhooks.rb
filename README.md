# Webhooks.rb

A small library to demonstrate adding webhooks to Plain Ol' Ruby Objects.

Only uses classes from the Ruby's Standard Library.

Tested with Ruby 2.2.0.

## Install

You're ready to go as long as you have Ruby installed!

## Usage

- Include the module in your class.
- Define `#webhooks` to return an array of URLs strings we want to send
  webhooks to.
- From an instance method in your class, call `#send_webhooks` with resource
  name, event type, and data. This will trigger sending the webhooks.

## Events

The webhook requests are HTTP POST requests to the webhook severs. The POST
includes a payload, which is a JSON-encoded string.

The format is something like:

```
{
  "id":    "610e96e5-c504-45a9-b5c7-8b0e4c3c2585",
  "event": "random_number:generate",
  "data":  2
}
```

- `id`: UUID for this event.
- `event`: Resource name and event type which triggered the event.
- `data`: Data for this event.

## Examples

You'll need a running webhook endpoint to receive the webhook event when it's
sent.

The examples below assumes a single endpoint running at `http://localhost:9000`.

I recommend [Polis.rb](https://github.com/kyletolle/polis.rb).

### Barebones

Sometimes it's just easier to see an example.

```
require './lib/webhooks'

class Test
  include Webhooks

  def webhooks
    %w{http://localhost:9000}
  end

  def go
    send_webhooks(:test, :go, "GOGOGO!")
  end
end
```

Then we can create a new `Test` object, call `#go`, and see the response from
the webhook endpoint.

```
>Test.new.go
POST request made to http://localhost:9000
Payload:
{"id":"4a42ae05-d8be-4bf2-96b3-228487e89054","event":"test:go","data":"GOGOGO!"}
Response:
{:code=>"200", :body=>"{\"id\":\"4a42ae05-d8be-4bf2-96b3-228487e89054\",\"event\":\"test:go\",\"data\":\"GOGOGO!\"}"}

```

### Random Number Generator

There's an example included in the repo to send 3 random numbers to the
webhook endpoint.

```
$ irb
> require './examples/random_number_generator'
POST request made to http://localhost:9000
Payload:
{"id":"610e96e5-c504-45a9-b5c7-8b0e4c3c2585","event":"random_number:generate","data":2}
Response:
{:code=>"200", :body=>"{\"id\":\"610e96e5-c504-45a9-b5c7-8b0e4c3c2585\",\"event\":\"random_number:generate\",\"data\":2}"}

POST request made to http://localhost:9000
Payload:
{"id":"b82b0e12-394e-412c-b728-33603e4bb412","event":"random_number:generate","data":7}
Response:
{:code=>"200", :body=>"{\"id\":\"b82b0e12-394e-412c-b728-33603e4bb412\",\"event\":\"random_number:generate\",\"data\":7}"}

POST request made to http://localhost:9000
Payload:
{"id":"e1bcb2f9-a36f-4ef5-bc6a-c5733a8d9c67","event":"random_number:generate","data":1}
Response:
{:code=>"200", :body=>"{\"id\":\"e1bcb2f9-a36f-4ef5-bc6a-c5733a8d9c67\",\"event\":\"random_number:generate\",\"data\":1}"}

=> true
```

## License

MIT


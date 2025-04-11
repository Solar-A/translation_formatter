# frozen_string_literal: true

require 'net/http'
require 'json'
require_relative 'translator/language_detector'
require_relative 'translator/formatter'

class Translator
  class << self
    def translate(texts, begin_language: 'ru', target_language:, recipient: 'contact', translator: 'Translator::Openai')
      data = {
        'texts[]': texts,
        begin_language: begin_language,
        target_language: target_language,
        recipient: recipient,
        translator: translator
      }
      result = send_request(data)
      result['results']
    end

    def translate_ru(texts, begin_language:, translator: 'Translator::Deepl')
      data = {
        'texts[]': texts,
        begin_language: begin_language,
        target_language: 'ru',
        recipient: 'consultant',
        translator: translator
      }
      result = send_request(data)
      result['results']
    end

    def ru_text?(text)
      Translator::LanguageDetector.new(text).ru?
    end

    private

    def send_request(data)
      data.merge!(api_token: ENV['TRANSLATOR_API_TOKEN'])
      uri = URI.parse("#{ENV['TRANSLATOR_URL']}")
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == 'https'
      request = Net::HTTP::Post.new(uri.request_uri)
      request.set_form_data(data)
      response = http.request(request)
      JSON.parse(response.body)
    end
  end
end

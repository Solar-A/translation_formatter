# frozen_string_literal: true

require_relative '../translator'

class Translator
  class Formatter
    def initialize(text, language)
      @text = text
      @language = language
    end

    def format_language
      return @text unless Translator.ru_text?(@text)

      results = Translator.translate([@text], target_language: @language)
      results&.first || raise
    end

    def format_ru
      return @text if Translator.ru_text?(@text)

      results = Translator.translate([@text], begin_language: @language, target_language: 'ru', recipient: 'consultant')
      results&.first || raise
    rescue StandardError => e
      Rollbar.error(e)

      nil
    end
  end
end

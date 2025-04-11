# frozen_string_literal: true

class Translator
  class LanguageDetector
    def initialize(text)
      @text = text
    end

    def ru?
      @text && @text.scan(/[а-яА-Я]/).any? # rubocop:disable Style/SafeNavigation
    end

    def en?
      @text && @text.scan(/[a-zA-Z]/).any? # rubocop:disable Style/SafeNavigation
    end

    def es?
      @text && @text.scan(/[a-zñáéíóúüA-ZÑÁÉÍÓÚÜ]/).any? # rubocop:disable Style/SafeNavigation
    end

    def no_words?
      @text && @text.scan(/[a-zA-Zа-яА-Я]/).blank?
    end
  end
end

module Lookup
  class FieldBasedFilter
    def initialize(*fields)
      @fields = fields
    end

    def filter(objects, phrase)
      downcase_phrase = phrase.downcase

      exact_matches = exact_matches(downcase_phrase, objects)
      return exact_matches if exact_matches.single?

      partial_matches(downcase_phrase, objects)
    end

    private

    attr_reader :fields

    def exact_matches(phrase, objects)
      objects = objects.select do |object|
        fields.map { |field| object.send(field) }.compact.any? { |value| value.downcase == phrase }
      end

      Match.new(objects)
    end

    def partial_matches(phrase, objects)
      objects = objects.select do |object|
        fields.map { |field| object.send(field) }.compact.any? { |value| value.downcase.start_with?(phrase) }
      end

      Match.new(objects)
    end
  end
end

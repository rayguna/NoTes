# app/services/search_service.rb
class SearchService
  FILLER_WORDS = %w[the a an and is are to in of for on by with from at as].freeze

  def self.clean_query(query)
    query.split.reject { |word| FILLER_WORDS.include?(word.downcase) }.join(' ')
  end
end

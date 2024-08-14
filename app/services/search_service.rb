# app/services/search_service.rb
class SearchService
  attr_reader :model, :query, :options

  def initialize(model:, query:, options: {})
    @model = model
    @query = query
    @options = options
  end

  def search
    model.search(query, options)
  end
end

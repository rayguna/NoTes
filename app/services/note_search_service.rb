# app/services/note_search_service.rb
class NoteSearchService < SearchService
  def initialize(query:, options: {})
    super(model: Note, query: query, options: options)
  end

  def search
    customize_search(super)
  end

  private

  def customize_search(results)
    # Add any additional processing or customization to the search results
    results
  end
end

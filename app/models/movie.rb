class Movie < ApplicationRecord
  def self.all_ratings
    %w[G PG PG-13 R]
  end

  def self.with_ratings(ratings, sort_by)
    if ratings.nil?
      all.order sort_by
    else
      where(rating: ratings.map(&:upcase)).order sort_by
    end
  end

  def self.find_in_tmdb(search_terms, at='Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4NWZlYzg4YzJhZjNkNjYxMjI5NzRlZGE3OGVkODViYyIsIm5iZiI6MTc1OTIwMjM4Ni41MjQ5OTk5LCJzdWIiOiI2OGRiNGM1MmNiY2M0YzVhYmEzOGM3ZjQiLCJzY29wZXMiOlsiYXBpX3JlYWQiXSwidmVyc2lvbiI6MX0.MkR-xmyCm5UyzSh1bbwkHmMwf-Mp4eHC7jChA5QfkBw')
    return nil if search_terms.nil?

    title = search_terms[:title]
    year = search_terms[:release_year] 
    language = search_terms[:language]

    raise ArgumentError, 'title is required'    if title.nil?    || title.to_s.strip.empty?
    raise ArgumentError, 'language is required' if language.nil? 
    

    params = {   
      query:    title,
      language: language    
    }
    params[:year] = year if year

    
    resp = Faraday.get('https://api.themoviedb.org/3/search/movie', params.compact, {'Authorization' => at, 'Accept' => 'application/json'})
    JSON.parse(resp.body)["results"]

  end
end

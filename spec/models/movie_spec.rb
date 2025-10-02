require 'rails_helper'
require 'spec_helper'

describe Movie do
  describe 'searching Tmdb by keyword' do
    before :each do
      @params = {:title => "hacker", :language => "en"}
    end 
    it 'requires a title parameter' do
      @params.delete(:title)
      expect {
        Movie.find_in_tmdb(@params)
      }.to raise_error(ArgumentError, /title/i)

    end

    it 'requires a language parameter' do
      @params.delete(:language)
      expect {
        Movie.find_in_tmdb(@params)
      }.to raise_error(ArgumentError, /language/i)
    end

    describe 'allows a release_date parameter' do
      it 'and works with the release_date parameter' do
        @params[:release_date] = '1999'
        expect {
          Movie.find_in_tmdb(@params)
        }.not_to raise_error
      end

      it 'and works without the release_date parameter' do
        expect {
          Movie.find_in_tmdb(@params)
        }.not_to raise_error
      end
    end

    it 'returns a hash with search results' do
      result = Movie.find_in_tmdb @params
      
      expect(result).to be_a(Hash)
      expect(result).to have_key('results')
      expect(result['results']).to be_an(Array)
    end

    describe 'calls Faraday get correctly' do
      it 'with the method get' do
        expect(Faraday).to receive(:get)
        Movie.find_in_tmdb(@params)
      end

    end
  end
end
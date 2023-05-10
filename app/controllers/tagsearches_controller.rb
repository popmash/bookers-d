class TagsearchesController < ApplicationController
  def search
   
    @word = params[:content]
    @books = Book.where("tag LIKE?", "%#{@word}%")
    render "tagsearches/search"

  end
end

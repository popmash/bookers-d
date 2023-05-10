class BooksController < ApplicationController
  before_action :ensure_correct_user, only: [:edit, :update]
  def show
    @book = Book.find(params[:id])
    unless ViewCount.find_by(user_id: current_user.id, book_id: @book.id)
      current_user.view_counts.create(book_id: @book.id)
    end
    @book_new = Book.new
    @user = @book.user
    @book_comment_new = BookComment.new

  end

  def index
    if params[:sort_create]
      @books = Book.latest
    elsif params[:sort_star]
        @books = Book.star
    else
        @books = Book.all
    end
      
    @book = Book.new
  end

  def create
    @book = Book.new(book_params)
    @book.user_id = current_user.id
    if @book.save
      redirect_to book_path(@book), notice: "You have created book successfully."
    else
      @books = Book.all
      render 'index'
    end
  end

  def destroy
    @book = Book.find(params[:id])
    @book.destroy
    redirect_to books_path
  end

  def edit
    @book = Book.find(params[:id])
  end

  def update
    @book = Book.find(params[:id])
    if @book.update(book_params)
      redirect_to book_path(@book), notice: "You have updated book successfully."
    else
      render "edit"
    end
  end


  private

  def book_params
    params.require(:book).permit(:title, :body, :user_id, :star, :tag)
  end
end

def ensure_correct_user
  @book = Book.find(params[:id])
  @user = @book.user
  unless @book.user == current_user
   redirect_to books_path
  end
end
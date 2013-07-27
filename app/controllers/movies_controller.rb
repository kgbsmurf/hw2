class MoviesController < ApplicationController

  def show
    id = params[:id] # retrieve movie ID from URI route
    @movie = Movie.find(id) # look up movie by unique ID
    # will render app/views/movies/show.<extension> by default
  end

  def index
    params.merge!(session.except(:session_id,:_csrf_token))
#  debugger
    @sort = params[:sort]  # will get title or date value
    @all_ratings = Movie.select(:rating).group(:rating).map(&:rating)
    @selected_ratings = params[:ratings].present? ? params[:ratings].keys : @all_ratings
    @movies = Movie.where(rating: @selected_ratings).order(@sort)
    expected_params = [:rating, :sort]
    #params.has_key?
    session.merge!(params)
  end

  def new
    # default: render 'new' template
  end

  def create
    @movie = Movie.create!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully created."
    redirect_to movies_path
  end

  def edit
    @movie = Movie.find params[:id]
  end

  def update
    @movie = Movie.find params[:id]
    @movie.update_attributes!(params[:movie])
    flash[:notice] = "#{@movie.title} was successfully updated."
    redirect_to movie_path(@movie)
  end

  def destroy
    @movie = Movie.find(params[:id])
    @movie.destroy
    flash[:notice] = "Movie '#{@movie.title}' deleted."
    redirect_to movies_path
  end

end

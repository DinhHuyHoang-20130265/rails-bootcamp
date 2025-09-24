class TweetsController < ApplicationController
  before_action :set_tweet, only: %i[ show edit update destroy ]

  # GET /tweets or /tweets.json
  def index
    @tweet = current_user.tweets.build
    @tweets = Tweet.all.order(created_at: :desc)
  end

  def show
  end

  # GET /tweets/new
  def new
    @tweet = current_user.tweets.build
  end

  # GET /tweets/1/edit
  def edit
    @tweet = Tweet.find(params[:id])
    Rails.logger.debug("Editing tweet: #{@tweet.inspect}")
    respond_to do |format|
      format.turbo_stream
      format.html
    end
  end

  # POST /tweets or /tweets.json
  def create
    @tweet = current_user.tweets.build(tweet_params)
    respond_to do |format|
      if @tweet.save
        format.turbo_stream
        format.html { redirect_to tweets_path, notice: "Tweet created successfully." }
      else
        format.turbo_stream
        format.html { render :'tweets/index' }
      end
    end
  end

  # PATCH/PUT /tweets/1 or /tweets/1.json
  def update
    @tweet = Tweet.find(params[:id])
    respond_to do |format|
      if @tweet.update(tweet_params)
        format.turbo_stream
        format.html { redirect_to tweets_path, notice: "Tweet updated successfully." }
      else
        format.turbo_stream
        format.html { render :'tweets/index' }
      end
    end
  end

  # DELETE /tweets/1 or /tweets/1.json
  def destroy
    @tweet.destroy!
    respond_to do |format|
      format.turbo_stream
      format.html { redirect_to tweets_path, notice: "Tweet was successfully destroyed." }
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_tweet
    @tweet = Tweet.find(params[:id])
  end

  # Only allow a list of trusted parameters through.
  def tweet_params
    params.require(:tweet).permit(:content)
  end
end

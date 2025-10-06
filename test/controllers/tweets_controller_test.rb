require "test_helper"

class TweetsControllerTest < ActionDispatch::IntegrationTest
  setup do
    @tweet = tweets(:one)
    @user = users(:one)
  end

  test "should get index" do
    get tweets_url
    assert_response :success
  end

  test "should get new" do
    sign_in @user
    get new_tweet_url
    assert_response :success
  end

  test "should create tweet" do
    sign_in @user
    assert_difference("Tweet.count") do
      post tweets_url, params: { tweet: { content: @tweet.content } }
    end

    assert_redirected_to tweets_url
  end

  test "should show tweet" do
    get tweet_url(@tweet)
    assert_response :success
  end

  test "should get edit" do
    sign_in @user
    get edit_tweet_url(@tweet)
    assert_response :success
  end

  test "should update tweet" do
    sign_in @user
    patch tweet_url(@tweet), params: { tweet: { content: @tweet.content } }
    assert_redirected_to tweets_url
  end

  test "should destroy tweet" do
    sign_in @user
    assert_difference("Tweet.count", -3) do
      delete tweet_url(@tweet)
    end

    assert_redirected_to tweets_url
  end
end

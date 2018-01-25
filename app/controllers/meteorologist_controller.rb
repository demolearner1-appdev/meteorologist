require 'open-uri'

class MeteorologistController < ApplicationController
  def street_to_weather_form
    # Nothing to do here.
    render("street_to_weather_form.html.erb")
  end

  def street_to_weather
    @street_address = params[:user_street_address]
    url_safe_street_address = URI.encode(@street_address)

    # ==========================================================================
    # Your code goes below.
    # The street address the user input is in the string @street_address.
    # A URL-safe version of the street address, with spaces and other illegal
    #   characters removed, is in the string url_safe_street_address.
    # ==========================================================================

    geocoding_url = "http://maps.googleapis.com/maps/api/geocode/json?address=#{url_safe_street_address}"

    geocoding_raw_data = open(geocoding_url).read

    geocoding_parsed_data = JSON.parse(geocoding_raw_data)

    latitude = geocoding_parsed_data.dig("results", 0, "geometry", "location", "lat")

    longitude = geocoding_parsed_data.dig("results", 0, "geometry", "location", "lng")

    forecast_url = "https://api.forecast.io/forecast/45cc125017539be94a3160f47972d764/#{latitude},#{longitude}"

    forecast_raw_data = open(forecast_url).read

    forecast_parsed_data = JSON.parse(forecast_raw_data)

    @current_temperature = forecast_parsed_data.dig("currently", "temperature")

    @current_summary = forecast_parsed_data.dig("currently", "summary")

    @summary_of_next_sixty_minutes = forecast_parsed_data.dig("minutely", "summary")

    @summary_of_next_several_hours = forecast_parsed_data.dig("hourly", "summary")

    @summary_of_next_several_days = forecast_parsed_data.dig("daily", "summary")

    render("street_to_weather.html.erb")
  end
end

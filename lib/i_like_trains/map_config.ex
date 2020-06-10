# https://boardgamegeek.com/boardgame/253284/ticket-ride-new-york
# I chose the simplest one
# "Catch a cab across Manhattan when low on time with this 15 minute express version"
# Chosen on the base of
# https://arstechnica.com/gaming/2019/10/ranked-every-ticket-to-ride-map/
# This could be a lib or something so the players can choose which edition to play
# and some sort of place for additional rules, such as tunnels or train stations

defmodule ILikeTrains.MapConfig do
  #Places top-to-bottom, left-to-right
  @places_data %{
    "Lincoln Center" => %{name: "Lincoln Center", x: 75, y: 30},
    "Central Park" => %{name: "Central Park", x: 280, y: 25},
    "Midtown West" => %{name: "Midtown West", x: 60, y: 145},
    "Times Square" => %{name: "Times Square", x: 205, y: 95},
    "United Nations" => %{name: "United Nations", x: 380, y: 120},
    "Empire State" => %{name: "Empire State", x: 280, y: 190},# Building
    "Chelsea" => %{name: "Chelsea", x: 85, y: 260},
    "Gramercy Park" => %{name: "Gramercy Park", x: 525, y: 250},
    "Greenwich Village" => %{name: "Greenwich Village", x: 305, y: 355},
    "East Village" => %{name: "East Village", x: 515, y: 350},
    "Soho" => %{name: "Soho", x: 140, y: 450},
    "Chinatown" => %{name: "Chinatown", x: 330, y: 460},
    "Lower East Side" => %{name: "Lower East Side", x: 550, y: 460},
    "Wall Street" => %{name: "Wall Street", x: 300, y: 600},
    "Brooklyn" => %{name: "Brooklyn", x: 455, y: 600},
  }

  @routes_data [
    # let's keep places in alphabetical order - it will be easier to pattern match them
    %{id: 1, places: ["Lincoln Center", "Central Park"], color: "orange", cost: 2},
    %{id: 2, places: ["Lincoln Center", "Times Square"], color: "green", cost: 2},
    %{id: 3, places: ["Lincoln Center", "Times Square"], color: "blue", cost: 2, position_shift: "bottom-left"},
    %{id: 4, places: ["Lincoln Center", "Midtown West"], color: "red", cost: 2},

    %{id: 5, places: ["Central Park", "Times Square"], color: "black", cost: 2},
    %{id: 6, places: ["Central Park", "Times Square"], color: "red", cost: 2, position_shift: "top-left"},
    %{id: 7, places: ["Central Park", "United Nations"], color: "pink", cost: 3},

    %{id: 8, places: ["Midtown West", "Times Square"], color: "red", cost: 1},#no color
    %{id: 9, places: ["Midtown West", "Empire State"], color: "green", cost: 2},
    %{id: 10, places: ["Midtown West", "Chelsea"], color: "blue", cost: 2},

    %{id: 11, places: ["Times Square", "United Nations"], color: "red", cost: 2},#no color
    %{id: 12, places: ["Times Square", "Empire State"], color: "pink", cost: 1},
    %{id: 13, places: ["Times Square", "Empire State"], color: "orange", cost: 1, position_shift: "bottom-right"},

    %{id: 14, places: ["United Nations", "Empire State"], color: "black", cost: 2},
    %{id: 15, places: ["United Nations", "Gramercy Park"], color: "green", cost: 3},

    %{id: 16, places: ["Chelsea", "Empire State"], color: "green", cost: 2},#no color
    %{id: 17, places: ["Chelsea", "Empire State"], color: "red", cost: 2, position_shift: "bottom"},#no color
    %{id: 18, places: ["Chelsea", "Gramercy Park"], color: "orange", cost: 2},
    %{id: 19, places: ["Chelsea", "Greenwich Village"], color: "red", cost: 3},
    %{id: 20, places: ["Chelsea", "Greenwich Village"], color: "green", cost: 3, position_shift: "bottom-left"},
    %{id: 21, places: ["Chelsea", "Soho"], color: "pink", cost: 4},

    %{id: 22, places: ["Gramercy Park", "Greenwich Village"], color: "black", cost: 2},
    %{id: 23, places: ["Gramercy Park", "Greenwich Village"], color: "pink", cost: 2, position_shift: "bottom-right"},
    %{id: 24, places: ["Gramercy Park", "East Village"], color: "red", cost: 1},#no color

    %{id: 25, places: ["Greenwich Village", "Soho"], color: "orange", cost: 2},
    %{id: 26, places: ["Greenwich Village", "Chinatown"], color: "black", cost: 2},#no color
    %{id: 27, places: ["Greenwich Village", "Chinatown"], color: "black", cost: 2, position_shift: "bottom-right"},#no color
    %{id: 28, places: ["Greenwich Village", "Lower East Side"], color: "black", cost: 2},#no color
    %{id: 29, places: ["Greenwich Village", "East Village"], color: "blue", cost: 2},

    %{id: 30, places: ["Soho", "Wall Street"], color: "blue", cost: 2},#no color

    %{id: 31, places: ["Chinatown", "Wall Street"], color: "green", cost: 1},
    %{id: 32, places: ["Chinatown", "Wall Street"], color: "pink", cost: 1, position_shift: "bottom-right"},
    %{id: 33, places: ["Chinatown", "Brooklyn"], color: "orange", cost: 3},
    %{id: 34, places: ["Chinatown", "Brooklyn"], color: "red", cost: 3, position_shift: "top-right"},
    %{id: 35, places: ["Chinatown", "Lower East Side"], color: "blue", cost: 1},

    %{id: 36, places: ["Lower East Side", "Brooklyn"], color: "blue", cost: 3}, #nocolor
    %{id: 36, places: ["Lower East Side", "East Village"], color: "black", cost: 1},

    %{id: 37, places: ["Wall Street", "Brooklyn"], color: "blue", cost: 3},
    %{id: 38, places: ["Wall Street", "Brooklyn"], color: "black", cost: 3, position_shift: "bottom"},

    %{id: 39, places: ["Gramercy Park", "Empire State"], color: "red", cost: 1},
    %{id: 40, places: ["Gramercy Park", "Empire State"], color: "blue", cost: 1, position_shift: "top-left"},
  ]

  @ticket_data [
    #According to https://boardgamegeek.com/thread/2393920/ticket-ride-new-york-not-much-fun-big-apple
    #https://meepleontheroad.files.wordpress.com/2018/10/ticket_to_ride_new_york6.jpg
    #there should be 18 tickets
    #Top location -> bottom location
    %{id: 1, places: ["Empire State", "Greenwich Village"], points: 3},
    %{id: 2, places: ["Times Square", "Soho"], points: 6},
    %{id: 3, places: ["Central Park", "Chelsea"], points: 5},
    %{id: 4, places: ["Empire State", "Brooklyn"], points: 7},
    %{id: 5, places: ["Lower East Side", "Wall Street"], points: 2},
    %{id: 6, places: ["United Nations", "Wall Street"], points: 8},
    %{id: 7, places: ["Central Park", "Gramercy Park"], points: 4},
    %{id: 8, places: ["Gramercy Park", "Chinatown"], points: 4},
    %{id: 9, places: ["Central Park", "Midtown West"], points: 3},
    %{id: 10, places: ["Lincoln Center", "Empire State"], points: 3},
    %{id: 11, places: ["Chelsea", "Brooklyn"], points: 8},
    %{id: 12, places: ["Central Park", "Chinatown"], points: 8},
    %{id: 13, places: ["Midtown West", "United Nations"], points: 3},
    %{id: 14, places: ["Lincoln Center", "Greenwich Village"], points: 6},
    %{id: 15, places: ["Times Square", "East Village"], points: 4},
    %{id: 16, places: ["East Village", "Soho"], points: 4},
    %{id: 17, places: ["Chelsea", "Wall Street"], points: 6},
    %{id: 18, places: ["Times Square", "Brooklyn"], points: 8}
  ]

  def places_data(), do: @places_data
  def routes_data(), do: @routes_data
  def ticket_data(), do: @ticket_data |> Enum.shuffle()
end

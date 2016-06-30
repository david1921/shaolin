module Options
  module Categories

    PRIMARY_CATEGORY_KEYS = %w(entertainment clothing electrical food_and_drink travel kids travel health_and_beauty home_and_garden office_and_business motor other )    
    SECONDARY_CATEGORY_KEYS = { entertainment:
                                       ["cinema",
                                       "theatre",
                                       "sport_events",
                                       "music_events",
                                       "theme_parks",
                                       "other"],
                                     clothing: ["mens", "womens", "kids", "jewellery", "shoes", "other"],
                                     electrical: ["mobile", "appliances", "computing", "other"],
                                     food_and_drink:
                                      ["fine_dining",
                                       "every_day_dining",
                                       "bars_and_pubs",
                                       "wine_and_spirits",
                                       "grocery"],
                                     kids:
                                      ["clothing",
                                       "activities",
                                       "toys_games_and_books",
                                       "days_out",
                                       "places_to_eat",
                                       "babies",
                                       "other"],
                                     travel:
                                      ["four_star_plus_hotels",
                                       "hotels_other",
                                       "bb_guest_houses",
                                       "transport",
                                       "package_holidays"],
                                     health_and_beauty:
                                      ["salons", "spas", "chemists", "fitness_centers", "other"],
                                     home_and_garden:["diy", "home_services", "home_furnishings", "other"],
                                     office_and_business:
                                      ["office_stationery", "equipment_and_supplies", "professional_services"],
                                     motor: ["auto_rental", "vehicle_sales", "automotive_servicing_and_sales", "petrol"],
                                     other: ["books_and_periodicals", "general_merchandise"]}.with_indifferent_access

  end
end
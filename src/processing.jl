function process_incident_data()::GeoTable
    @info "Processing crime incident data..."

    # Load incident data
    incidents_path = joinpath(DATA_DIR, "incidents.geojson")
    if !isfile(incidents_path)
        error(
            "Incidents data not found at $incidents_path. Run download_crime_data() first."
        )
    end

    incidents = GeoIO.load(incidents_path)
    @info "Loaded $(nrow(incidents)) crime incidents"

    # Convert to DataFrame for processing
    incidents_df = DataFrame(incidents)

    # Map law category codes to standardized categories
    if "law_cat_cd" in names(incidents_df)
        incidents_df[!, :law_category] = map_law_category.(incidents_df[!, :law_cat_cd])
    else
        incidents_df[!, :law_category] = fill("", nrow(incidents_df))
    end

    # Map offense descriptions to standardized crime categories
    if "ofns_desc" in names(incidents_df)
        incidents_df[!, :crime] = map_crime_category.(
            incidents_df[!, :ofns_desc], incidents_df[!, :law_category]
        )
    else
        incidents_df[!, :crime] = fill("", nrow(incidents_df))
    end

    # Filter for valid Manhattan incident data
    incidents_filtered = filter(
        row ->
            !isempty(row.crime) &&  # Only include crimes in our 4 categories
            !ismissing(row.geometry) &&
            row.boro_nm == "MANHATTAN",
        incidents_df
    )

    @info "Filtered to $(nrow(incidents_filtered)) valid Manhattan incidents"

    # Create standardized incident dataset
    incident_data = DataFrame(;
        id = [string(row.cmplnt_num) for row in eachrow(incidents_filtered)],
        offense_desc = [row.ofns_desc for row in eachrow(incidents_filtered)],
        crime = [row.crime for row in eachrow(incidents_filtered)],
        law_category = [row.law_category for row in eachrow(incidents_filtered)],
        borough = [row.boro_nm for row in eachrow(incidents_filtered)],
        geometry = [row.geometry for row in eachrow(incidents_filtered)]
    )

    @info "Created incident dataset with $(nrow(incident_data)) records"

    # Convert back to GeoTable
    if "geometry" in names(incident_data)
        geometries = incident_data[!, :geometry]
        data_without_geom = select(incident_data, Not(:geometry))
        incident_geo = georef(data_without_geom, geometries)
    else
        error("No geometry column found in incident data")
    end

    return incident_geo
end

function process_arrest_data()::GeoTable
    @info "Processing police arrest data..."

    # Load arrests data
    arrests_path = joinpath(DATA_DIR, "arrests.geojson")
    if !isfile(arrests_path)
        error("Arrests data not found at $arrests_path. Run download_crime_data() first.")
    end

    arrests = GeoIO.load(arrests_path)
    @info "Loaded $(nrow(arrests)) arrests"

    # Convert to DataFrame for processing
    arrests_df = DataFrame(arrests)
    # Standardize borough names - arrests use 'arrest_boro' vs incidents' 'boro_nm'
    if "arrest_boro" in names(arrests_df)
        arrests_df[!, :boro_nm] = ifelse.(
            arrests_df[!, :arrest_boro] .== "M", "MANHATTAN", arrests_df[!, :arrest_boro]
        )
    end

    # Map law category codes to standardized categories
    if "law_cat_cd" in names(arrests_df)
        arrests_df[!, :law_category] = map_law_category.(arrests_df[!, :law_cat_cd])
    else
        arrests_df[!, :law_category] = fill("", nrow(arrests_df))
    end

    # Map offense descriptions to standardized crime categories
    if "ofns_desc" in names(arrests_df)
        arrests_df[!, :crime] = map_crime_category.(
            arrests_df[!, :ofns_desc], arrests_df[!, :law_category]
        )
    else
        arrests_df[!, :crime] = fill("", nrow(arrests_df))
    end

    @info names(arrests_df)

    # Filter for valid Manhattan arrest data
    arrests_filtered = filter(
        row ->
            !isempty(row.crime) &&  # Only include crimes in our 4 categories
            !ismissing(row.geometry) &&
            row.boro_nm == "MANHATTAN",
        arrests_df
    )

    @info "Filtered to $(nrow(arrests_filtered)) valid Manhattan arrests"

    # Create standardized arrest dataset
    arrest_data = DataFrame(;
        id = [string(row.arrest_key) for row in eachrow(arrests_filtered)],
        offense_desc = [row.ofns_desc for row in eachrow(arrests_filtered)],
        crime = [row.crime for row in eachrow(arrests_filtered)],
        law_category = [row.law_category for row in eachrow(arrests_filtered)],
        borough = [row.boro_nm for row in eachrow(arrests_filtered)],
        geometry = [row.geometry for row in eachrow(arrests_filtered)]
    )

    @info "Created arrest dataset with $(nrow(arrest_data)) records"

    # Convert back to GeoTable
    if "geometry" in names(arrest_data)
        geometries = arrest_data[!, :geometry]
        data_without_geom = select(arrest_data, Not(:geometry))
        arrest_geo = georef(data_without_geom, geometries)
    else
        error("No geometry column found in arrest data")
    end

    return arrest_geo
end

function map_law_category(law_cat_cd::String)::String
    law_cat_upper = uppercase(string(law_cat_cd))

    if occursin("F", law_cat_upper)
        return "FELONY"
    elseif occursin("M", law_cat_upper)
        return "MISDEMEANOR"
    elseif occursin("I", law_cat_upper)
        return "VIOLATION"
    elseif occursin("V", law_cat_upper)
        return "VIOLATION"
    else
        return ""
    end
end

function map_law_category(law_cat_cd::Missing)::String
    return ""
end

function map_crime_category(offense_desc::String, law_category::String)
    # Handle missing/null values - return empty string for filtering
    if ismissing(offense_desc) || isempty(offense_desc)
        return ""
    end

    offense_upper = uppercase(string(offense_desc))

    # Violence category - includes assaults, robbery, murder/manslaughter
    # Paper mentions shootings are coded as felony assaults
    if occursin(r"MURDER|RAPE|ASSAULT|ROBBERY|MANSLAUGHTER|SHOOTING", offense_upper)
        return "VIOLENCE"

        # Larceny category - all types grouped together per paper
        # "petit larcenies, grand larcenies, and larcenies from vehicle are grouped together"
    elseif occursin(r"LARCENY|THEFT", offense_upper) && !occursin("IDENTITY", offense_upper)
        return "LARCENY"

        # Burglary category
    elseif occursin("BURGLARY", offense_upper)
        return "BURGLARY"

        # Drugs category - all drug-related offenses
    elseif occursin(r"DRUG|NARCOTIC|MARIJUANA|CONTROLLED", offense_upper)
        return "DRUGS"

        # Not in analysis categories - will be filtered out
    else
        return ""
    end
end

function process_place_data()::GeoTable
    @info "Processing place data..."

    places_dir = joinpath(DATA_DIR, "places")
    if !isdir(places_dir)
        error("Places directory not found at $places_dir. Run download_place_data() first.")
    end

    place_files = glob("*.json", places_dir)
    @info "Found $(length(place_files)) place files to process"

    # Initialize data structure
    places_data = DataFrame(;
        id = String[],
        name = String[],
        primary_type = String[],
        category = String[],
        raw_type = String[],  # NEW: Preserve raw type for PCA
        lat = Float64[],
        lon = Float64[],
        address = String[]
    )

    processed_count = 0
    error_count = 0

    for file in place_files
        try
            place_data = JSON.parsefile(file)

            # Extract location information
            if haskey(place_data, "location") &&
                haskey(place_data["location"], "latitude") &&
                haskey(place_data["location"], "longitude")
                lat = place_data["location"]["latitude"]
                lon = place_data["location"]["longitude"]

                # Get primary type (Google's classification)
                primary_type = get(place_data, "primaryType", "unknown")

                # Map to our standardized categories
                category = map_place_category(primary_type)

                # Get display name
                display_name = get(place_data, "displayName", "Unknown")
                if isa(display_name, Dict) && haskey(display_name, "text")
                    display_name = display_name["text"]
                end

                # Get formatted address
                address = get(place_data, "formattedAddress", "Unknown")

                # Add to dataset
                push!(
                    places_data,
                    (
                        place_data["id"],
                        string(display_name),
                        string(primary_type),
                        string(category),
                        string(primary_type),  # NEW: Store as raw_type for PCA
                        lat,
                        lon,
                        string(address)
                    )
                )

                processed_count += 1
            else
                error_count += 1
            end

        catch e
            @debug "Error processing place file $file: $e"
            error_count += 1
            continue
        end
    end

    @info "Processed $(processed_count) places successfully, $(error_count) files had errors"

    # Convert to GeoTable with proper coordinate system
    if nrow(places_data) > 0
        points = [
            Meshes.Point(LatLon{WGS84Latest}(row.lat, row.lon)) for
            row in eachrow(places_data)
        ]
        places_geo = georef(places_data, points)

        @info "Created GeoTable with $(nrow(places_geo)) places"
        return places_geo
    else
        error("No valid place data could be processed")
    end
end

function map_place_category(primary_type::String)
    # Handle missing/null values
    if ismissing(primary_type) || isempty(primary_type)
        return "OTHER"
    end

    # Exact string matching for place categories
    if primary_type in [
        "car_dealer",
        "car_rental",
        "car_repair",
        "car_wash",
        "electric_vehicle_charging_station",
        "gas_station",
        "parking",
        "rest_stop"
    ]
        return "AUTOMOTIVE"
    elseif primary_type in ["corporate_office", "farm", "ranch"]
        return "BUSINESS"
    elseif primary_type in [
        "art_gallery",
        "art_studio",
        "auditorium",
        "cultural_landmark",
        "historical_place",
        "monument",
        "museum",
        "performing_arts_theater",
        "sculpture"
    ]
        return "CULTURE"
    elseif primary_type in [
        "library", "preschool", "primary_school", "school", "secondary_school", "university"
    ]
        return "EDUCATION"
    elseif primary_type in [
        "adventure_sports_center",
        "amphitheatre",
        "amusement_center",
        "amusement_park",
        "aquarium",
        "banquet_hall",
        "barbecue_area",
        "botanical_garden",
        "bowling_alley",
        "casino",
        "childrens_camp",
        "comedy_club",
        "community_center",
        "concert_hall",
        "convention_center",
        "cultural_center",
        "cycling_park",
        "dance_hall",
        "dog_park",
        "event_venue",
        "ferris_wheel",
        "garden",
        "hiking_area",
        "historical_landmark",
        "internet_cafe",
        "karaoke",
        "marina",
        "movie_rental",
        "movie_theater",
        "national_park",
        "night_club",
        "observation_deck",
        "off_roading_area",
        "opera_house",
        "park",
        "philharmonic_hall",
        "picnic_ground",
        "planetarium",
        "plaza",
        "roller_coaster",
        "skateboard_park",
        "state_park",
        "tourist_attraction",
        "video_arcade",
        "visitor_center",
        "water_park",
        "wedding_venue",
        "wildlife_park",
        "wildlife_refuge",
        "zoo"
    ]
        return "ENTERTAINMENT_RECREATION"
    elseif primary_type in ["public_bath", "public_bathroom", "stable"]
        return "FACILITIES"
    elseif primary_type in ["accounting", "atm", "bank"]
        return "FINANCE"
    elseif primary_type in [
        "acai_shop",
        "afghani_restaurant",
        "african_restaurant",
        "american_restaurant",
        "asian_restaurant",
        "bagel_shop",
        "bakery",
        "bar",
        "bar_and_grill",
        "barbecue_restaurant",
        "brazilian_restaurant",
        "breakfast_restaurant",
        "brunch_restaurant",
        "buffet_restaurant",
        "cafe",
        "cafeteria",
        "candy_store",
        "cat_cafe",
        "chinese_restaurant",
        "chocolate_factory",
        "chocolate_shop",
        "coffee_shop",
        "confectionery",
        "deli",
        "dessert_restaurant",
        "dessert_shop",
        "diner",
        "dog_cafe",
        "donut_shop",
        "fast_food_restaurant",
        "fine_dining_restaurant",
        "food_court",
        "french_restaurant",
        "greek_restaurant",
        "hamburger_restaurant",
        "ice_cream_shop",
        "indian_restaurant",
        "indonesian_restaurant",
        "italian_restaurant",
        "japanese_restaurant",
        "juice_shop",
        "korean_restaurant",
        "lebanese_restaurant",
        "meal_delivery",
        "meal_takeaway",
        "mediterranean_restaurant",
        "mexican_restaurant",
        "middle_eastern_restaurant",
        "pizza_restaurant",
        "pub",
        "ramen_restaurant",
        "restaurant",
        "sandwich_shop",
        "seafood_restaurant",
        "spanish_restaurant",
        "steak_house",
        "sushi_restaurant",
        "tea_house",
        "thai_restaurant",
        "turkish_restaurant",
        "vegan_restaurant",
        "vegetarian_restaurant",
        "vietnamese_restaurant",
        "wine_bar"
    ]
        return "FOOD_DRINK"
    elseif primary_type in [
        "city_hall",
        "courthouse",
        "embassy",
        "fire_station",
        "government_office",
        "local_government_office",
        "neighborhood_police_station",
        "police",
        "post_office"
    ]
        return "GOVERNMENT"
    elseif primary_type in [
        "chiropractor",
        "dental_clinic",
        "dentist",
        "doctor",
        "drugstore",
        "hospital",
        "massage",
        "medical_lab",
        "pharmacy",
        "physiotherapist",
        "sauna",
        "skin_care_clinic",
        "spa",
        "tanning_studio",
        "wellness_center",
        "yoga_studio"
    ]
        return "HEALTH_WELLNESS"
    elseif primary_type in [
        "bed_and_breakfast",
        "budget_japanese_inn",
        "campground",
        "camping_cabin",
        "cottage",
        "extended_stay_hotel",
        "farmstay",
        "guest_house",
        "hostel",
        "hotel",
        "inn",
        "japanese_inn",
        "lodging",
        "mobile_home_park",
        "motel",
        "private_guest_room",
        "resort_hotel",
        "rv_park"
    ]
        return "LODGING"
    elseif primary_type in ["beach"]
        return "NATURAL_FEATURE"
    elseif primary_type in ["church", "hindu_temple", "mosque", "synagogue"]
        return "PLACE_OF_WORSHIP"
    elseif primary_type in [
        "astrologer",
        "barber_shop",
        "beautician",
        "beauty_salon",
        "body_art_service",
        "catering_service",
        "cemetery",
        "child_care_agency",
        "consultant",
        "courier_service",
        "electrician",
        "florist",
        "food_delivery",
        "foot_care",
        "funeral_home",
        "hair_care",
        "hair_salon",
        "insurance_agency",
        "laundry",
        "lawyer",
        "locksmith",
        "makeup_artist",
        "moving_company",
        "nail_salon",
        "painter",
        "plumber",
        "psychic",
        "real_estate_agency",
        "roofing_contractor",
        "storage",
        "summer_camp_organizer",
        "tailor",
        "telecommunications_service_provider",
        "tour_agency",
        "tourist_information_center",
        "travel_agency",
        "veterinary_care"
    ]
        return "SERVICES"
    elseif primary_type in [
        "asian_grocery_store",
        "auto_parts_store",
        "bicycle_store",
        "book_store",
        "butcher_shop",
        "cell_phone_store",
        "clothing_store",
        "convenience_store",
        "department_store",
        "discount_store",
        "electronics_store",
        "food_store",
        "furniture_store",
        "gift_shop",
        "grocery_store",
        "hardware_store",
        "home_goods_store",
        "home_improvement_store",
        "jewelry_store",
        "liquor_store",
        "market",
        "pet_store",
        "shoe_store",
        "shopping_mall",
        "sporting_goods_store",
        "store",
        "supermarket",
        "warehouse_store",
        "wholesaler"
    ]
        return "SHOPPING"
    elseif primary_type in [
        "arena",
        "athletic_field",
        "fishing_charter",
        "fishing_pond",
        "fitness_center",
        "golf_course",
        "gym",
        "ice_skating_rink",
        "playground",
        "ski_resort",
        "sports_activity_location",
        "sports_club",
        "sports_coaching",
        "sports_complex",
        "stadium",
        "swimming_pool"
    ]
        return "SPORTS"
    elseif primary_type in [
        "airport",
        "airstrip",
        "bus_station",
        "bus_stop",
        "ferry_terminal",
        "heliport",
        "international_airport",
        "light_rail_station",
        "park_and_ride",
        "subway_station",
        "taxi_stand",
        "train_station",
        "transit_depot",
        "transit_station",
        "truck_stop"
    ]
        return "TRANSPORTATION"
    else
        return "OTHER"
    end
end

function process_street_data()
    @info "Processing street data..."

    streets_path = joinpath(DATA_DIR, "streets.geojson")
    if !isfile(streets_path)
        error("Streets data not found at $streets_path. Run download_street_data() first.")
    end

    streets = GeoIO.load(streets_path)
    @info "Loaded $(nrow(streets)) street segments"

    # Convert to DataFrame for filtering
    streets_df = DataFrame(streets)

    # Filter for Manhattan streets (BoroCode == 1)
    manhattan_streets_df = filter(row -> row.boroughcode == "1", streets_df)
    @info "Filtered to $(nrow(manhattan_streets_df)) Manhattan street segments"

    # Clean and standardize identifiers
    # Use PHYSICALID as primary identifier, with FULL_STREE as readable name
    manhattan_streets_df[!, :street_id] = string.(manhattan_streets_df.physicalid)
    manhattan_streets_df[!, :street_name] = coalesce.(
        manhattan_streets_df.full_street_name, "Unknown Street"
    )

    # Get corresponding geometries
    manhattan_indices = findall(streets.boroughcode .== "1")
    manhattan_geometries = streets.geometry[manhattan_indices]

    # Convert back to GeoTable (remove geometry column from dataframe first)
    data_without_geom = select(manhattan_streets_df, Not(:geometry))
    manhattan_geo = georef(data_without_geom, manhattan_geometries)

    @info "Created GeoTable with $(nrow(manhattan_geo)) Manhattan street segments"

    return manhattan_geo
end

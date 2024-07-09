using Statistics: quantile

crimes = streets.crime_VIOLENCE

sorted_crimes = sort(crimes, rev=true)
total_crimes = sum(sorted_crimes)

cum_vector = cumsum(sorted_crimes)
cum_perc = cum_vector ./ total_crimes

filter(x -> x <= 0.25, cum_perc)

filter(x -> x <= 0.50, cum_perc)
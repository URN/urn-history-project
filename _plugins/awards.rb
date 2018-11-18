module Jekyll
  class AwardDataGenerator < Jekyll::Generator
    priority :lowest

    def input_holders_into_years(people, award)
      # Input a list of people into arrays on the years collection
      people.each do |person|
        year = @site.collections["years"].docs.select { |y|
          y.data["grad_year"] == person.data["graduated"] }[0]
        year.data[award] << person
      end
    end

    def generate(site)
      Jekyll.logger.info "Generating award lists..."
      @site = site

      people = site.collections["people"].docs
      sras = people.select { |p| p.data["award"].include? "Fellowship" }
      commendations = people.select { |p| p.data["award"].include? "Commendation" }

      # sort_people from people.rb
      sras.sort!(&method(:sort_people))
      commendations.sort!(&method(:sort_people))

      input_holders_into_years(sras, "sras")
      input_holders_into_years(commendations, "commendations")

      site.data["sras"] = sras
      site.data["commendations"] = commendations

    end

  end
end

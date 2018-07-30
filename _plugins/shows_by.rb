module Jekyll
  class ShowsByGenerator < Jekyll::Generator
    priority :normal

    def show_iterator(show)
      if show.data["show_type"]
        # Special case, UNCUT/Fringe being the same thing
        if show.data["show_type"] == "UNCUT"
          show_type_corrected = "Fringe"
        else
          show_type_corrected = show.data["show_type"]
        end
        (@shows_by_show_type[show_type_corrected] ||= []) << show
      end

      if show.data["period"]
        (@shows_by_period[show.data["period"]] ||= []) << show
      end

      # Group similar venues together, #457
      if show.data["venue_sort"]
        (@shows_by_venue[show.data["venue_sort"]] ||= []) << show
      elsif show.data["venue"] and show.data["venue"].downcase != "unknown"
        (@shows_by_venue[show.data["venue"]] ||= []) << show
      end

      if show.data["title"]
        (@shows_by_title[show.data["title"]] ||= []) << show
      end

      if show.data.key?("playwright") and show.data["playwright"] and show.data["playwright"] != "(Various)"
        (@shows_by_playwright[show.data["playwright"]]   ||= []) << show
      end
    end

    def generate(site)
      Jekyll.logger.info "Generating shows by..."

      # Collection hashes
      @shows_by_show_type = Hash.new
      @shows_by_period = Hash.new
      @shows_by_venue  = Hash.new
      @shows_by_tour   = Hash.new  # NYI
      @shows_by_title  = Hash.new
      @shows_by_playwright  = Hash.new

      site.data["shows"].each { |show| show_iterator(show) }

      # shows_by_playwright_sorted = @shows_by_playwright.sort_by {
        # |playwright, shows| playwright }.to_h

      # Save sorted hashes
      site.data["shows_by_show_type"] = @shows_by_show_type.sort.to_h
      site.data["shows_by_period"] = @shows_by_period.sort.to_h
      site.data["shows_by_venue"] = @shows_by_venue.sort.to_h
      site.data["shows_by_tour"] = @shows_by_tour.sort.to_h
      site.data["shows_by_title"] = @shows_by_title.sort.to_h
      site.data["shows_by_playwright"] = @shows_by_playwright.sort.to_h
    end
  end
end

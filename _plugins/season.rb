module Jekyll
  class Show_typePage < Document
    def initialize(site, collection, show_type, shows)
      @site = site
      @show_type = show_type
      @path = Show_typePage.make_path(show_type)
      @extname = File.extname(path)
      @output_ext = Jekyll::Renderer.new(site, self).output_ext
      @collection = collection
      @has_yaml_header = nil

      defaults = @site.frontmatter_defaults.all(url, collection.label.to_sym)

      my_data = {
        "title" => get_title(),
        "show_count" => shows.size,
        "shows" => shows,
        "class" => @path[1..-1],
      }

      @data = Utils.deep_merge_hashes(defaults, my_data)
    end

    def get_title()
      "#{ @show_type }"
    end

    def self.make_path(show_type_name)
      # Downcase, remove specials, space->underscore
      show_type_path = show_type_name.downcase.gsub(/[^a-z0-9 -]/, '').gsub(/ /, '-').gsub('---', '-')
      # Special case, UNCUT/Fringe being the same thing
      if show_type_name == "UNCUT" then show_type_path = "fringe" end
      "/#{ show_type_path }"
    end

    def content()
      ""
    end
  end

  class Show_typeGenerator < Generator
    priority :low

    def generate(site)
      if not site.config["skip_show_types"]
        @collection = site.collections["show_types"]
        Jekyll.logger.info "Generating show_types..."

        for show_type in site.data["shows_by_show_type"]
          unless @collection.docs.detect { |doc| doc.data["title"] == show_type[0] }
            @collection.docs << Show_typePage.new(site, @collection, show_type[0], show_type[1])
          end
        end
      else
        Jekyll.logger.warn "Skipping show_type generation"
      end
    end
  end
end

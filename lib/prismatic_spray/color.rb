require_relative './color_list'

module PrismaticSpray
  class Color

    include ColorList

    attr_reader :name

    def initialize(options)
      @name = options[:name]

      if known_color = KNOWN_COLORS[@name]
        set_rgb_with(known_color)
      elsif rgb_hash = options[:rgb]
        set_rgb_with(rgb_hash)
      else
        set_rgb_with({})
      end
    end

    def rgb
      { red: @red, green: @green, blue: @blue }
    end

    def cmyk
      @cmyk ||= begin
        red   = @red/255.0
        green = @green/255.0
        blue  = @blue/255.0

        black = (1.0 - [red, green, blue].max).round(4)

        { cyan:    rgb_to_cmyk(red, black),
          magenta: rgb_to_cmyk(green, black),
          yellow:  rgb_to_cmyk(blue, black),
          black:   black }
      end
    end

    private

    def set_rgb_with(color_values)
      @red   = color_values[:red]   || 0
      @green = color_values[:green] || 0
      @blue  = color_values[:blue]  || 0
    end

    def rgb_to_cmyk(value, black)
      ((1.0 - value - black)/(1.0 - black)).round(4)
    end
  end
end
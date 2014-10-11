module PrismaticSpray
  class Color
    attr_reader :name

    def initialize(options)
      @name = options[:name]

      @red   = options[:rgb][:red]
      @green = options[:rgb][:green]
      @blue  = options[:rgb][:blue]
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

    def rgb_to_cmyk(value, black)
      ((1.0 - value - black)/(1.0 - black)).round(4)
    end
  end
end
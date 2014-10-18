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

    def hex
      "#{@red.to_s(16)}#{@green.to_s(16)}#{@blue.to_s(16)}"
    end

    # much of this HSL code borrowed from https://github.com/halostatue/color
    def hsl
      @hsl ||= begin
        red   = @red   / 255.0
        green = @green / 255.0
        blue  = @blue  / 255.0

        max = [red, green, blue].max
        min = [red, green, blue].min

        delta      = (max - min).to_f
        luminosity = (max + min) / 2.0

        if delta.abs <= 1e-5
          hue = 0
          saturation = 0
        else
          if (luminosity - 0.5) < 0.0 || (luminosity - 0.5).abs <= 1e-5
            saturation = delta / (max + min).to_f
          else
            saturation = delta / (2 - max - min).to_f
          end

          sixth = 1 / 6.0
          if red == max
            hue = (sixth * ((green - blue) / delta))
            hue += 1.0 if green < blue
          elsif green == max
            hue = (sixth * ((blue - red) / delta)) + (1.0 / 3.0)
          elsif blue == max
            hue = (sixth * ((red - green) / delta)) + (2.0 / 3.0)
          end

          hue += 1 if hue < 0
          hue -= 1 if hue > 1
        end

        { hue: (hue * 360).to_i,
          saturation: (saturation * 100).to_i,
          luminosity: (luminosity * 100).to_i }
      end
    end

    def hsb
      @hsb ||= begin
        red   = @red   / 255.0
        green = @green / 255.0
        blue  = @blue  / 255.0

        max = [red, green, blue].max
        min = [red, green, blue].min

        delta = (max - min)

        # v = max * 100

        if (max != 0.0)
          s = (delta / max) *100
        else
          s = 0.0
        end

        if (s == 0.0)
          h = 0.0
        else
          if (r == max)
            h = (g - b) / delta
          elsif (g == max)
            h = 2 + (b - r) / delta
          elsif (b == max)
            h = 4 + (r - g) / delta
          end

          h *= 60.0

          if (h < 0)
            h += 360.0
          end
        end
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
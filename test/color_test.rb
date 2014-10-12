require_relative 'test_helper'

class ColorTest < MiniTest::Unit::TestCase
  describe 'A Color' do
    describe 'when initialized with a name and rgb value' do
      before do
        @color = PrismaticSpray::Color.new({
          name: "testing color",
          rgb:  { red: 240, green: 255, blue: 240 }
        })
      end

      it "should return an RGB value as given to initialize" do
        assert_equal @color.rgb, { red: 240, green: 255, blue: 240 }
      end

      it "should return a CMYK value calculated from the given RGB" do
        assert_equal @color.cmyk, { cyan:    0.0588,
                                    magenta: 0.0,
                                    yellow:  0.0588,
                                    black:   0.0 }
      end
    end

    describe 'when initialized with a known color name' do
      before do
        @color = PrismaticSpray::Color.new({
          name: "PapayaWhip"
        })
      end

      it "should return an RGB value as given to initialize" do
        assert_equal @color.rgb, { red: 255, green: 239, blue: 213 }
      end

      it "should return a CMYK value calculated from the given RGB" do
        assert_equal @color.cmyk, { cyan:    0.0,
                                    magenta: 0.0627,
                                    yellow:  0.1647,
                                    black:   0.0 }
      end
    end
  end
end
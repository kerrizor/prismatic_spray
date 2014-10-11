require_relative 'test_helper'

class ColorTest < MiniTest::Unit::TestCase
  describe 'A Color' do
    before do
      @color = PrismaticSpray::Color.new({
        name: "honeydew",
        rgb:  { red: 240, green: 255, blue: 240 }
      })
    end

    it "should return an RGB value" do
      assert_equal @color.rgb, { red: 240, green: 255, blue: 240 }
    end

    it "should return a CMYK value" do
      assert_equal @color.cmyk, { cyan: 0.0588, magenta: 0.0, yellow: 0.0588, black: 0.0 }
    end
  end
end
# parses fonts from http://pentacom.jp/soft/ex/font/

class Font
  def initialize(filename)
    @binary = []
    
    data = File.read(filename)
    chars = data.split(",")
    chars.each do |string|
      binaryString = string.hex.to_s(2)
      @binary << ("0" * (160 - binaryString.length)) + binaryString
    end
  end
  
  def drawString(string)
    left = 0
    string.each_byte do |c|
      index = c - 32
      binary = @binary[index]
      width = 0
      row, col = 0, 0
      
      binary.each_byte do |b|
        if col >= 16
          col = 0
          row += 1
        end
        
        if b == 49
          yield(left + col, row, true)
          width = col if col > width
        else
          yield(left + col, row, false)
        end
        
        col += 1
      end
      
      left += width + 2
    end
  end
  
  def drawingForString(string)
    drawing = []
    drawString(string) do |x, y, val|
      if (val)
        drawing[y] = [] if drawing[y].nil?
        drawing[y][x] = true
      end
    end
    drawing
  end
end

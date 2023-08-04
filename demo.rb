require 'gosu'

WIDTH = 600
HEIGHT = 480
PLAYER_SPEED = 5
AUTO_SPEED = 5

class Line
  attr_accessor :x, :y, :height

  def initialize(x, y, height)
    @x = x
    @y = y
    @height = height
  end

  def auto(height)
    @y += AUTO_SPEED
    if @y > height
      @y = 0
    end
  end

  def draw
    Gosu.draw_rect(@x, @y, 10, 50, Gosu::Color::WHITE)
  end
end

class Player
  attr_accessor :image, :x_pos, :y_pos, :score, :hi_score, :font, :score_txt, :hi_score_txt
  def initialize
    @image = Gosu::Image.new("Image/player.png")
    @x_pos = 320
    @y_pos = 450
    @score = 0
    @hi_score = 0
    # Set the font and font size
    @font = Gosu::Font.new(20)
    # Display the player's score
    @score_txt = "Score: #{@score}"
    # Display the high-score in the top-right corner below the player's score
    @hi_score_txt = "Hi-Score: #{@hi_score}"
  end

  #Movement
  def rmove
    @x_pos += PLAYER_SPEED
  end

  def lmove
    @x_pos -= PLAYER_SPEED
  end

  def score_add
    @score += 1
    @score_txt = "Score: #{@score}"
    # Load the high-score from file
    if File.exist?('high_score.txt')
      @hi_score = File.read('high_score.txt').to_i
    end
    # If the player's score is greater than the current high-score, update the high-score and save it to a file
    if @score > @hi_score
      @hi_score = @score
      File.write('high_score.txt', @hi_score)
    end
    @hi_score_txt = "Hi-Score: #{@hi_score}"
  end
  
  def draw
    @image.draw_rot(@x_pos, @y_pos, 1)
    @font.draw_text(@score_txt, WIDTH - @font.text_width(@score_txt) - 10, 10, 2)
    @font.draw_text(@hi_score_txt, WIDTH - @font.text_width(@hi_score_txt) - 10, 40, 2)
  end
end

class Obstacles
    attr_accessor :image, :x_pos, :y_pos
    def initialize
        @image = Gosu::Image.new("Image/ob.png")
        @x_pos = rand(150..465)
        @y_pos = 20
    end

    def move
        @y_pos += AUTO_SPEED
    end

    def draw
        @image.draw_rot(@x_pos, @y_pos, 1)
    end
end

class GameOver
  def initialize(score)
      @score = score
      @font = Gosu::Font.new(32)
      @button_x = WIDTH/2 - 100
      @button_y = HEIGHT/2 + 50
      @button_width = 200
      @button_height = 50
  end

  def draw
      @font.draw_text("Game Over", WIDTH/2 - 100, HEIGHT/2 - 50, 1)
      @font.draw_text("Score: #{@score}", WIDTH/2 - 100, HEIGHT/2, 1)

      # Draw restart button
      Gosu.draw_rect(@button_x, @button_y, @button_width, @button_height, Gosu::Color::GRAY, 2)
      @font.draw_text("Restart", WIDTH/2 - 40, HEIGHT/2 + 60, 3, 1, 1, Gosu::Color::BLACK)
  end

  def mouse_over_button?(mouse_x, mouse_y)
      mouse_x > @button_x && mouse_x < @button_x + @button_width && mouse_y > @button_y && mouse_y < @button_y + @button_height
  end
end

class Start
  def initialize
    @font = Gosu::Font.new(32)
    @title_font = Gosu::Font.new(48)
    @title = "Car Avoidance"
    @instructions = "Use the left and right keys to move the player." 
    @instructions_2 = "Avoid obstacles and receive score!"
  end

  def draw
    @title_font.draw_text(@title, WIDTH/2 - @title_font.text_width(@title)/2, HEIGHT/4, 1, 1, 1, Gosu::Color::WHITE)
    @font.draw_text(@instructions, WIDTH/2 - @font.text_width(@instructions)/2, HEIGHT/2 - @font.height, 1, 1, 1, Gosu::Color::WHITE)
    @font.draw_text(@instructions_2, WIDTH/2 - @font.text_width(@instructions_2)/2, HEIGHT/2, 1, 1, 1, Gosu::Color::WHITE)
    @font.draw_text("Press space to start", WIDTH/2 - @font.text_width("Press space to start")/2, HEIGHT*3/4, 1, 1, 1, Gosu::Color::WHITE)
  end
end

class MyWindow < Gosu::Window

    def initialize
        super WIDTH, HEIGHT
        self.caption = "Car Avoidance Demo"
        @song = Gosu::Song.new("Nutcracker REMIX.mp3")
        @song.play(true)
        @start = Start.new
        @player = Player.new
        @obstacles = []
        @ob = Obstacles.new
        @obstacles[0] = @ob
        @game_over = nil
        @lines = []

        for i in 1..3
            x = width / 4 * i
            @lines << Line.new(x, 0, height)
            @lines << Line.new(x, 120, height)
            @lines << Line.new(x, 240, height)
            @lines << Line.new(x, 360, height)
        end
    end

  def update

    if @start
      if button_down?(Gosu::KbSpace)
        @start = nil
      end
      return
    else
      if @game_over
        return
      end

      @player.score_add
      # Check for collision with player
      if @player.x_pos < @ob.x_pos + @ob.image.width &&
        @player.x_pos + @player.image.width > @ob.x_pos &&
        @player.y_pos < @ob.y_pos + @ob.image.height &&
        @player.y_pos + @player.image.height > @ob.y_pos
       # Collision detected
       puts "Collision!"
       @game_over = GameOver.new(@player.score)
     end

      @ob.move

      @lines.each do |line|
        line.auto(HEIGHT)
      end

      if button_down?(Gosu::KbRight) && @player.x_pos < 490 - @player.image.width 
        @player.rmove
      end

      if button_down?(Gosu::KbLeft) && @player.x_pos > 125 + @player.image.width 
        @player.lmove     
      end
      # Check if initial obstacle has gone out of the window
      if @ob.y_pos >= HEIGHT
        @obstacles.delete(@ob)
        # Create a new obstacle and add it to the array
        @ob = Obstacles.new
        @obstacles << @ob
      end
    end
  end

  def restart_game
    @start = Start.new
    @player = Player.new
    @obstacles.clear
    @ob = Obstacles.new # Reset @ob to a new instance of the Obstacles class
    @obstacles << @ob
    @game_over = nil
    @player.score = 0 # Reset player's score
  end 

  def button_down(id)
    if @game_over && id == Gosu::MsLeft && @game_over.mouse_over_button?(mouse_x, mouse_y)
      restart_game()
    end
  end

  def draw
    if @start
      @start.draw
    else
      @player.draw
      @obstacles.each do |obstacle|
        obstacle.draw
      end
      @lines.each do |line|
        line.draw
      end
      if @game_over
        @game_over.draw
      end
    end
  end
end

window = MyWindow.new
window.show
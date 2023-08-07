require 'gosu'

WIDTH = 600
HEIGHT = 480
PLAYER_SPEED = 5
AUTO_SPEED = 5

module ZOrder
  BACKGROUND, MIDDLE, TOP = *0..2
end

class Line
  attr_accessor :x, :y, :height

  def initialize(x, y, height)
    @x = x
    @y = y
    @height = height
  end

  def auto(height)
    @y += AUTO_SPEED
    # If the line reaches the bottom of the screen, it resets to the top
    if @y > height
      @y = 0
    end
  end

  def draw
    Gosu.draw_rect(@x, @y, 10, 50, Gosu::Color::WHITE, ZOrder::BACKGROUND)
  end
end

class Player
  attr_accessor :image, :x_pos, :y_pos, :score, :hi_score, :font, :score_txt, :hi_score_txt
  def initialize
    @image = Gosu::Image.new("Image/player.png")
    # Sets the initial position of the player
    @x_pos = WIDTH / 2
    @y_pos = HEIGHT - 30
    # Initializes the score and high score to 0
    @score = 0
    @hi_score = 0
    # Initializes the score and high score text
    @font = Gosu::Font.new(20)
    @score_txt = "Score: #{@score}"
    @hi_score_txt = "Hi-Score: #{@hi_score}"
  end

  #Player's movement (Right and Left)
  def rmove
    @x_pos += PLAYER_SPEED
  end

  def lmove
    @x_pos -= PLAYER_SPEED
  end

  def score_add
    # Adds 1 to the score and updates the score text
    @score += 1
    @score_txt = "Score: #{@score}"
    # Checks if the high score file exists. If it does, reads the high score from the file and assigns it to @hi_score
    if File.exist?('high_score.txt')
      @hi_score = File.read('high_score.txt').to_i
    end
    # If the current score is greater than the high score, updates the high score and saves it to the file
    if @score > @hi_score
      @hi_score = @score
      File.write('high_score.txt', @hi_score)
    end
    # Updates the high score text
    @hi_score_txt = "Hi-Score: #{@hi_score}"
  end
  
  def draw
    @image.draw_rot(@x_pos, @y_pos, ZOrder::MIDDLE)
    @font.draw_text(@score_txt, WIDTH - @font.text_width(@score_txt) - 10, 10, ZOrder::TOP)
    @font.draw_text(@hi_score_txt, WIDTH - @font.text_width(@hi_score_txt) - 10, 40, ZOrder::TOP)
  end
end

class Obstacles
    attr_accessor :image, :x_pos, :y_pos
    def initialize
        @image = Gosu::Image.new("Image/ob.png")
        # The x-position of the obstacle, randomly generated between 150 and 465
        @x_pos = rand(150..465) 
        @y_pos = 20
    end
    # Automatically moves the obstacle up
    def move
        @y_pos += AUTO_SPEED
    end

    def draw
        @image.draw_rot(@x_pos, @y_pos, ZOrder::MIDDLE)
    end
end

class GameOver
  def initialize(score, hi_score)
    # Store the score and hi-score
    @score = score
    @hi_score = hi_score
    # Create fonts for the text
    @font = Gosu::Font.new(32)
    # Set the width and height of the button
    @button_width = 200 
    @button_height = 50
    ####################
    @center_x = WIDTH / 2
    @center_y = HEIGHT / 2
    # The text labels for the game over screen
    @game_over_label = "Game Over"
    @game_over_x = @center_x - @font.text_width(@game_over_label) / 2
    @game_over_y = @center_y - 100
    @score_label = "Score: #{@score}"
    @score_x = @center_x - @font.text_width(@score_label) / 2
    @score_y = @center_y - 50
    @hi_score_label = "Hi-Score: #{@hi_score}"
    @hi_score_x = @center_x - @font.text_width(@hi_score_label) / 2
    @hi_score_y = @center_y
    # The x and y coordinates of the buttons
    @button_x = @center_x - @button_width / 2
    @button_y = @center_y + 30
  end

  def draw
    # Draws the text labels
    @font.draw_text(@game_over_label, @game_over_x, @game_over_y, ZOrder::TOP, 1, 1, Gosu::Color::WHITE)
    @font.draw_text(@score_label, @score_x, @score_y, ZOrder::TOP, 1, 1, Gosu::Color::WHITE)
    @font.draw_text(@hi_score_label, @hi_score_x, @hi_score_y, ZOrder::TOP, 1, 1, Gosu::Color::WHITE)

    # Draws the restart button
    Gosu.draw_rect(@button_x, @button_y, @button_width, @button_height, Gosu::Color::GRAY, ZOrder::MIDDLE)
    @font.draw_text("Restart", @center_x - 40, @center_y + 40, ZOrder::TOP, 1, 1, Gosu::Color::BLACK)

    # Draws the menu button    
    Gosu.draw_rect(@button_x, @button_y + 60, @button_width, @button_height, Gosu::Color::GRAY, ZOrder::MIDDLE)
    @font.draw_text("Menu", @center_x - 30, @center_y + 100, ZOrder::TOP, 1, 1, Gosu::Color::BLACK)
  end

  def mouse_over_restart?(mouse_x, mouse_y)
    # Check if the mouse is over the restart button
    mouse_x > @button_x && mouse_x < @button_x + @button_width && mouse_y > @button_y && mouse_y < @button_y + @button_height
  end

  def mouse_over_menu?(mouse_x, mouse_y)
    # Check if the mouse is over the menu button
    mouse_x > @button_x && mouse_x < @button_x + @button_width && mouse_y > @button_y + 80 && mouse_y < @button_y + 80 + @button_height
  end
end

class Start
  attr_accessor :buttons, :selected_button

  def initialize
    @font = Gosu::Font.new(32)
    @title_font = Gosu::Font.new(48)
    @title = "Car Avoidance"
    # Creates an array of buttons for the start screen
    @buttons = ['Play', 'Settings', 'Credits', 'Quit']
    # Sets the selected button to the first button in the array
    @selected_button = 0
  end

  def draw
    # Draw the title
    @title_font.draw_text(@title, WIDTH/2 - @title_font.text_width(@title)/2, HEIGHT/4, 1, 1, 1, Gosu::Color::WHITE)
    # Draws each button in the array
    @buttons.each_with_index do |button, index|
    # Check if the current button is the selected button. If yes --> Red color ; otherwise White.
      if index == @selected_button
        color = Gosu::Color::RED
      else
        color = Gosu::Color::WHITE
      end
      # Draw the button label with the specified color
      @font.draw_text(button, WIDTH/2 - @font.text_width(button)/2, HEIGHT/2 + index * 50, 1, 1, 1, color)
    end
  end
end

class SettingsScreen
  attr_accessor :music_volume, :volume_percentage

  def initialize
    @font = Gosu::Font.new(32)
    @title = "Settings"
    @music_volume = 100
    # Update the volume label to reflect the initial music volume
    update_volume_label
  end

  def draw
    # Draw the title and volume label
    @font.draw_text(@title, WIDTH / 2 - @font.text_width(@title) / 2, HEIGHT / 4, ZOrder::MIDDLE, 1, 1, Gosu::Color::WHITE)
    @font.draw_text(@volume_label, WIDTH / 2 - @font.text_width(@volume_label) / 2, HEIGHT / 2, ZOrder::MIDDLE, 1, 1, Gosu::Color::WHITE)
  end

  def set_music_volume(new_volume)
    # Make sure the volume is between 0 and 100.
    @music_volume = [new_volume, 0].max
    @music_volume = [100, @music_volume].min
    # Update the music volume and the volume label
    update_volume_label
    # Save the new music volume to a file
    File.write('music_volume.txt', @music_volume)
  end

  # Update the volume label to reflect the current music volume
  def update_volume_label
    # @volume_percentage is a floating-point number that represents the current music volume as a percentage
    # Calculate the volume percentage, then set the volume label to the current music volume
    @volume_percentage = @music_volume / 100.0
    @volume_label = "Music Volume: #{@music_volume}"
  end
end

class Pause
  def initialize(score, hi_score)
    # Store the score and hi-score
    @score = score
    @hi_score = hi_score
    # Create fonts for the text
    @font = Gosu::Font.new(32)
    @instruction_font = Gosu::Font.new(16)
    # Set the width and height of the button
    @button_width = 200
    @button_height = 50
    ####################
    @center_x = WIDTH / 2
    @center_y = HEIGHT / 2
    # Set the text labels for the pause screen
    @pause_label = "Pause"
    @pause_x = @center_x - @font.text_width(@pause_label) / 2
    @pause_y = @center_y - 100
    @score_label = "Score: #{@score}"
    @score_x = @center_x - @font.text_width(@score_label) / 2
    @score_y = @center_y - 50
    @hi_score_label = "Hi-Score: #{@hi_score}"
    @hi_score_x = @center_x - @font.text_width(@hi_score_label) / 2
    @hi_score_y = @center_y
    @instruction_label = "Press P to resume the game"
    @instruction_x = @center_x - @instruction_font.text_width(@instruction_label) / 2
    @instruction_y = HEIGHT - 30
    @button_x = @center_x - @button_width / 2
    @button_y = @center_y + 30
  end

  def draw
    # Draw the text labels
    @font.draw_text(@pause_label, @pause_x, @pause_y, ZOrder::TOP, 1, 1, Gosu::Color::WHITE)
    @font.draw_text(@score_label, @score_x, @score_y, ZOrder::TOP, 1, 1, Gosu::Color::WHITE)
    @font.draw_text(@hi_score_label, @hi_score_x, @hi_score_y, ZOrder::TOP, 1, 1, Gosu::Color::WHITE)
    @instruction_font.draw_text(@instruction_label, @instruction_x, @instruction_y, ZOrder::TOP, 1, 1, Gosu::Color::WHITE)

    # Draw restart button
    Gosu.draw_rect(@button_x, @button_y, @button_width, @button_height, Gosu::Color::GRAY, ZOrder::MIDDLE)
    @font.draw_text("Restart", @center_x - 40, @center_y + 40, ZOrder::TOP, 1, 1, Gosu::Color::BLACK)

    # Draw menu button
    Gosu.draw_rect(@button_x, @button_y + 60, @button_width, @button_height, Gosu::Color::GRAY, ZOrder::MIDDLE)
    @font.draw_text("Menu", @center_x - 30, @center_y + 100, ZOrder::TOP, 1, 1, Gosu::Color::BLACK)
  end

  def mouse_over_restart?(mouse_x, mouse_y)
    # Check if the mouse is over the restart button
    mouse_x > @button_x && mouse_x < @button_x + @button_width && mouse_y > @button_y && mouse_y < @button_y + @button_height
  end

  def mouse_over_menu?(mouse_x, mouse_y)
    # Check if the mouse is over the menu button
    mouse_x > @button_x && mouse_x < @button_x + @button_width && mouse_y > @button_y + 80 && mouse_y < @button_y + 80 + @button_height
  end
end

class MyWindow < Gosu::Window

  def initialize
    # Initialize the window and set the caption
    super WIDTH, HEIGHT
    self.caption = "Car Avoidance"
    # Create the start screen, game over screen, and settings screen
    @start = Start.new
    @game_over = nil
    @pause = nil
    # Create the player
    @player = Player.new
    # Create an array of obstacles
    @obstacles = []
    @ob = Obstacles.new
    @obstacles[0] = @ob
    # Create an array of lines
    @lines = []
    for i in 1..3
        x = WIDTH / 4 * i
        @lines << Line.new(x, 0, HEIGHT)
        @lines << Line.new(x, 120, HEIGHT)
        @lines << Line.new(x, 240, HEIGHT)
        @lines << Line.new(x, 360, HEIGHT)
    end

    # Load music volume from file and create a new SettingsScreen instance if needed
    load_music_volume

    # Create the song
    @song = Gosu::Song.new("Nutcracker REMIX.mp3")
    @song.volume = @settings_screen.music_volume / 100.0
    @settings_screen = nil
    # Play the song at the start of the menu
    @song.play(true)
  end

  def update
    # Check if any game screen is visible
    if @start
      return
    elsif @settings_screen
      return
    elsif @pause
      return
    elsif @game_over
      return
    else
      # Increase the player's score
      @player.score_add
      # Check for collision with the obstacle (AABB method)
      if @player.x_pos < @ob.x_pos + @ob.image.width && 
        @player.x_pos + @player.image.width > @ob.x_pos && 
        @player.y_pos < @ob.y_pos + @ob.image.height && 
        @player.y_pos + @player.image.height > @ob.y_pos
        # Collision detected
        puts "Collision!"
        @game_over = GameOver.new(@player.score, @player.hi_score)
      end
      # Move the obstacle
      @ob.move
      # Move the lines
      @lines.each do |line|
        line.auto(HEIGHT)
      end
      # Move the player left or right if the corresponding key is pressed
      if button_down?(Gosu::KbRight) && @player.x_pos < 490 - @player.image.width 
        @player.rmove
      end
      if button_down?(Gosu::KbLeft) && @player.x_pos > 125 + @player.image.width 
        @player.lmove     
      end
      # Check if initial obstacle has gone out of the window
      if @ob.y_pos >= HEIGHT
        # Remove the initial obstacle from the array
        @obstacles.delete(@ob)
        # Create a new obstacle and add it to the array
        @ob = Obstacles.new
        @obstacles << @ob
      end
    end
  end

  def button_down(id)
    # Check if the start screen is visible
    if @start
      # Handle button presses in the start screen
      if id == Gosu::KbDown && @start.selected_button < @start.buttons.length - 1
        @start.selected_button += 1
      elsif id == Gosu::KbUp && @start.selected_button > 0
        @start.selected_button -= 1
      elsif id == Gosu::KbEnter || id == Gosu::KbReturn
        # Execute the corresponding action based on the selected button
        case @start.buttons[@start.selected_button]
          # Start the game
          when 'Play'
            @start = nil
          # Enter the settings screen
          when 'Settings'
            @settings_screen = SettingsScreen.new
            load_music_volume
            @start = nil
          # Enter the credits screen
          when 'Credits'
            puts "Enter the credits"
          # Quit the game
          when 'Quit'
            close
        end
      end
    # Check if the settings screen is visible
    elsif @settings_screen
      # Increase or decrease the music volume by 10
      if id == Gosu::KbUp
        adjust_music_volume(10)
      elsif id == Gosu::KbDown
        adjust_music_volume(-10)
      elsif id == Gosu::KbEscape
        # Close the settings screen and return to the main menu
        @settings_screen = nil
        @start = Start.new
      end
    # Check if the game over screen is visible
    elsif @game_over && id == Gosu::MsLeft
      # Restart the game
      if @game_over.mouse_over_restart?(mouse_x, mouse_y)
        restart_game()
      # Return to the main menu
      elsif @game_over.mouse_over_menu?(mouse_x, mouse_y)
        back_to_menu()
      end
    # Check if the pause screen is visible
    elsif @pause == nil
      # Pause the game
      if id == Gosu::KbP
        @pause = Pause.new(@player.score, @player.hi_score)
      end
    elsif @pause
      # Restart the game
      if @pause.mouse_over_restart?(mouse_x, mouse_y)
        restart_game()
      # Return to the main menu
      elsif @pause.mouse_over_menu?(mouse_x, mouse_y)
        back_to_menu()
      # Resume the game
      elsif id == Gosu::KbP
        @pause = nil
      end
    end
  end

  def restart_game
    @player = Player.new
    # Clear the obstacles array
    @obstacles.clear
    # Create a new obstacle object and add it to the obstacles array
    @ob = Obstacles.new
    @obstacles << @ob
    # If the game over or pause screen is visible, hide it
    if @game_over
      @game_over = nil
    elsif @pause
      @pause = nil
    end
    # Reset the player's score
    @player.score = 0
  end 

  def back_to_menu
    # Create a new start screen
    @start = Start.new
    @player = Player.new
    #Already explain on the def restart_game
    @obstacles.clear
    @ob = Obstacles.new
    @obstacles << @ob
    if @game_over
      @game_over = nil
    elsif @pause
      @pause = nil
    end
    @player.score = 0
  end

  def adjust_music_volume(delta)
    # Increase or decrease the music volume by the specified amount (10)
    @settings_screen.set_music_volume(@settings_screen.music_volume + delta)
    # Update the song volume
    @song.volume = @settings_screen.music_volume / 100.0
  end

  def load_music_volume
    # If the music volume file exists, load the file
    if (File.exist?('music_volume.txt'))
      # If the settings screen is not yet created, create it
      if @settings_screen.nil?
        @settings_screen = SettingsScreen.new
      end
      # Get the music volume from the file
      @settings_screen.music_volume = File.read('music_volume.txt').to_i
      # Update the volume label in the Settings screen
      @settings_screen.update_volume_label
    else
      # If the file does not exist, create a new settings screen and set the music volume to 100
      if @settings_screen.nil?
        @settings_screen = SettingsScreen.new
      end
    end
  end

  def draw
    # Check which screen is currently visible
    if @start
      @start.draw
    elsif @settings_screen
      @settings_screen.draw
    elsif @pause
      @pause.draw
    elsif @game_over
      @game_over.draw
    else
      # Draw the player, obstacles, and lines
      @player.draw
      @obstacles.each do |obstacle|
        obstacle.draw
      end
      @lines.each do |line|
        line.draw
      end
    end
  end
end

window = MyWindow.new
window.show
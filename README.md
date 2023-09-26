# Car Avoidance Game
This repository contains the source code for a simple car avoidance game developed using the Gosu library in Ruby. The game involves controlling a player's car to avoid obstacles and achieve a high score. __Actually, this is just a school project__.
## Game Description
Car Avoidance is a simple 2D game where players control a car and attempt to avoid all the obstacles along the road. The game features a car that the player can move left and right, as well as obstacles that move downward. The objective is to get the highest score by avoiding collisions with any obstacles.

<p align="center">
<img src="https://github.com/baotan1909/Car-Avoidance/assets/125344198/059144f5-d2e4-432b-8d44-da2bdecaeff1)" alt="main_gameplay">
</p>

## Gameplay
- The player controls a car using the left and right arrow keys to move horizontally.
- The goal is to avoid colliding with the randomly generated obstacles that move downwards on the screen.
- The player's score increases as long as they don't collide with any obstacle.
- The game ends when the player collides with an obstacle.
- The highest score achieved is recorded for the future play.
## Features
- Player movement: The player can move the car left and right to avoid obstacles by using corresponding arrow keys (left and right).
- Collision Detection: The game use AABB collision detection for the sake of simplicity.
- Scoring system: As long as the player does not collide with any obstacles, their score increases, and the highest score is saved for future play.
- Game Over screen: When the game ends, a Game Over screen is displayed showing the score, high score, and options to restart or return to the main menu.
- Start screen: The game starts with a start screen allowing the player to begin the game, view the instructions on how to play, access settings, view credits (actually no), or quit the game.
- Settings screen: The settings screen allows the player to adjust the music volume. This music volume will be recorded so that they don't need to change again in future.
## Dependencies
Install Gosu, which is a 2D game development library for Ruby, and you will be fine.
## Usage
To run the game, ensure that you have Ruby and the Gosu library installed. Follow these steps (or simply message me and you will get the .exe file):
1. Clone the repository
```bash
git clone https://github.com/your-username/car-avoidance-game.git
```
2. Navigate to the project directory:
```bash
cd car-avoidance-game
```
3. Run the game:
```bash
ruby demo.rb
```
## Credit
In this project, I used:
1. Asset: __Cars - TMD Studios__
Link: https://tmd-studios.itch.io/cars
Support them at: https://tmdstudios.wordpress.com/
2. Music: __[TPRMX] Tchaikovsky - The Nutcracker Suite 'March' REMIX__
Link: https://www.youtube.com/watch?v=AfEEXuWObD8

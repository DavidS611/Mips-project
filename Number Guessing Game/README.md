# Number Guessing Game

## Overview

This repository contains an assembly program designed for the MIPS architecture, implementing a simple yet engaging number guessing game. The user is prompted to enter a three-digit number, and the objective is to guess the correct number within the game's rules.

## Assembly Code Structure

### Data Section

- **Prompt and Error Messages:** The data section includes strings used for prompts and error messages, enhancing user interaction.
  
- **User Input and Game State Variables:** The data section defines variables responsible for storing user input and game-related information. This includes the target number to be guessed.

### Text Section

- **Main Program Logic:** The text section contains the main program logic, orchestrating the flow of the game.

- **Function Definitions:**
  - `print_string`: A function to print strings to the console.
  - `get_three_digit_number`: A function to retrieve a three-digit number from the user.
  - `get_guess`: A function to obtain a guess from the user.
  - `compare_guess`: A function to compare the user's guess with the target number.

- **Game Loop:** The assembly code implements the main game loop, managing user input, feedback, and progression.

- **Input Validation:** The program includes mechanisms to validate user input, ensuring adherence to the game's rules.

## How to Play

1. **Compilation:**
   - Assemble the code using a MIPS assembler.
   - Link the object file to create an executable.

2. **Execution:**
   - Run the compiled executable on a MIPS emulator or compatible hardware.

3. **Gameplay:**
   - The game prompts the user to enter a three-digit number.
   - Users provide guesses, and the program provides feedback in the form of 'b' (correct digit and position) and 'p' (correct digit but wrong position).
   - Aim to guess the correct number with the fewest attempts.

4. **Another Game:**
   - After each round, the program asks if the user wants to play another game.


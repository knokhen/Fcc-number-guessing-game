#!/bin/bash

PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"

echo "Enter your username:"
read USERNAME

USERNAME_RESULT=$(echo "$($PSQL "SELECT username FROM users WHERE username='$USERNAME'")" | sed 's/ //g')

if [[ -z $USERNAME_RESULT ]]; then
  INSERT_USER_RESULT=$($PSQL "INSERT INTO users (username) VALUES ('$USERNAME')")
  USER_ID=$(echo "$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")" | sed 's/ //g')
  echo -e "\nWelcome, $USERNAME! It looks like this is your first time here."
else
  USER_ID=$(echo "$($PSQL "SELECT user_id FROM users WHERE username='$USERNAME'")" | sed 's/ //g')
  BEST_GUESS=$(echo "$($PSQL "SELECT MIN(guesses) FROM games WHERE user_id=$USER_ID")" | sed 's/ //g')
  GAMES_PLAYED=$(echo "$($PSQL "SELECT COUNT(game_id) FROM games WHERE user_id=$USER_ID")" | sed 's/ //g')
  echo -e "\nWelcome back, $USERNAME! You have played $GAMES_PLAYED games, and your best game took $BEST_GUESS guesses."
fi

NUMBER=$((RANDOM % 1000 + 1))
NUMBER_OF_GUESS=0

echo -e "\nGuess the secret number between 1 and 1000:"
read GUESS
while ((GUESS != NUMBER)); do
  ((NUMBER_OF_GUESS += 1))
  if [[ ! $GUESS =~ ^[0-9]+$ ]]; then
    echo -e "\nThat is not an integer, guess again:"
    read GUESS
  elif ((GUESS < NUMBER)); then
    echo -e "\nIt's higher than that, guess again:"
    read GUESS
  else
    echo -e "\nIt's lower than that, guess again:"
    read GUESS
  fi
done
((NUMBER_OF_GUESS += 1))
INSERT_GAME=$($PSQL "INSERT INTO games (guesses, user_id) VALUES ($NUMBER_OF_GUESS, $USER_ID)")
echo -e "\nYou guessed it in $NUMBER_OF_GUESS tries. The secret number was $NUMBER. Nice job!"

#!/bin/bash
psql --username=freecodecamp --dbname=postgres -c "CREATE DATABASE number_guess;"
PSQL="psql --username=freecodecamp --dbname=number_guess -t --no-align -c"
USERS_TABLE_RESULT=$($PSQL "CREATE TABLE users(user_id SERIAL PRIMARY KEY,username VARCHAR(22) UNIQUE NOT NULL);")
echo -e "\n$USERS_TABLE_RESULT"
GAMES_TABLE_RESULT=$($PSQL "CREATE TABLE games(game_id SERIAL PRIMARY KEY,guesses INT,user_id INT NOT NULL REFERENCES users (user_id));")
echo -e "\n$GAMES_TABLE_RESULT"

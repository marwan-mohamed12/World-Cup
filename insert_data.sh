#! /bin/bash

if [[ $1 == "test" ]]
then
  PSQL="psql --username=postgres --dbname=worldcuptest -t --no-align -c"
else
  PSQL="psql --username=freecodecamp --dbname=worldcup -t --no-align -c"
fi

# Do not change code above this line. Use the PSQL variable above to query your database.

echo $($PSQL "truncate games, teams")

cat games.csv | while IFS=',' read YEAR ROUND WINNER OPPONENT WINNER_GOSLS OPPONENT_GOALS
do
  if [[ $YEAR != year ]]
  then
    # get the winner_id
    WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
    if [[ -z $WINNER_ID ]]
    then
      INSERT_TEAMS=$($PSQL "insert into teams(name) values('$WINNER')")
    fi
      WINNER_ID=$($PSQL "select team_id from teams where name = '$WINNER'")
      echo -e "\nWinner is $WINNER and it's id $WINNER_ID\n"

    # get the opponent id
    TEAM_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
    if [[ -z $TEAM_ID ]]
    then
      INSERT_TEAMS=$($PSQL "insert into teams(name) values('$OPPONENT')")
    fi
      OPPONENT_ID=$($PSQL "select team_id from teams where name = '$OPPONENT'")
      echo -e "\nOpponent is $OPPONENT and it's id $OPPONENT_ID\n"
    # insert into games table
    INSERT_GAME_RESULT=$($PSQL "insert into games(year, round, winner_id, opponent_id, winner_goals, opponent_goals) values($YEAR, '$ROUND', $WINNER_ID, $OPPONENT_ID, $WINNER_GOSLS, $OPPONENT_GOALS);")
    if [[ $INSERT_GAME_RESULT == "INSERT 0 1" ]]
    then
      echo "Inserted row into games"
    fi
  fi 
done


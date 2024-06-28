#!/bin/bash
# Provide argument to change out put

PSQL="psql --username=freecodecamp --dbname=periodic_table -t --no-align -c"

# check argument input
if [[ -z $1 ]]; then
  # no argument input
  echo "Please provide an element as an argument."
else
  # check input argument is number
  if [[ $1 =~ ^([0-9]+)$ ]]
  then
    # get info as atomic number
    INFO=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius,type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE atomic_number = $1")
  else
    # get info as name or symbol
    INFO=$($PSQL "SELECT atomic_number, name, symbol, atomic_mass, melting_point_celsius, boiling_point_celsius,type FROM properties INNER JOIN elements USING(atomic_number) INNER JOIN types USING(type_id) WHERE name = '$1' OR symbol = '$1'")
  fi

  # if element not exits
  if [[ -z $INFO ]]; then
    echo "I could not find that element in the database."
  else
    # found element
    echo $INFO | while IFS="|" read ATOM_NUMBER NAME SYMBOL ATOM_MASS MELT_POINT BOIL_POINT TYPE; do
      echo "The element with atomic number $ATOM_NUMBER is $NAME ($SYMBOL). It's a $TYPE, with a mass of $ATOM_MASS amu. $NAME has a melting point of $MELT_POINT celsius and a boiling point of $BOIL_POINT celsius."
    done
  fi
fi

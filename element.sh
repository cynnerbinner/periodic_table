#! /bin/bash

PSQL="psql -X --username=freecodecamp --dbname=periodic_table --tuples-only -c"

ELEMENT_INPUT=$1

PARSE_INPUT() {
if [[ -z $ELEMENT_INPUT ]]
  then
  echo "Please provide an element as an argument."
  else  
  if [[ $ELEMENT_INPUT =~ ^[0-9]+$ ]]
    then
    ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE atomic_number = $ELEMENT_INPUT")
    else
    ELEMENT_ID=$($PSQL "SELECT atomic_number FROM elements WHERE symbol = '$ELEMENT_INPUT' OR name = '$ELEMENT_INPUT'")
    fi
  if [[ -z $ELEMENT_ID ]]
    then
    echo "I could not find that element in the database."
    else
    ELEMENT_INFO=$($PSQL "SELECT e.atomic_number, e.name, e.symbol, t.type, p.atomic_mass, p.melting_point_celsius, p.boiling_point_celsius FROM elements e FULL JOIN properties p USING(atomic_number) FULL JOIN types t USING(type_id) WHERE e.atomic_number = $ELEMENT_ID")
    echo "$ELEMENT_INFO" | while read ATNMR BAR NAME BAR SYMBOL BAR TYPE BAR MASS BAR MELT BAR BOIL
      do
      echo -e "The element with atomic number $ATNMR is $NAME ($SYMBOL). It's a $TYPE, with a mass of $MASS amu. $NAME has a melting point of $MELT celsius and a boiling point of $BOIL celsius."
      done
    fi
  fi
}

PARSE_INPUT

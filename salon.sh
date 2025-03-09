#!/bin/bash
PSQL="psql --username=freecodecamp --dbname=salon -t --no-align -c"
echo -e "\n~~~~~ MY SALON ~~~~~\n"
echo -e "\nWelcome to My Salon, how can I help you?\n"

MAIN_MENU(){
  echo $1
  SERVICES=$($PSQL "select service_id,name from services")
  echo "$SERVICES" | while IFS="|" read SERVICE_ID NAME
  do 
    if [[ $SERVICE_ID != 'service_id' ]]
    then 
      echo "$SERVICE_ID) $NAME"
    fi
   
  done  
  read SERVICE_ID_SELECTED
  case $SERVICE_ID_SELECTED in
    1) CUT ;;
    2) COLOR ;;
    3) STYLE ;; 
    *) MAIN_MENU "I could not find that service. What would you like today?"
  esac  

}

CUT(){
  echo -e "\nWhat's your phone number?"
  read CUSTOMER_PHONE
  CHECK_PHONE=$($PSQL "select phone from customers where phone='$CUSTOMER_PHONE'")
  if [[ -z $CHECK_PHONE ]]
  then
    echo -e "\nI don't have a record for that phone number, what's your name?"
    read CUSTOMER_NAME
    insert2=$($PSQL "insert into customers(name,phone) values('$CUSTOMER_NAME','$CUSTOMER_PHONE')")
    CUSTOMER_ID=$($PSQL "select customer_id from customers where phone='$CUSTOMER_PHONE'")
    
  else
    CUSTOMER_NAME=$($PSQL "select name from customers where phone='$CUSTOMER_PHONE'")
    CUSTOMER_ID=$($PSQL "select customer_id from customers where name='$CUSTOMER_NAME'")
  fi  
  echo -e "\nWhat time would you like your cut, $CUSTOMER_NAME?"
  read SERVICE_TIME
  SERVICE_ID=$($PSQL "select service_id from services where name='cut'")
  if [[ ! -z $CUSTOMER_ID ]]
  then
    insert1=$($PSQL "insert into appointments(time,customer_id,service_id) values('$SERVICE_TIME',$CUSTOMER_ID,$SERVICE_ID)")
    echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
  fi  

}
MAIN_MENU
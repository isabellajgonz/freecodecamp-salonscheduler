#!/bin/bash

PSQL="psql -X --username=freecodecamp --dbname=salon --tuples-only -c"

echo -e "\n~~~~~ My Salon ~~~~~\n"
echo -e "Welcome to My Salon, How can I help you?"

APPOINTMENT_MENU(){
echo -e "\nWhat's your phone number?"
read CUSTOMER_PHONE
CUSTOMER_NAME=$($PSQL "SELECT name FROM customers where phone='$CUSTOMER_PHONE'")

if [[ -z $CUSTOMER_NAME ]]
then
  echo -e "\nI don't have a record for that phone number, what's your name?"
  read CUSTOMER_NAME
  INSERT_CUSTOMER_RESULT=$($PSQL "INSERT INTO customers(name, phone) VALUES('$CUSTOMER_NAME', '$CUSTOMER_PHONE')")
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  SERVICE_NAME=$($PSQL"SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your$SERVICE_NAME, $CUSTOMER_NAME?"
  read SERVICE_TIME
  echo -e "\nI have put you down for a cut at $SERVICE_TIME, $CUSTOMER_NAME."
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")
else
  CUSTOMER_ID=$($PSQL "SELECT customer_id FROM customers WHERE phone='$CUSTOMER_PHONE'")
  SERVICE_NAME=$($PSQL"SELECT name FROM services WHERE service_id='$SERVICE_ID_SELECTED'")
  echo -e "\nWhat time would you like your$SERVICE_NAME,$CUSTOMER_NAME?"
  read SERVICE_TIME
  echo -e "\nI have put you down for a cut at $SERVICE_TIME,$CUSTOMER_NAME."
  INSERT_APPOINTMENT=$($PSQL "INSERT INTO appointments(customer_id, service_id, time) VALUES('$CUSTOMER_ID', '$SERVICE_ID_SELECTED', '$SERVICE_TIME')")

fi
}

MAIN_MENU(){
AVAILABLE_SERVICES=$($PSQL "SELECT service_id, name FROM services")

echo "$AVAILABLE_SERVICES" | while read SERVICE_ID BAR NAME BAR
do
  echo "$SERVICE_ID) $NAME" 
done

read SERVICE_ID_SELECTED
VALID_SERVICE_ID=$($PSQL "SELECT service_id FROM services WHERE service_id=$SERVICE_ID_SELECTED")
if [[ -z $VALID_SERVICE_ID ]]; then
  echo -e "\nI could not find that service. What would you like today?"
  MAIN_MENU
else
  APPOINTMENT_MENU
fi
}

MAIN_MENU


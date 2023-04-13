#!/bin/bash

echo "Select option:"
echo "1) Quick connect"
echo "2) Connect to specific server"
echo "3) Connect to Peer-to-Peer (P2P) server"
echo "4) Connect to streaming-optimized server"
echo "5) Check VPN connection status"
echo "6) Terminate VPN connection"

read main_selection

case $main_selection in

    1)
        # Display list of available countries with their country code.
        cyberghostvpn --traffic --country-code | more

        echo -n "Enter country code or country number: "
        read country_input

        # Check if input is an integer and then check if exit code = 0 (i.e., if the exit code = 0, an integer was input).
        if [ $(echo $country_input | grep -Eq "[0-9]+"; echo $?) -eq 0 ]
        then

            # Get list of all countries, use grep to match the number to the corresponding country in the list, use sed to filter output and match for the country code.
            country_code=$(cyberghostvpn --traffic --country-code | grep "|  $country_input \? |" | sed "s/.*|\s*\([A-Z][A-Z]\)\s*|/\1/")

            # Get list of country codes, use grep to match the country code to the country name, use awk to print 4th field (name of country).
            selected_country=$(cyberghostvpn --traffic --country-code | grep -i "|      $country_code      |" | awk '{print $4, $5, $6}' | sed "s/ |.*//")
            echo "Selected country: $selected_country"

            # Connect to server using $country_code variable.
            sudo cyberghostvpn --traffic --country-code $country_code --connect

        else

            # Get list of country codes, use grep to match the country code to the country name, use awk to print 4th field (name of country).
            selected_country=$(cyberghostvpn --traffic --country-code | grep -i "|      $country_input      |" | awk '{print $4, $5, $6}' | sed "s/ |.*//")
            echo "Selected country: $selected_country"

            # Connect to server using $country_input variable.
            sudo cyberghostvpn --traffic --country-code $country_input --connect
        fi

    ;;

    2)
        # Display list of available countries with their country code.
        cyberghostvpn --traffic --country-code | more

        echo -n "Enter country code: "
        read country_code

        # Display available cities in the selected country using the $country_code variable.
        cyberghostvpn --traffic --country-code $country_code

        echo -n "Select city [Enter number]: "
        read city_number

        # Get all server locations from the selected country, use grep to match the input to a the corresponding city, use awk to print 4th and 5th field (to account for city names with 2 words), use sed to filter output and obtain city name in correct format.
        city=$(cyberghostvpn --traffic --country-code $country_code | grep  "|  $city_number \? |" | awk '{print $4, $5}' | sed "s/ \?|//")

        # Display available servers using $country_code and $city variables.
        cyberghostvpn --traffic --country-code $country_code --city "$city" | more

        echo -n "Select server for $city [Enter number]: "
        read server_number

        # Get all server instances in the selected country, use grep to match the input to the corresponding server instance, use awk to print the 6th field (server instance).
        server_instance=$(cyberghostvpn --traffic --country-code $country_code --city "$city" | grep "| \? $server_number \? |" | awk '{print $6, $7}' | sed -E "s/\s*\|\s*//")

        # Get list of country codes, use grep to match the country code to the country name, use awk to print 4th field (name of country).
        selected_country=$(cyberghostvpn --traffic --country-code | grep -i "|      $country_code      |" | awk '{print $4, $5, $6}' | sed "s/ |.*//")
        echo "Selected country: $selected_country"
        echo "Selected city: $city"
        # Connect to selected server using $country_code, $city and $server_instance variables.
        sudo cyberghostvpn --traffic --country-code $country_code --city "$city" --server $server_instance --connect
    ;;

    3)
        # Display list of countries which support P2P File Sharing.
        cyberghostvpn --torrent --country-code | more

        echo -n "Enter country code or country number: "
        read country_input

        # Check if input is an integer and then check if exit code = 0 (i.e., if the exit code = 0, an integer was input).
        if [ $(echo $country_input | grep -Eq "[0-9]+"; echo $?) -eq 0 ]
        then

            # Get list of all countries, use grep to match the number to the corresponding country in the list, use sed to filter output and match for the country code.
            country_code=$(cyberghostvpn --torrent --country-code | grep "|  $country_input \? |" | sed "s/.*|\s*\([A-Z][A-Z]\)\s*|/\1/")

            # Get list of country codes, use grep to match the country code to the country name, use awk to print 4th field (name of country).
            selected_country=$(cyberghostvpn --traffic --country-code | grep -i "|      $country_code      |" | awk '{print $4, $5, $6}' | sed "s/ |.*//")
            echo "Selected country: $selected_country"

            # Connect to P2P server using $country_code variable.
            sudo cyberghostvpn --torrent --country-code $country_code --connect

        else
            # Get list of country codes, use grep to match the country code to the country name, use awk to print 4th field (name of country).
            selected_country=$(cyberghostvpn --traffic --country-code | grep -i "|      $country_input      |" | awk '{print $4, $5, $6}' | sed "s/ |.*//")
            echo "Selected country: $selected_country"

            # Connect to P2P server using $country_input variable.
            sudo cyberghostvpn --torrent --country-code $country_input --connect
        fi
    ;;

    4)
        echo "Select option:"
        echo "1) Quick connect to streaming-optimized server"
        echo "2) Filter list of streaming services by country"

        read sub_selection

        case $sub_selection in

            1)
                # Display list of all streaming-optimized servers.
                cyberghostvpn --streaming --country-code | more

                echo -n "Select streaming service [Enter number]: "
                read service_number

                # Get list of all streaming-optimized servers, use grep to match number to the corresponding service, use awk to print the 4th-7th field (to account for services with names with 4 words), use sed to filter output and obtain service name in correct format.
                streaming_service=$(cyberghostvpn --streaming --country-code | grep "| \? $service_number \? |" | awk '{print $4, $5, $6, $7}' | sed "s/ |.*//")

                # Get list of all streaming-optimized servers, use grep to match the number to the corresponding service in the list, use sed to filter output and match for the country code.
                country_code=$(cyberghostvpn --streaming --country-code | grep "| \? $service_number \? |" | sed "s/.*|\s*\([A-Z][A-Z]\)\s*|/\1/")

                # Get list of country codes, use grep to match the country code to the country name, use awk to print 4th field (name of country).
                selected_country=$(cyberghostvpn --traffic --country-code | grep -i "|      $country_code      |" | awk '{print $4, $5, $6}' | sed "s/ |.*//")
                echo "Selected country: $selected_country"

                echo "Streaming service selected: $streaming_service"

                # Connect to streaming-optimized server using $streaming_service and $country_code variables.
                sudo cyberghostvpn --streaming "$streaming_service" --country-code $country_code --connect
            ;;

            2)
                echo -n "Enter country code: "
                read country_code

                # Check if streaming services exist for the $country_code variable input, if they do not the grep search should match and have an exit code of 0 (i.e., if the exit code = 0, streaming services do not exist for $country_code).
                if [ $(cyberghostvpn --streaming --country-code $country_code | grep -q "no streaming services\!"; echo $?) -eq 0 ]
                then
                    echo "There are no streaming services for '$country_code'!"
                    exit
                fi

                # Display list of streaming service in specified country only
                cyberghostvpn --streaming --country-code $country_code

                echo -n "Select streaming service [Enter number]: "
                read service_number

                # Get list of all streaming-optimized servers for the selected country, use grep to match number to the corresponding service, use awk to print the 4th-7th field (to account for services with names with 4 words), use sed to filter output and obtain service name in correct format.
                streaming_service=$(cyberghostvpn --streaming --country-code $country_code | grep "| \? $service_number \? |" | awk '{print $4, $5, $6, $7}' | sed "s/ |.*//")

                # Get list of country codes, use grep to match the country code to the country name, use awk to print 4th field (name of country).
                selected_country=$(cyberghostvpn --traffic --country-code | grep -i "|      $country_code      |" | awk '{print $4, $5, $6}' | sed "s/ |.*//")
                echo "Selected country: $selected_country"

                echo "Streaming service selected: $streaming_service"

                # Connect to streaming-optimized server using $streaming_service and $country_code
                sudo cyberghostvpn --streaming "$streaming_service" --country-code $country_code --connect
            ;;

            *)
                echo "Invalid option entered."
                exit 2
            ;;

        esac
    ;;

    5)
        # Check if there is a VPN connection open.
        cyberghostvpn --status
    ;;

    6)
        # Check if output contains 'VPN connection found.' and then check if exit code = 0 (i.e., if the exit code = 0, there is a VPN connection open).
        if [ $(cyberghostvpn --status | grep -q "VPN connection found."; echo $?) -eq 0 ]
        then

            # Terminate all VPN connection.
            sudo cyberghostvpn --stop

        else
            echo "No VPN connection found."
            exit
        fi
    ;;

    *)
        echo "Invalid option entered."
        exit 2
    ;;
esac
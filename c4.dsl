workspace "Solucion EA Funda Arqui 2022-2" {



   model {

       user = person "Passenger"

       user2 = person "Driver"

       user3 = person "Business Operator"

       extS1 = softwareSystem "Maps System" "Google Maps" "Existing System"

       extS2 = softwareSystem "Payment System" "Paypal, Mastercard, Visa" "Existing System"

       s1 = softwareSystem "Uber" {

           service1 = container "Riders Micro Service" "Passenger demand management service" "Java" "BoundedContext"

           service2 = container "Cabs Micro Service" "Drivers demand management service" "Node.js" "BoundedContext"

           service3 = container "Disco Micro Service" "Operational dispatch service" "Python" "BoundedContext" {

               this -> extS2 "Manages payments with"

           }

           service4 = container "S3 Micro Service" "S3 Hex Hierarchical Index Service" "Go" "BoundedContext" {

               this -> extS1 "Gets maps from"

           }

           gateway = container "API Gateway" "Redirects HTTP requests to micro services" "" "BoundedContext" {

               this -> service1 "Makes HTTP requests to"

               this -> service2 "Makes HTTP requests to"


               this -> service3 "Makes HTTP requests to"

           }

           mobileApp = container "Passengers Mobile Application" "" "Java & Scala" "Mobile" {

               user -> this "Uses"

               this -> gateway "Makes HTTP requests to"

           }

           mobileApp2 = container "Drivers Mobile Application" "" "Java & Scala" "Mobile" {

               user2 -> this "Uses"

               this -> gateway "Makes HTTP requests to"

           }

           webApp = container "Activation Center Web Application" "" "Python" "Browser" {

               user3 -> this "Uses"

               this -> gateway "Makes HTTP requests to"

           }

           database1 = container "Riders No SQL Database" "Stores data from Riders Micro Service" "MongoDB" "NoSQLDatabase"


           database2 = container "S3 No SQL Database" "S3 Micro Service" "Cassandra" "NoSQLDatabase" {

               service4 -> this "Reads and writes to"

           }
           
           database3 = container "Cabs No SQL Database" "Stores data from Cabs Micro Service" "MongoDB" "NoSQLDatabase"
           
           brokerKafka = container "Kafka Broker" "Message broker" "Kafka" "Broker" {
                service1 -> this "Reads and writes to"
                this -> database1 "Reads and writes to"
                
                service2 -> this "Reads and writes to"
                this -> database3 "Reads and writes to"

           }
           service3 -> service4 "Uses"
       }

   }

   views {

       theme default

       systemContext s1 {

           include *

           autolayout tb

       }

       container s1 "Containers" {

           include *

           autolayout tb

       }

       styles {

           element "Existing System" {

               background #999999

               color #ffffff

           }

           element "Database" {

               shape cylinder

           }
           
           element "Broker" {
              
               shape pipe
               
               background #FFFF00 
           }

           element "NoSQLDatabase" {

               shape cylinder

               background #25CED1

           }

           element "Mobile" {

               shape MobileDeviceLandscape

           }

           element "BoundedContext" {

               background #00b300

           }

           element "APIGateway" {

               background #ED7D3A

           }

           element "Browser" {

               shape WebBrowser

           }

       }

   }

}

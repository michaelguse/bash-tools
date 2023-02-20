.[]
| select(.isCore == true) 
| select(.message.maintenanceType == "release") 
| select(.name | contains("Major Release")) 
| select(.name | contains("-") | not)
| { Name: .name, Start: .plannedStartTime }
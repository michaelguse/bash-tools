.Maintenances[]
| select(.isCore == true) 
| select(.message.maintenanceType == "release") 
| select(.name | contains("Major Release")) 
| select(.name | contains("-") | not) 
| { "maintId" : .id, "maintStatus": .message.eventStatus, "name" : .name, "start" : .plannedStartTime, "end" : .plannedEndTime }
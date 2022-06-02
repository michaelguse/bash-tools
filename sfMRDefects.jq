.Maintenances[]
| select(.isCore == true) 
| select(.message.maintenanceType == "release") 
| select(.name | contains("Major Release")) 
| select(.name | contains("-") | not) 
| { "maintId" : .id, "name" : .name, "start" : .plannedStartTime, "end" : .plannedEndTime }
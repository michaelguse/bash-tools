.Maintenances[]
| select(.isCore == true) 
| select(.message.maintenanceType == "release") 
| select(.name | contains("Major Release")) 
| { "name" : .name, "start" : .plannedStartTime, "end" : .plannedEndTime }
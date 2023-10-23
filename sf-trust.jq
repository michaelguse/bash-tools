.Maintenances[]
| select(.isCore == true) 
| select(.message.maintenanceType == "release") 
| { "maintId" : .id, "maintStatus": .message.eventStatus, "name" : .name, "start" : .plannedStartTime, "end" : .plannedEndTime }
.[] 
| select(.isActive == true) 
| select(.environment == "sandbox") 
#| select(.Products[].key == "Salesforce_Services")
| [.key, .releaseVersion, .location, .status] 
| @csv

.[] 
| select(.isActive == true) 
| select(.Products[].key == "Salesforce_Services")
| [.key] 
| @tsv

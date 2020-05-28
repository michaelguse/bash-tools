.[] 
| select(.isActive == true) 
| select(.environment == "sandbox") 
| [.key, .releaseVersion, .location, .status] 
| @csv

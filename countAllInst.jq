.[] 
| select(.isActive == true) 
| select(.environment == "sandbox") 
| .key

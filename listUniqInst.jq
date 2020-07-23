[
.[]
| select(.isActive == true) 
| select(.environment == "sandbox") 
| .releaseVersion
]
| unique
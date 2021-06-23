[
.[]
| select(.isActive == true) 
| select(.environment == "sandbox") 
| select(.Products[].key == "Salesforce_Services")
| {Key: .key, Release: .releaseVersion}
]
| group_by(.Release) 
| map({ release: .[0].Release, count: map(.Key) | length})
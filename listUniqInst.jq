[
.[]
| select(.isActive == true) 
| select(.environment == "sandbox") 
| {Key: .key, Release: .releaseVersion}
]
| group_by(.Release) 
|  map({ release: .[0].Release, count: map(.Key) | length})
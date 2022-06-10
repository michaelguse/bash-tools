[ 
.[] 
| select(.isActive == true) 
| select(.environment == $envType) 
| select(.Products[].isActive == true) 
| {Key: .key, Product: .Products[].key, tagType: .Tags[].type, tagValue: .Tags[].value} 
] 
| group_by(.tagValue) 
| map({ TypeName: .[0].tagValue, Count: map(.tagValue) | length })
| sort_by(.Count) | reverse
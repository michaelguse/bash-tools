[ 
.[] 
| select(.isActive == true) 
| select(.environment == $envType) 
| select(.Products[].isActive == true) 
| {Key: .key, Product: .Products[].key} 
] 
| group_by(.Product) 
| map({ ProductCloud: .[0].Product, Count: map(.Key) | length })
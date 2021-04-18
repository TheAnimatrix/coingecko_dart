
1. Select json[] as double? statements 
    <!-- (?:json\[)(.*)(?:\] as double\?) -->
replace with 
    <!-- StaticHelpers.checkDouble(json[$1],null) -->

2. Select json[] as double statements 
    <!-- (?:json\[)(.*)(?:\] as double\?) -->
replace with 
    <!-- StaticHelpers.checkDouble(json[$1],null) -->

3. 
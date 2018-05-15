# Associate TC to study group or aaq or both

## Initiative ##
 - name:string

## TechnicalCoachInitiative ##
 - technical_coach_id:integer
 - initiative_id:integer

Initiative has many Technical Coaches
Technical Coaches has many Initiatives

How to filter technical coaches for each index page
---------------------------------------------------
Grab all the technical coaches where iniative name is equal to SG or AAQ and iterate over that.
Users can have roles -> "Admin", "Technical Coach Lead", "Technical Coach"

User < - > Role -> Admin
                -> Technical Coach Lead => squad => technical coach
                -> Technical Coach => tc_initiatives => AAQ
                                                     => Study Groups
                                                     => One on One Support

### Role ###
Role -> user_id
Role -> technical_coach_lead_id
Role -> technical_coach_id

### example role usage ###
@user.role.admin? => returns true or false if user's role includes admin
@user.role.technical_coach_lead? => returns true or false if user's role includes technical_cloach_lead
@user.role.technical_coach => returns true or false if user's role includes technical_coach

### Admin ###


### example role usage ###
@user.role.admin.add_user => adds user to roles

(is allowed to see admin dashboard)

### Technical Coach Lead ###
Technical Coach Lead -> delegate squad

### example role usage ###
@user.role.technical_coach_lead.squad.name => returns squad name
@user.role.technical_coach_lead.squad.members => returns list of squad members

### Add User ###
/search-user
Find by github username => goes to /add-user
select all roles for user
[ ] Admin
[ ] Technical Coach Lead
[ ] Technical Coach

Admin allows for admin dashboard
Technical Coach Lead allows to add technical coaches by squad
Technical Coach allows for technical coach dashboard
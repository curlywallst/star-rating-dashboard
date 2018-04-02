Users can have roles -> "Admin", "Technical Coach Lead", "Technical Coach"

User < - > Role -> Admin
                -> Technical Coach Lead
                -> Technical Coach => tc_initiatives => AAQ
                                                     => Study Groups
                                                     => One on One Support

Role -> title: string
Role -> user_id
Role -> technical_coach_lead_id
Role -> technical_coach_id

### example role usage ###
@user.role.admin? => returns true or false if user's role includes admin
@user.role.technical_coach_lead? => returns true or false if user's role includes technical_cloach_lead
@user.role.technical_coach => returns true or false if user's role includes technical_coach

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
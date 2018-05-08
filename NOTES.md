### model Rating
- **stars:int** : shows how many stars they have
- **comment:text** : shows the comment attached to the rating
- **rating_type:string** : shows AAQ / Study Group / 1:1 Support
- **date:datetime** : time of when the Feedback was submitted (04/30/18)
- **landing_id:int** : unique id for answers

technical_coachs has many Ratings

Rating belongs_to technical_coach

How to keep each record unique?

How to filter it by month?
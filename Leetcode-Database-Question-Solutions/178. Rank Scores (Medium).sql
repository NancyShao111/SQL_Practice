Select Score, 
Dense_Rank() Over (order by Score desc) as "Rank"
from Scores;

# pay attention to Dense_Rank()Over().... function
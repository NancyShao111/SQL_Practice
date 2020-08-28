SELECT DISTINCT Num AS "ConsecutiveNums"
FROM 
(SELECT Num, LAG(Num,1) OVER (ORDER BY Id) AS "LAG1",
LAG(Num,2) OVER (ORDER BY Id) AS "LAG2" FROM Logs) AS A
WHERE Num = LAG1 AND Num = LAG2;

#differentiate consecutive numbers VS numbers
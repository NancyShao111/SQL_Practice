SELECT Firstname, LastName, City, State 
FROM Person
LEFT JOIN Address ON Person.PersonID = Address.PersonID
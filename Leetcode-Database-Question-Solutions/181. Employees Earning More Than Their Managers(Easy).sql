SELECT E1.Name AS 'Employee' 
FROM Employee AS E1, Employee AS E2
WHERE E1.ManagerId = E2.Id AND E1.Salary > E2.Salary;

#把原表建相同的两次 便于比较
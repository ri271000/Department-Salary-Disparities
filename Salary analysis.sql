select*from data_sql;

With DepartmentStats as(
Select Department,
stddev(Salary) as std_deviation,
AVG(Salary) as average
from data_sql
where Salary>=10000
group by Department
),

DepartmentOutliers as( select emp.department,
emp.salary,
dt.std_deviation,
dt.average,
(emp.salary-dt.average)/dt.std_deviation as zscore
from data_sql emp
join DepartmentStats dt on emp.Department=dt.Department
where emp.Salary>=10000)

Select dt.Department,
round(dt.std_deviation,2) as standard_deviation,
round(dt.average,2) as average,
round(dt.std_deviation/dt.average,2)*100 as coeff_of_variation,
SUM(Case when(deo.zscore>1.96 or deo.zscore <-1.96) then 1 else 0 end) as outlier_count
from DepartmentStats dt
left join DepartmentOutliers deo ON dt.Department=deo.Department
group by dt.department, dt.std_deviation, dt.average, dt.std_deviation/dt.average
order by outlier_count desc




##total revenue +fine fees
SELECT 
  ##CASE WHEN g.grade_order >= 12 THEN 'Dan' ELSE 'Kyu' END AS grade_type,
  ##COUNT(*) AS applications,
  SUM(a.paid) AS exam_fees,
  SUM(a.fine_fees) AS fine_fees,
  SUM(a.paid) + SUM(a.fine_fees) AS revenue_egp
FROM applications a
JOIN grades g ON a.grade_id = g.id
WHERE g.grade_order < 12
##GROUP BY grade_type;

##avg fees per exam
SELECT
  COUNT(*) AS apps,
  SUM(a.paid) AS total_exam_fees,
  ROUND(SUM(a.paid) / COUNT(*), 0) AS avg_fee_per_exam
FROM applications a
JOIN grades g ON a.grade_id = g.id
WHERE g.grade_order < 12;


##YOY GROWTH
SELECT 
  SUM(CASE WHEN YEAR(a.created_at) = 2024 THEN a.paid + a.fine_fees ELSE 0 END) AS revenue_2024,
  SUM(CASE WHEN YEAR(a.created_at) = 2025 THEN a.paid + a.fine_fees ELSE 0 END) AS revenue_2025,
  (SUM(CASE WHEN YEAR(a.created_at) = 2025 THEN a.paid + a.fine_fees ELSE 0 END) 
   - SUM(CASE WHEN YEAR(a.created_at) = 2024 THEN a.paid + a.fine_fees ELSE 0 END)) 
   / SUM(CASE WHEN YEAR(a.created_at) = 2024 THEN a.paid + a.fine_fees ELSE 0 END) * 100 AS yoy_percent
FROM applications a
JOIN grades g ON a.grade_id = g.id
WHERE g.grade_order < 12
  AND YEAR(a.created_at) IN (2024, 2025);


##dan data

SELECT 
  SUM(a.paid) AS dan_exam_fees_egp,
  SUM(a.fine_fees) AS dan_fines_egp,
  SUM(a.paid) + SUM(a.fine_fees) AS dan_total_egp,
  SUM(a.aikikai_fees) AS dan_aikikai_usd
FROM applications a
JOIN grades g ON a.grade_id = g.id
WHERE g.grade_order >= 12;



###revenue by year

SELECT YEAR(a.created_at) AS yr,
  SUM(a.paid) + SUM(a.fine_fees) AS total_revenue_egp
FROM applications a
JOIN grades g ON a.grade_id = g.id
WHERE g.grade_order < 12
GROUP BY yr
ORDER BY yr;



##exams held by year 

select year(e.created_at) as yr ,count( distinct e.id) as exams_held
from exams e 
join applications a 
on e.id =a.exam_id 
join grades g 
on a.grade_id =g.id 
where g.grade_order <12
group by yr 
order by exams_held desc 

## avg fee per exam each year
select year(a.created_at) as yearr,
  COUNT(*) AS apps,
  SUM(a.paid) AS total_exam_fees,
  ROUND(SUM(a.paid) / COUNT(*), 0) AS avg_fee_per_exam
FROM applications a
JOIN grades g ON a.grade_id = g.id
WHERE g.grade_order < 12
group by yearr
order by yearr


## revenue per belt 

SELECT g.grade_order, g.name AS grade_name,
  COUNT(*) AS applications,
  SUM(a.paid) AS exam_fees,
  SUM(a.fine_fees) AS fines,
  SUM(a.paid) + SUM(a.fine_fees) AS revenue_egp
FROM applications a
JOIN grades g ON a.grade_id = g.id
WHERE g.grade_order < 12
GROUP BY g.grade_order, g.name
ORDER BY g.grade_order;


## revenue per club
SELECT c.name AS club, 
  COUNT(a.id) AS applications,
  SUM(a.paid) + SUM(a.fine_fees) AS revenue_egp
FROM applications a
JOIN users u ON a.user_id = u.id
JOIN clubs c ON u.club_id = c.id
JOIN grades g ON a.grade_id = g.id
WHERE g.grade_order < 12
GROUP BY c.name
ORDER BY revenue_egp DESC
LIMIT 10;


##revenue per gov 

SELECT gv.name AS governorate,
  COUNT(a.id) AS applications,
  SUM(a.paid) + SUM(a.fine_fees) AS revenue_egp
FROM applications a
JOIN users u ON a.user_id = u.id
JOIN clubs c ON u.club_id = c.id
JOIN govs gv ON c.gov_id = gv.id
JOIN grades g ON a.grade_id = g.id
WHERE g.grade_order < 12
GROUP BY gv.name
ORDER BY revenue_egp DESC;



SELECT COUNT(a.id) AS applications,
  SUM(a.paid) + SUM(a.fine_fees) AS revenue_egp_unassigned
FROM applications a
JOIN users u ON a.user_id = u.id
JOIN clubs c ON u.club_id = c.id
JOIN grades g ON a.grade_id = g.id
WHERE g.grade_order < 12 AND c.gov_id IS NULL;


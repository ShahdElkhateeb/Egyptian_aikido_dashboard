## total applications 
SELECT COUNT(id) AS total_applications
FROM applications;

## pass rate 
SELECT 
  COUNT(CASE WHEN status = 'success' THEN 1 END) AS pass_count,
  ROUND(
    COUNT(CASE WHEN status = 'success' THEN 1 END) * 100.0 
    / COUNT(CASE WHEN status IN ('success', 'fail') THEN 1 END), 2
  ) AS pass_rate_pct
FROM applications;
 ## fail rate 
SELECT 
  COUNT(CASE WHEN status = 'fail' THEN 1 END) AS fail_count,
  ROUND(
    COUNT(CASE WHEN status = 'fail' THEN 1 END) * 100.0 
    / COUNT(CASE WHEN status IN ('success', 'fail') THEN 1 END), 2
  ) AS fail_rate_pct
  from applications


## absence rate
SELECT 
  COUNT(CASE WHEN status = 'absence' THEN 1 END) AS absence_count,
  ROUND(
    COUNT(CASE WHEN status = 'absence' THEN 1 END) * 100.0 
    / COUNT(CASE WHEN status IN ('success', 'fail', 'absence') THEN 1 END), 2
  ) AS absence_rate_pct
FROM applications;



###avg students per trainer
SELECT
  COUNT(DISTINCT CASE WHEN r.name = 'student' THEN mhr.model_id END) AS total_students,
  COUNT(DISTINCT CASE WHEN r.name = 'trainer' THEN mhr.model_id END) AS total_trainers,
  ROUND(
    COUNT(DISTINCT CASE WHEN r.name = 'student' THEN mhr.model_id END) /
    COUNT(DISTINCT CASE WHEN r.name = 'trainer' THEN mhr.model_id END)
  ,0) AS avg_students_per_trainer
FROM aikido_data.model_has_roles mhr
JOIN aikido_data.roles r ON r.id = mhr.role_id
WHERE r.name IN ('student', 'trainer');

## ghost members who started
SELECT u.name_en , u.created_at ,u.grade_id ,g.name
FROM aikido_data.users u
JOIN aikido_data.grades g ON g.id = u.grade_id
WHERE u.id IN (
  SELECT mhr.model_id 
  FROM aikido_data.model_has_roles mhr
  JOIN aikido_data.roles r ON r.id = mhr.role_id
  WHERE r.name = 'student'
)
AND u.id NOT IN (
  SELECT DISTINCT user_id 
  FROM aikido_data.applications
 )
AND g.type != 'dan';


##ghost members with white belt pct
SELECT 
  COUNT(*) AS ghost_members,
  ROUND(SUM(CASE WHEN g.grade_order = 1 THEN 1 ELSE 0 END) * 100.0 / COUNT(*), 0) AS white_belt_pct
FROM aikido_data.users u
JOIN aikido_data.grades g ON g.id = u.grade_id
WHERE u.id IN (
  SELECT mhr.model_id 
  FROM aikido_data.model_has_roles mhr
  JOIN aikido_data.roles r ON r.id = mhr.role_id
  WHERE r.name = 'student'
)
AND u.id NOT IN (
  SELECT DISTINCT user_id 
  FROM aikido_data.applications
)
AND g.type != 'dan';


##members per grade
SELECT g.grade_order, g.name AS belt, COUNT(*) AS members
FROM aikido_data.users u
JOIN aikido_data.grades g ON g.id = u.grade_id
JOIN aikido_data.model_has_roles mhr ON mhr.model_id = u.id
JOIN aikido_data.roles r ON r.id = mhr.role_id
WHERE r.name = 'student'
AND g.type = 'kyu'
GROUP BY g.grade_order, g.name
ORDER BY g.grade_order;

## pass rate by grade 

SELECT 
  g.name AS belt,
  g.grade_order,
  ROUND(
    COUNT(CASE WHEN a.status = 'success' THEN 1 END) * 100.0 /
    COUNT(CASE WHEN a.status IN ('success','fail') THEN 1 END), 2
  ) AS pass_rate_pct
FROM aikido_data.applications a
JOIN aikido_data.grades g ON g.id = a.grade_id
WHERE g.type = 'kyu'
GROUP BY g.name, g.grade_order
ORDER BY pass_rate_pct desc;



## fail and absence per belt 

SELECT 
  g.grade_order,
  g.name AS belt,
  COUNT(CASE WHEN a.status = 'fail' THEN 1 END) AS fail_count,
  COUNT(CASE WHEN a.status = 'absence' THEN 1 END) AS absence_count
FROM aikido_data.applications a
JOIN aikido_data.grades g ON g.id = a.grade_id
WHERE g.type = 'kyu'
GROUP BY g.grade_order, g.name
ORDER BY fail_count desc; 


SELECT 
  t.name AS trainer_name,
  t.name_en AS trainer_name_en,
  COUNT(u.id) AS student_count
FROM aikido_data.users t
JOIN aikido_data.model_has_roles mhr ON mhr.model_id = t.id
JOIN aikido_data.roles r ON r.id = mhr.role_id
JOIN aikido_data.users u ON u.trainer_id = t.id
WHERE r.name = 'trainer'
GROUP BY t.id, t.name, t.name_en
ORDER BY student_count DESC;


##exams held by year and month
SELECT
  YEAR(date) AS year,
  MONTH(date) as month,
  COUNT(*) AS exams_held
FROM exams
WHERE date IS NOT NULL
GROUP BY YEAR(date), MONTH(date)
ORDER BY year;

 
## members per gov
SELECT 
    g.name_en AS governorate_name,
    COUNT(u.id) AS members_per_gov
FROM 
    users u
JOIN 
    clubs c ON u.club_id = c.id
JOIN 
    govs g ON c.gov_id = g.id  -- Adjust this join based on your actual schema
GROUP BY 
    g.name_en
ORDER BY 
    members_per_gov DESC;

## clubs per govs
SELECT 
    g.name_en AS governorate_name, 
    COUNT(c.id) AS number_of_clubs
FROM govs g 
INNER JOIN clubs c ON g.id = c.gov_id
GROUP BY g.name_en
ORDER BY number_of_clubs DESC;
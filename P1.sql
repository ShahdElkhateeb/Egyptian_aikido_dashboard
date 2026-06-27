#Total members
WITH user_stats AS (
    SELECT
        COUNT(*)                 AS total_members,
        SUM(status = 'active')   AS active_members,
        SUM(status = 'inactive') AS inactive_members
    FROM users
),
role_stats AS (
    SELECT
        COUNT(DISTINCT CASE WHEN r.name = 'super-admin' THEN mhr.model_id END) AS total_admins,
        COUNT(DISTINCT CASE WHEN r.name = 'trainer'     THEN mhr.model_id END) AS total_trainers,
        COUNT(DISTINCT CASE WHEN r.name = 'student'     THEN mhr.model_id END) AS total_students
    FROM model_has_roles mhr
    JOIN roles r ON r.id = mhr.role_id
    WHERE mhr.model_type = 'App\\Models\\User'
)
SELECT * FROM user_stats, role_stats;


-- Members: male vs female
SELECT gender, COUNT(*) AS total
FROM users
GROUP BY gender;

-- Trainers: male vs female
SELECT u.gender, COUNT(DISTINCT mhr.model_id) AS total
FROM model_has_roles mhr
JOIN roles r ON r.id = mhr.role_id
JOIN users u ON u.id = mhr.model_id
WHERE r.name = 'trainer'
GROUP BY u.gender;


select u.name_en,mhr.model_id
from users as u
join model_has_roles as mhr
on u.id=mhr.model_id
join roles AS r 
on r.id=mhr.role_id
where u.gender='Female' and 
r.id=2

## Nationality breakdown
select nationality,Count(*) as total_nationalities
from users
group by nationality 
order by total_nationalities desc


## Age group 
SELECT
    CASE
        WHEN TIMESTAMPDIFF(YEAR, dob, CURDATE()) BETWEEN 4  AND 7  THEN '4-7'
        WHEN TIMESTAMPDIFF(YEAR, dob, CURDATE()) BETWEEN 8  AND 12 THEN '8-12'
        WHEN TIMESTAMPDIFF(YEAR, dob, CURDATE()) BETWEEN 13 AND 17 THEN '13-17'
        WHEN TIMESTAMPDIFF(YEAR, dob, CURDATE()) BETWEEN 18 AND 25 THEN '18-25'
        WHEN TIMESTAMPDIFF(YEAR, dob, CURDATE()) BETWEEN 26 AND 35 THEN '26-35'
        WHEN TIMESTAMPDIFF(YEAR, dob, CURDATE()) BETWEEN 36 AND 50 THEN '36-50'
        ELSE '50+'
    END      AS age_group,
    COUNT(*) AS total
FROM users
GROUP BY age_group
##ORDER BY MIN(TIMESTAMPDIFF(YEAR, dob, CURDATE()));
order by total asc


select * from users 
order by created_at desc



-- ============================================
-- Q4: Registrations per Year by Gender
-- ============================================

SELECT
    YEAR(created_at) AS registration_year,
    gender,
    COUNT(*) AS new_members
FROM users
WHERE created_at IS NOT NULL
GROUP BY YEAR(created_at), gender
ORDER BY registration_year, gender;









SELECT
	student_track_id,
    student_id,
    track_name,
    date_enrolled,
    track_completed,
    days_for_completion,
    CASE
		WHEN days_for_completion IS NULL THEN 'NULL'
        WHEN days_for_completion = 0 THEN 'Same day'
        WHEN days_for_completion BETWEEN 1 AND 7 THEN '1 to 7 days'
        WHEN days_for_completion BETWEEN 8 AND 30 THEN '8 to 30 days'
        WHEN days_for_completion BETWEEN 31 AND 60 THEN '31 to 60 days'
        WHEN days_for_completion BETWEEN 61 AND 90 THEN '61 to 90 days'
        WHEN days_for_completion BETWEEN 91 AND 365 THEN '91 to 365 days'
        ELSE '366+ days'
	END AS completion_bucket
FROM
(
	SELECT
	ROW_NUMBER() OVER (ORDER BY student_id, track_name) AS student_track_id,
    e.student_id,
	i.track_name,
	e.date_enrolled,
    IF(e.date_completed IS NULL, 0, 1) AS track_completed,
	DATEDIFF(e.date_completed, e.date_enrolled) AS days_for_completion
	FROM
	career_track_student_enrollments e
JOIN
	career_track_info i ON e.track_id = i.track_id
) a;

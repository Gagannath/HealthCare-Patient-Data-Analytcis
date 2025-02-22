SELECT patient_nbr, 
       COUNT(DISTINCT diag_1) AS primary_count,
       COUNT(DISTINCT diag_2) AS secondary_count,
       COUNT(DISTINCT diag_3) AS additional_secondary_count
FROM patient_data
GROUP BY patient_nbr
HAVING primary_count > 1 OR secondary_count > 1 OR additional_secondary_count > 1;


SELECT 
    diag_1, 
    COUNT(*) AS count,
    RANK() OVER (ORDER BY COUNT(*) DESC) AS rank_diag
FROM patient_data
GROUP BY diag_1;


DELIMITER //
CREATE PROCEDURE identify_high_risk_patients()
BEGIN
    SELECT patient_nbr, COUNT(DISTINCT diag_1) AS primary_count, 
           COUNT(DISTINCT diag_2) AS secondary_count, 
           COUNT(DISTINCT metformin) AS medication_count, 
           AVG(time_in_hospital) AS avg_hospital_stay
    FROM patient_data
    GROUP BY patient_nbr
    HAVING primary_count > 1 AND secondary_count > 1 AND medication_count > 2 
    AND avg_hospital_stay > 5;
END;
//
DELIMITER ;
call identify_high_risk_patients();


SELECT gender, COUNT(*) AS patient_count
FROM patient_data
GROUP BY gender;





SELECT readmitted, AVG(number_diagnoses) AS avg_diagnoses
FROM patient_data
GROUP BY readmitted;



SELECT readmitted, 
       AVG(number_diagnoses) AS avg_diagnoses_per_patient
FROM patient_data
GROUP BY readmitted;


SELECT patient_nbr, 
       COUNT(DISTINCT CASE WHEN metformin = 'Steady' THEN 'metformin' END) + 
       COUNT(DISTINCT CASE WHEN insulin = 'Steady' THEN 'insulin' END) + 
       COUNT(DISTINCT CASE WHEN glimepiride = 'Steady' THEN 'glimepiride' END) AS medication_count
FROM patient_data
GROUP BY patient_nbr;

SELECT 
    (COUNT(CASE WHEN insulin = 'Steady' THEN 1 END) * 100.0) / COUNT(*) 
    AS insulin_usage_percentage
FROM patient_data;


SELECT max_glu_serum, 
       COUNT(CASE WHEN metformin = 'Steady' THEN 1 END) AS metformin_usage,
       COUNT(CASE WHEN insulin = 'Steady' THEN 1 END) AS insulin_usage
FROM patient_data
GROUP BY max_glu_serum
ORDER BY max_glu_serum DESC;

SELECT medical_specialty, 
       AVG(num_procedures) AS avg_procedures,
       count(*) as count
FROM patient_data
GROUP BY medical_specialty
having count > 50 and avg_procedures > 2.5
ORDER BY avg_procedures DESC;


SELECT race, 
       AVG(num_lab_procedures) AS avg_lab_procedures,
       COUNT(*) AS count
FROM patient_data
GROUP BY race
HAVING count > 50 AND avg_lab_procedures > 5
ORDER BY avg_lab_procedures DESC;







SELECT diag_1, diag_2, diag_3, COUNT(*) AS count
FROM patient_data
GROUP BY diag_1, diag_2, diag_3
ORDER BY count DESC
LIMIT 1;

SELECT 
    AVG(number_diagnoses) AS avg_diagnoses, 
    CASE 
        WHEN number_inpatient > 0 THEN 'Inpatient'
        WHEN number_emergency > 0 THEN 'Emergency'
        ELSE 'Other'
    END AS patient_type
FROM patient_data
GROUP BY patient_type;

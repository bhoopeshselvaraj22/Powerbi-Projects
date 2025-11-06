Use project_medical_data_history;

-- 1. Show first name, last name, and gender of patients who's gender is 'M'
select first_name, last_name, gender from patients where gender = "M";

-- 2. Show first name and last name of patients who does not have allergies.
select first_name, last_name from patients where allergies is null;

-- 3. Show first name of patients that start with the letter 'C';
select first_name from patients where first_name like 'C%';

-- 4. Show first name and last name of patients that weight within the range of 100 to 120 (inclusive)
select first_name, last_name from patients where weight between 100 and 120;

-- 5. Update the patients table for the allergies column. If the patient allergies is null then replace it with "NKA"
update patients set allergies = "NKA" where allergies is null;

select first_name, last_name,coalesce(allergies, 'NKA') as allergies from patients;

-- 6. Show first name and last name concatenated into one column to show their full name.
select *,concat(first_name,' ',last_name) as full_name from patients;

-- 7. Show first name, last name, and the full province name of each patient.
select a.first_name, a.last_name, b.province_name, b.province_id from patients a join province_names b on a.province_id = b.province_id;

-- 8. Show how many patients have a birth_date with 2010 as the birth year.
select COUNT(*) as total_patients_2010 from patients where year(birth_date) = 2010;

-- 9. Show the first_name, last_name, and height of the patient with the greatest height.
select first_name, last_name, height from patients order by height desc;

-- 10. Show all columns for patients who have one of the following patient_ids: 1,45,534,879,1000
select * from patients where patient_id in (1,45,534,879,1000);

-- 11. Show the total number of admissions
select count(*) from admissions;

-- 12. Show all the columns from admissions where the patient was admitted and discharged on the same day.
select * from admissions where admission_date = discharge_date;

-- 13. Show the total number of admissions for patient_id 579.
select count(patient_id) from admissions where patient_id = 579;

-- 14. Based on the cities that our patients live in, show unique cities that are in province_id 'NS'?
select distinct city from patients where province_id = "NS";

-- 15. Write a query to find the first_name, last name and birth date of patients who have height more than 160 and weight more than 70
select first_name, last_name , birth_date from patients where height > 160 and weight > 70;

-- 16. Show unique birth years from patients and order them by ascending.
select distinct year(birth_date) as birth_year from patients order by birth_year;

-- 17. Show unique first names from the patients table which only occurs once in the list.
-- For example, if two or more people are named 'John' in the first_name column then don't include their name in the output list. If only 1 person is named 'Leo' then include them in the output. Tip: HAVING clause was added to SQL because the WHERE keyword cannot be used with aggregate functions.
select first_name from patients group by first_name having count(first_name) = 1;

-- 18. Show patient_id and first_name from patients where their first_name start and ends with 's' and is at least 6 characters long.
select patient_id, first_name from patients where first_name like 'S%S' and length(first_name) >= 6;

-- 19. Show patient_id, first_name, last_name from patients whos diagnosis is 'Dementia'. Primary diagnosis is stored in the admissions table.
select a.patient_id, a.first_name, a.last_name from patients a join admissions b on a.patient_id = b.patient_id where b.diagnosis = 'dementia';

-- 20. Display every patient's first_name. Order the list by the length of each name and then by alphbetically.
select first_name from patients order by length(first_name),first_name;

-- 21. Show the total amount of male patients and the total amount of female patients in the patients table. Display the two results in the same row.
select sum(case when gender = 'M' then 1 else 0 end) as total_male, sum(case when gender = 'F' then 1 else 0 end) as total_female from patients;

-- 22. Show patient_id, diagnosis from admissions. Find patients admitted multiple times for the same diagnosis.
select patient_id, diagnosis, count(*) as admission_count from admissions group by patient_id,diagnosis having count(*) > 1;

-- 23. Show the city and the total number of patients in the city. Order from most to least patients and then by city name ascending.
select city, count(patient_id) as Total_patients from patients group by city order by Total_patients desc, city asc;

-- 24. Show first name, last name and role of every person that is either patient or doctor. The roles are either "Patient" or "Doctor"
select first_name, last_name, 'patients' as role from patients union select first_name, last_name, 'Doctors' as role from doctors;

-- 25. Show all allergies ordered by popularity. Remove NULL values from query.
select allergies, count(*) as total_patients from patients where allergies is not null group by allergies order by total_patients desc;

-- 26. Show all patient's first_name, last_name, and birth_date who were born in the 1970s decade. Sort the list starting from the earliest birth_date.
select first_name, last_name, birth_date from patients where year(birth_date) between 1970 and 1979 order by birth_date asc;

-- 27. We want to display each patient's full name in a single column. Their last_name in all upper letters must appear first, then first_name in all lower case letters. Separate the last_name and first_name with a comma. Order the list by the first_name in decending order    EX: SMITH,jane
select concat(upper(last_name),',',lower(first_name)) as Full_Name from patients order by first_name desc;

-- 28. Show the province_id(s), sum of height; where the total sum of its patient's height is greater than or equal to 7,000.
select province_id, sum(height) as Total_Height from patients group by province_id having Total_Height >= 7000;

-- 29. Show the difference between the largest weight and smallest weight for patients with the last name 'Maroni'
select max(weight) - min(weight) as weight_difference from patients where last_name = 'Maroni';

-- 30. Show all of the days of the month (1-31) and how many admission_dates occurred on that day. Sort by the day with most admissions to least admissions.
select day(admission_date) as day_of_month, count(*) as total_admissions from admissions group by day(admission_date) order by total_admissions desc;

-- 31. Show all of the patients grouped into weight groups. Show the total amount of patients in each weight group. Order the list by the weight group decending. e.g. if they weight 100 to 109 they are placed in the 100 weight group, 110-119 = 110 weight group, etc.
select (weight / 10) * 10 as weight_group, COUNT(*) as total_patients from patients group by weight_group order by weight_group desc;

-- 32. Show patient_id, weight, height, is Obese from the patients table. Display isObese as a boolean 0 or 1. Obese is defined as weight(kg)/(height(m). Weight is in units kg. Height is in units cm
select patient_id, weight, height, case when (weight / POWER(height / 100.0, 2) >= 30) then 1 else 0 end as Obese from patients;

-- 33. Show patient_id, first_name, last_name, and attending doctor's specialty. Show only the patients who has a diagnosis as 'Epilepsy' and the doctor's first name is 'Lisa'. Check patients, admissions, and doctors tables for required information.
select a.patient_id, a.first_name, a.last_name,c.specialty from patients a join admissions b on a.patient_id = b.patient_id join doctors c on b.attending_doctor_id = c.doctor_id where b.diagnosis = 'Epilepsy' and c.first_name = 'Lisa';


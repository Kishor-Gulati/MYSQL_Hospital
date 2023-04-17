# Project - Hospital (insights = ##)

CREATE DATABASE Project_Practise;

USE Project_Practise;

SHOW TABLES;

# 1. Write a SQL query to identify the physicians who are the department heads.
#    Return Department name as “Department” and Physician name as “Physician”.

SELECT * FROM physician;
SELECT * FROM department;

# Using inner join:

Select d.name as "DEPARTMENT", p.name as "PHYSICIAN"
FROM department as d
inner join
physician as p
ON d.head = p.employeeid;

# USING SUB-QUERY

SELECT name from physician where employeeid IN
(SELECT head from department);

# USING SIMPLE WHERE

Select d.name as "DEPARTMENT", p.name as "PHYSICIAN"
FROM department as d, physician as p
WHERE d.head = p.employeeid;

##   There are 3 department heads in the data

# 2. Write a SQL query to locate the floor and block where room number 212 is located. 
#    Return block floor as "Floor" and block code as "Block".

SELECT blockfloor as 'Floor', blockcode as 'Block'
FROM room
WHERE roomnumber = 212;

##     Room 212 is located at the second floor in block number 2.

# 3. Write a SQL query to count the number of unavailable rooms. Return count as "Number of unavailable rooms".

SELECT COUNT(*) as "Number of unavailable rooms"
FROM room
WHERE unavailable = 't';

##    There are 7 unavailable rooms at the vicinity.

# 4. Write a SQL query to identify the physician and the department with which he or she is affiliated. 
#    Return Physician name as "Physician", and department name as "Department".

# Using 3 inner joins:

SELECT p.NAME AS "Physician", d.NAME AS "Department"
FROM physician p 
inner join affiliated_with a
ON p.employeeid = a.physician
inner join department d
ON d.departmentid = a.department
WHERE a.primaryaffiliation = 't';

# Using Simple Where:

SELECT p.NAME AS "Physician", d.NAME AS "Department"
FROM physician p, affiliated_with a, department d
WHERE p.employeeid = a.physician AND d.departmentid = a.department AND a.primaryaffiliation = 't';

##    Many physicians are affiliated with same departments (M:1)

# 5. Write a SQL query to find those physicians who have received special training.
#    Return Physician name as “Physician”, treatment procedure name as "Treatment".

# Using Simple Where:

SELECT p.name as “Physician”, c.name as "Treatment"
FROM physician p, `procedure` c, trained_in t
WHERE p.employeeid = t.physician AND t.treatment = c.code;

# Using INNER JOIN:

SELECT p.name as “Physician”, c.name as "Treatment"
FROM trained_in t
INNER JOIN `procedure` c ON t.treatment = c.code
INNER JOIN physician p ON p.employeeid = t.physician;

##      There are some physicians who received multiple special trainings.

# 6. Write a SQL query to find those physicians who are yet to be affiliated.
#    Return Physician name as "Physician", Position, and department as "Department".

Select p.name "Physician", p.Position "Position", d.name "Department"
FROM physician p
INNER JOIN affiliated_with a ON a.physician=p.employeeid
INNER JOIN department d ON a.department=d.departmentid
WHERE primaryaffiliation='f';

##     THere are 2 physicians with the same position and department, that are yet to be affiliated.

# 7. Write a SQL query to identify physicians who are not specialists. 
#    Return Physician name as "Physician", position as "Designation".

SELECT p.name "Physician", p.position "Designation"
FROM physician p
LEFT JOIN trained_in t
ON p.employeeid = t.physician
WHERE t.treatment IS NULL
ORDER BY p.employeeid;

##  There are 6 non-specialists physicians in the data.

# 8. Write a SQL query to identify the patients and the number of physicians with whom they have scheduled appointments. 
#    Return Patient name as "Patient", number of Physicians as "Appointment for No. of Physicians".

SELECT p.name "Patient", count(a.physician) "Appointment for No. of Physicians"
FROM appointment a
INNER JOIN patient p
ON p.ssn = a.patient
GROUP BY p.name
HAVING count(a.physician)>0;

##      There are 4 patients having appointments scheduled with at least 1 physician, in the data.

# 9. write a SQL query to count the number of unique patients who have been scheduled for examination room 'C'.
#    Return unique patients as "No. of patients got appointment for room C".

SELECT COUNT(DISTINCT patient) "No. of patients got appointment for room C"
FROM appointment
WHERE examinationroom = 'C';

##    There are 3 unique patients who are scheduled for room C.

# 10. write a SQL query to identify the nurses and the room in which they will assist the physicians. 
# Return Nurse Name as "Name of the Nurse" and examination room as "Room No.".

SELECT n.name "Name of the Nurse", a.examinationroom "Room No."
FROM nurse n
INNER JOIN appointment a
ON n.employeeid = a.prepnurse;

##   There are nurses who assist physicians in multiple rooms.

# 11. Write a SQL query to locate the patients treated by physicians and their medications. 
#     Return Patient name as "Patient", Physician name as "Physician", Medication name as "Medication".

SELECT pa.name "Patient", ph.name "Physician", m.name "Medication"
FROM patient pa
JOIN prescribes pr ON pa.ssn = pr.patient
JOIN physician ph ON pr.physician = ph.employeeid
JOIN medication m on pr.medication = m.code;

##     There are currently 3 patients under treatment by 2 physicians with medications on Procrastin-X and Thesisin.

# 12. Write a SQL query to count the number of available rooms in each block. Sort the result-set on ID of the block. 
#     Return ID of the block as "Block", count number of available rooms as "Number of available rooms".

SELECT blockcode "Block", COUNT(*) "Number of available rooms"
FROM room
WHERE unavailable = 'f'
GROUP BY Block
ORDER BY Block;

##           There are 3 blocks (1,2,3) available with 9, 10 and 10 rooms respectively.

# 13. Write a SQL query to count the number of available rooms for each floor in each block. Sort the result-set on floor ID, ID of the block. 
#    Return the floor ID as "Floor", ID of the block as "Block", and number of available rooms as "Number of available rooms".

SELECT blockfloor "Floor", blockcode "Block", count(*) "Number of available rooms"
FROM room
WHERE unavailable = 'f'
GROUP BY Floor, blockcode
ORDER BY Floor, blockcode;

##   Floors 1-4, Blocks 1-3 have 2,3 rooms available

# 14. Write a SQL query to count the number of rooms that are unavailable in each block and on each floor. Sort the result-set on block floor, block code. 
#     Return the floor ID as "Floor", block ID as "Block", and number of unavailable as “Number of unavailable rooms"

SELECT blockfloor "Floor", blockcode "Block", COUNT(*) "Number of unavailable rooms"
FROM room
WHERE unavailable = 't'
GROUP BY Floor, blockcode
ORDER BY Floor, blockcode;

##      Floor 1-4, blocks 1-3 have maximum 1 room unaivalable.

# 15. Write a SQL query to find the name of the patients, their block, floor, and room number where they admitted.

SELECT pa.name "Name of the patient", s.room "Room", r.blockfloor "Floor", r.blockcode "Block"
FROM stay s
JOIN patient pa ON pa.ssn = s.patient
JOIN room r ON r.roomnumber = s.room;

##           There are 3 patients on the 1st floor in blocks 2 and 3

# 16. Write a SQL query to find all physicians who have performed a medical procedure but are not certified to do so.
#    Return Physician name as "Physician".

SELECT ph.name "Physician"
FROM physician ph
WHERE ph.employeeid in
(SELECT u.physician FROM undergoes u
LEFT JOIN trained_in t on
u.physician = t.physician AND
u.procedure = t.treatment
WHERE t.treatment IS NULL);

##     There is one physician named Christopher Turk who has performed a medical procedure but was not certified.

# 17. Write a SQL query to determine which patients have been prescribed medication by their primary care physician.
#     Return Patient name as "Patient", and Physician Name as "Physician".

SELECT pa.name Patient, ph.name Physician
FROM Patient pa
JOIN prescribes pr ON pa.ssn = pr.patient
JOIN physician ph ON pa.pcp = ph.employeeid
WHERE ph.employeeid = pa.pcp AND pa.pcp = pr.physician;

##      There is 1 patient who is being prescribed medication by their primary care physician.

# 18. Write a SQL query to find those patients who have undergone a procedure costing more than $5,000, 
#     as well as the name of the physician who has provided primary care, should be identified. 
#     Return name of the patient as "Patient", name of the physician as "Primary Physician", 
#     and cost for the procedure as "Procedure Cost".

SELECT pa.name "Patient", ph.name "Primary Physician", pr.cost "Procedure Cost"
FROM patient pa
JOIN undergoes u ON pa.ssn = u.patient
JOIN physician ph ON ph.employeeid = pa.pcp
JOIN `procedure` pr ON u.procedure = pr.code
WHERE pr.cost>5000;

##       There are 2 patients who have undergone a procedure costing more than $5,000

# 19. Write a SQL query to identify those patients whose primary care is provided by a physician who is not the head of any 
#     department. Return Patient name as "Patient", Physician Name as "Primary care Physician".

SELECT pa.name Patient, ph.name "Primary care Physician"
FROM Patient pa
JOIN Physician ph ON pa.pcp = ph.employeeid
WHERE pa.pcp NOT IN
(SELECT head FROM department);

##         There are 4 patients whose primary care is provided by a physician who is not the head of any department.
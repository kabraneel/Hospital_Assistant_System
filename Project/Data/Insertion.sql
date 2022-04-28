-- MANUAL INSERTION
INSERT INTO Department(dept_name, budget, building) values ('Cardiology', 500000, 'Manogata'), ('Eyes', 700000, 'Samgata'), ('Skin', 8000000, 'Bhaegshri'),
															('Nuerology', 7000000, 'Manogata'), ('ENT', 8000000, 'Samgata'), ('Orthopedics', 100000000, 'Manogata');

SELECT * FROM Department;

INSERT INTO Doctor(name, age, Salary, YearsOfExp) values ('Alex', 50, 100, 5), ('Bob', 55, 200, 5), ('Charlie', 43, 500, 5),
														('Donna', 57, 100, 7), ('Ester', 43, 100, 10), ('Farlig', 34, 100, 7),
														('Garret', 50, 100, 5), ('Harry', 50, 100, 5), ('Icy', 50, 100, 5);

insert into Doctor(name, age, Salary, YearsOfExp) values ('Pullen', 45, 100000, 20), ('Hurtt', 67, 150000, 25), ('Putin', 23, 50000, 0);
insert into Doctor(name, age, Salary, YearsOfExp) values ('Melani', 43, 100000, 18), ('Sneha', 53, 150000, 20), ('Priya', 21, 50000, 0);
insert into Doctor(name, age, Salary, YearsOfExp) values ('Eric', 42, 100000, 20), ('Henry', 69, 150000, 30), ('Ornis', 33, 100000, 10);
insert into Doctor(name, age, Salary, YearsOfExp) values ('Morris', 47, 150000, 25), ('Denis', 67, 150000, 25), ('Iris', 23, 50000, 0);
insert into Doctor(name, age, Salary, YearsOfExp) values ('Tina', 50, 150000, 28), ('Hari', 66, 150000, 25), ('Priya', 23, 50000, 0);
insert into Doctor(name, age, Salary, YearsOfExp) values ('Chris', 45, 100000, 20), ('Scarlett', 67, 150000, 25), ('Oscar', 23, 50000, 0);
insert into Doctor(name, age, Salary, YearsOfExp) values ('Steve', 45, 100000, 20), ('Michael', 67, 150000, 25), ('Meredith', 23, 50000, 0);

SELECT * FROM Doctor;


INSERT INTO Nurse(Name, Salary, Age, YearsOfExp, sex) values ('Kevin', 23000, 23, 1, 'Male'), ('Angela', 20000, 34, 3, 'Female'), ('Phyllis', 30000, 50, 10, 'Female'), ('Dwight', 45000, 47, 10, 'Male');
INSERT INTO Nurse(Name, Salary, Age, YearsOfExp, sex) values ('Kelly', 23000, 23, 1, 'Female'), ('Angola', 20000, 34, 3, 'Female'), ('Parker', 30000, 50, 10, 'Male'), ('Salim', 45000, 47, 10, 'Male');
INSERT INTO Nurse(Name, Salary, Age, YearsOfExp, sex) values ('Keerthi', 23000, 23, 1, 'Female'), ('Aditya', 20000, 34, 3, 'Male'), ('Pratham', 30000, 50, 10, 'Male'), ('Shakeela', 45000, 47, 10, 'Female');
INSERT INTO Nurse(Name, Salary, Age, YearsOfExp, sex) values ('Rittika', 23000, 23, 1, 'Female'), ('Teja', 20000, 34, 3, 'Male'), ('Arjun', 30000, 50, 10, 'Male'), ('Usha', 45000, 47, 10, 'Female');
INSERT INTO Nurse(Name, Salary, Age, YearsOfExp, sex) values ('Shreya', 23000, 23, 1, 'Female'), ('Titas', 20000, 34, 3, 'Female'), ('Malik', 30000, 50, 10, 'Male'), ('Salim', 45000, 47, 10, 'Male');
INSERT INTO Nurse(Name, Salary, Age, YearsOfExp, sex) values ('Katha', 23000, 23, 1, 'Female'), ('Hrithika', 20000, 34, 3, 'Female'), ('Janani', 30000, 50, 10, 'Male'), ('Mahesh', 45000, 47, 10, 'Male');
INSERT INTO Nurse(Name, Salary, Age, YearsOfExp, sex) values ('Fawad', 23000, 23, 1, 'Male'), ('Parvati', 20000, 34, 3, 'Female'), ('Pratham', 30000, 50, 10, 'Male'), ('Aditya', 45000, 47, 10, 'Male');

SELECT * FROM Nurse;


INSERT INTO BelongsTo(dr_id, dept_id) values (1 , 2),
											(2 , 3),
											(3 , 4),
											(4 , 5),
											(5 , 6),
											(6 , 1),
											(7 , 2),
											(8 , 3),
											(9 , 4),
											(10 , 5),
											(11 , 6),
											(12 , 1),
											(13 , 2),
											(14 , 3),
											(15 , 4),
											(16 , 5),
											(17 , 6),
											(18 , 1),
											(19 , 2),
											(20 , 3),
											(21 , 4),
											(22 , 5),
											(23 , 6),
											(24 , 1),
											(25 , 2),
											(26 , 3),
											(27 , 4),
											(28 , 5),
											(29 , 6),
											(30 , 1);

INSERT INTO Test(Test_name,cost) values ('Blood Test', 50), ('HIV test', 5000), ('Echo', 1000), ('ECG', 1000), ('Urine', 2000);
SELECT * FROM Test;

INSERT INTO Operations(Op_name, Cost, equipments) VALUES ('Heart Bypass', 200000, '{"Knife", "Gloves","Scalpel","Bandage","Scissors"}'), ('Lasik Surgery', 150000, '{"Black Glasses", "Lasers"}'), ('Skin Grafting', 150000, '{"Knife", "Gloves","Scalpel","Bandage","Scissors"}'), ('Crainiotomy', 600000, '{"hammer","Knife", "Gloves","Scalpel","Bandage","Scissors"}'), ('Sinus Surgery', 300000, '{"hammer","Knife", "Gloves","Scalpel","Bandage","Scissors"}'), ('Knee Replacement Surgery', 100000, '{"hammer","Knife", "Gloves","Scalpel","Bandage","Scissors"}');
SELECT * FROM Operations;

-- START FROM HERE

INSERT INTO isOf(Op_id, Dept_id) VALUES (1,1), (2,2), (3, 3), (4,4), (5,5), (6,6);
SELECT * FROM isOf;


insert into DrugStore (drug_name, composition) values ('Blood Thinner', '{"Potassium"}'), ('Eye Drops', '{"Phosporus", "Sodium"}'), ('Sunscreen', '{"SPF"}'), ('Aspirine', '{"Sodium"}'), ('Eardrops', '{}'), ('Painkillers', '{"Potassium"}');
SELECT * FROM DrugStore;


insert into Producer (Company_Name, location) values ('P1', 'aaa'), ('P2', 'bbb');
SELECT * FROM Producer;


insert into Drug_Prod (Prod_id, Drug_id, Name, Cost, Quantitiy) values (1, 1, 'Anticoagulation', 10, 10), (2, 2, 'Nedocromil', 10, 10), (2, 3, 'Sunscreen', 10, 10), (2, 4, 'ibuprofen', 20, 20), (1, 5, 'Edrop', 20, 20), (1, 6, 'Combiflam', 20, 20);

SELECT * FROM Drug_Prod;


insert into NurseAssignment values (1, 'Test', 'The nurse will conduct tests'), (2, 'OT', 'The Nurse will assist doctor in ongoing operations');


INSERT INTO Worksin values (1, 1, time '9:00:00', time '18:00:00', 'Yes'), (2, 1, time '9:00:00', time '18:00:00', 'Yes'), (3, 2, time '9:00:00', time '18:00:00', 'Yes'), (4, 2, time '18:00:00', time '4:00:00', 'Yes');
INSERT INTO Worksin values (5, 1, time '9:00:00', time '18:00:00', 'Yes'), (6, 1, time '9:00:00', time '18:00:00', 'Yes'), (7, 2, time '9:00:00', time '18:00:00', 'Yes'), (8, 2, time '18:00:00', time '4:00:00', 'Yes');
INSERT INTO Worksin values (9, 1, time '9:00:00', time '18:00:00', 'Yes'), (10, 1, time '9:00:00', time '18:00:00', 'Yes'), (11, 2, time '9:00:00', time '18:00:00', 'Yes'), (12, 2, time '18:00:00', time '4:00:00', 'Yes');
INSERT INTO Worksin values (13, 1, time '9:00:00', time '18:00:00', 'Yes'), (14, 1, time '9:00:00', time '18:00:00', 'Yes'), (15, 2, time '9:00:00', time '18:00:00', 'Yes'), (16, 2, time '18:00:00', time '4:00:00', 'Yes');
INSERT INTO Worksin values (17, 1, time '9:00:00', time '18:00:00', 'Yes'), (18, 1, time '9:00:00', time '18:00:00', 'Yes'), (19, 2, time '9:00:00', time '18:00:00', 'Yes'), (20, 2, time '18:00:00', time '4:00:00', 'Yes');
INSERT INTO Worksin values (21, 1, time '9:00:00', time '18:00:00', 'Yes'), (22, 1, time '9:00:00', time '18:00:00', 'Yes'), (23, 2, time '9:00:00', time '18:00:00', 'Yes'), (24, 2, time '18:00:00', time '4:00:00', 'Yes');
INSERT INTO Worksin values (25, 1, time '9:00:00', time '18:00:00', 'Yes'), (26, 1, time '9:00:00', time '18:00:00', 'Yes'), (27, 2, time '9:00:00', time '18:00:00', 'Yes'), (28, 2, time '18:00:00', time '4:00:00', 'Yes');

UPDATE Worksin set shiftstart = time '6:00:00', shiftend = time '11:59:59' WHERE n_id <= 7;
UPDATE Worksin set shiftstart = time '12:00:00', shiftend = time '17:59:59' WHERE n_id > 7 and n_id <= 14;
UPDATE Worksin set shiftstart = time '18:00:00', shiftend = time '23:59:59' WHERE n_id > 14 and n_id <= 21;
UPDATE Worksin set shiftstart = time '00:00:00', shiftend = time '5:59:59' WHERE n_id > 21 and n_id <= 28;

-- UPDATE TABLE Worksin set shiftend = time '23:59:00' WHERE shiftend = time '18:00:00';

-- UPDATE TABLE Worksin set shiftend = time '11:59:00' WHERE shiftend = time '18:00:00';
-- UPDATE TABLE Worksin set shiftend = time '11:59:00' WHERE shiftend = time '18:00:00';

-- UPDATE TABLE Worksin set shiftstart = time '6:00:00' WHERE shiftstart = time '9:00:00';
-- UPDATE TABLE Worksin set shiftend = time '11:59:00' WHERE shiftend = time '18:00:00';



SELECT * FROM Worksin;
--INSERTION WITH FUNCTION


select * from newappointment(1, 'Aman', 56, '{"Headache", "Nausea"}', 'Male', 65, 170);
select * from newappointment(5, 'Shiela', 22, '{"Low Blood Sugar"}', 'Female', 54, 165);
select * from newappointment(3, 'Riya', 20, '{"Cough"}', 'Female', 60, 163);
select * from newappointment(2, 'Travis', 34, '{"Fever"}', 'Male', 80, 190);
select * from newappointment(10, 'Justin', 44, '{"Rash"}', 'Male', 87, 180);
select * from newappointment(4, 'Elaenor', 20, '{"Short Breath"}', 'Female', 70, 173);
select * from newappointment(8, 'Jane', 18, '{""}', 'Female', 60, 175);
select * from newappointment(6, 'Riya', 5, '{"Fever", "Cough"}', 'Female', 30, 100);
select * from newappointment(9, 'Yolanda', 78, '{"Migrane"}', 'Female', 60, 163);
select * from newappointment(7, 'Kyle', 27, '{"Dizziness", "Insomnia"}', 'Male', 76, 175);
select * from newappointment(11, 'Amar', 56, '{"Headache", "Nausea"}', 'Male', 65, 170);
select * from newappointment(12, 'Sreya', 22, '{"Low Blood Sugar"}', 'Female', 54, 165);
select * from newappointment(13, 'Riyaz', 20, '{"Cough"}', 'Male', 60, 163);
select * from newappointment(14, 'Tarun', 34, '{"Fever"}', 'Male', 80, 190);
select * from newappointment(15, 'Jyothi', 44, '{"Rash"}', 'Male', 87, 180);


select * from newappointment(16, 'Enakshi', 20, '{"Short Breath"}', 'Female', 70, 173);
select * from newappointment(17, 'Judith', 18, '{""}', 'Female', 60, 175);
select * from newappointment(18, 'Riya', 5, '{"Fever", "Cough"}', 'Female', 30, 100);
select * from newappointment(19, 'Sreya', 78, '{"Migrane"}', 'Female', 60, 163);
select * from newappointment(20, 'Aman', 27, '{"Dizziness", "Insomnia"}', 'Male', 76, 175);
select * from newappointment(21, 'Aubrey', 56, '{"Headache", "Nausea"}', 'Male', 65, 170);
select * from newappointment(22, 'Falak', 22, '{"Low Blood Sugar"}', 'Female', 54, 165);
select * from newappointment(23, 'Ruchi', 20, '{"Cough"}', 'Female', 60, 163);
select * from newappointment(24, 'Teher', 34, '{"Fever"}', 'Male', 80, 190);
select * from newappointment(25, 'Judith', 44, '{"Rash"}', 'Male', 87, 180);
select * from newappointment(26, 'Elaenor', 20, '{"Short Breath"}', 'Female', 70, 173);
select * from newappointment(27, 'Janaki', 18, '{""}', 'Female', 60, 175);
select * from newappointment(28, 'Ruchi', 5, '{"Fever", "Cough"}', 'Female', 30, 100);
select * from newappointment(29, 'Yami', 78, '{"Migrane"}', 'Female', 60, 163);
select * from newappointment(30, 'Kali', 27, '{"Dizziness", "Insomnia"}', 'Male', 76, 175);

SELECT * FROM patient;
SELECT * FROM TakesAppoints;

-- select appointment(8, '{}', 5, 'a632a5f');


select putpres('{"Echo", "Blood Test"}', '{"Heart Bypass"}', '{"Blood Thinner", "Paracetamol"}', 1, 1);
select putpres('{"Echo", "Blood Test", "ECG"}', '{"Heart Bypass"}', '{"Blood Thinner", "Paracetamol"}', 2, 5);
select putpres('{"Blood Test", "ECG"}', '{""}', '{"Blood Thinner"}', 3, 3);
select putpres('{"Blood Test"}', '{"Heart Bypass"}', '{"Aspirine", "Paracetamol"}', 4, 2);
select putpres('{}', '{}', '{}', 5, 10);
select putpres('{"HIV", "Blood Test", "ECG"}', '{}', '{"Paracetamol"}', 6, 4);
select putpres('{"Echo"}', '{}', '{"Blood Thinner"}', 7, 8);
select putpres('{}', '{"LASIK"}', '{"Eye Drops"}', 8, 6);
select putpres('{}', '{}', '{}', 9, 9);
select putpres('{}', '{}', '{"Paracetamol"}', 10, 7);
select putpres('{}', '{}', '{"Paracetamol"}', 11, 11);
select putpres('{}', '{}', '{}', 12, 12);
select putpres('{"Blood Test"}', '{}', '{"Paracetamol"}', 13, 13);
select putpres('{}', '{}', '{"Eardrops", "Paracetamol"}', 14, 14);
select putpres('{}', '{}', '{}', 15, 15);
select putpres('{"Blood Test"}', '{}', '{"Eardrops"}', 16, 16);
select putpres('{}', '{}', '{}', 17, 17);
select putpres('{"Blood Test"}', '{"Heart Bypass"}', '{}', 18, 18);
select putpres('{}', '{}', '{}', 19, 19);
select putpres('{}', '{}', '{"Sunscreen"}', 20, 20);
select putpres('{}', '{"Crainiotomy"}', '{}', 21, 21);
select putpres('{}', '{}', '{}', 22, 22);
select putpres('{}', '{"Sinus Surgery"}', '{}', 23, 23);
select putpres('{}', '{}', '{}', 24, 24);
select putpres('{}', '{}', '{"Eye Drops", "Sunscreen"}', 25, 25);
select putpres('{}', '{}', '{}', 26, 26);
select putpres('{}', '{}', '{}', 27, 27);
select putpres('{}', '{}', '{}', 28, 28);
select putpres('{}', '{}', '{}', 29, 29);
select putpres('{}', '{}', '{}', 30, 30);

SELECT * FROM Prescription;
SELECT * FROM Prescribes;
SELECT * FROM Takes;
SELECT * FROM OT;








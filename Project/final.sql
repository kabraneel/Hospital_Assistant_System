-- CREATING THE DATABASE
DROP DATABASE hospital_system_assistant;

REVOKE ALL on 
ALL TABLES in SCHEMA public
FROM doctors;


REVOKE ALL on 
ALL SEQUENCES in SCHEMA public
FROM doctors;

REVOKE ALL on 
ALL TABLES in SCHEMA public
FROM patient;

REVOKE ALL on 
ALL SEQUENCES in SCHEMA public
FROM patient;


REVOKE ALL on 
ALL TABLES in SCHEMA public
FROM nurses;

REVOKE ALL on 
ALL SEQUENCES in SCHEMA public
FROM nurses;


CREATE DATABASE hospital_system_assistant;
\c hospital_system_assistant




-- CREATING THE TABLES
-- CREATE TABLE DrugStore (Drug_id serial NOT NULL, Drug_name varchar(30) UNIQUE NOT NULL, PRIMARY KEY (Drug_id));
CREATE TABLE DrugStore (Drug_id serial NOT NULL, Drug_name varchar(30) UNIQUE NOT NULL, composition varchar(50) [], PRIMARY KEY (Drug_id));  
CREATE TABLE Nurse (N_id serial NOT NULL, Name varchar(30) NOT NULL, Salary Integer NOT NULL check (Salary >= 0), Age Integer NOT NULL check (age > 18), YearsOfExp Integer NOT NULL check (YearsOfExp >= 0 and YearsOfExp < age - 18), sex varchar(10) not null, Password varchar(7) DEFAULT (substring (md5(random()::text), 0, 8)) NOT NULL,constraint check_sex check (sex in ('Male', 'Female', 'Intersex')),PRIMARY KEY (N_id));
CREATE TABLE NurseAssignment (A_id serial NOT NULL, Assignment varchar(30) NOT NULL , description text NOT NULL,CONSTRAINT check_assign check (Assignment in ('OT', 'Test', 'Assisting Doctor')), PRIMARY KEY (A_id));
CREATE TABLE Producer (Prod_id serial NOT NULL, Company_Name varchar(30) NOT NULL, location varchar(30) NOT NULL, PRIMARY KEY (Prod_id));
CREATE TABLE Test (Test_id serial NOT NULL, Test_name varchar(30) NOT NULL, cost Integer NOT NULL check (cost > 0), PRIMARY KEY (Test_id));
create table Operations(op_id serial not null, op_name varchar(50) unique not null, cost int not null check (cost > 0), equipments varchar(50) [], primary key (op_id));
create table Patient(p_id serial not null, name varchar(50) not null, age int not null check (age > 0), sex varchar(10) not null, weight numeric(5,2) check (weight >= 0), height numeric(5,2) check (height >= 0),Password varchar(7) DEFAULT (substring (md5(random()::text), 0, 8)) NOT NULL,constraint check_sex check (sex in ('Male', 'Female', 'Intersex')), primary key (p_id));
create table Department(dept_id serial not null, dept_name varchar(50) unique not null, budget int check (budget > 0), hod Integer, building varchar(20) NOT NULL,primary key (dept_id));
CREATE TABLE Prescription(pres_id serial NOT NULL, Test_id Integer [], Op_id Integer [], Drug_id Integer [], PRIMARY KEY (pres_id));
CREATE TABLE Doctor(Dr_id serial NOT NULL, Name varchar(30) NOT NULL, Age Integer NOT NULL check (age > 18), Salary Integer NOT NULL check (Salary >= 0), YearsOfExp Integer NOT NULL check (YearsOfExp >= 0 and YearsOfExp < age - 18), Password varchar(7) DEFAULT (substring (md5(random()::text), 0, 8)) NOT NULL,PRIMARY KEY(Dr_id));
-- CREATE TABLE Doctor1(Dr_id serial NOT NULL, Name varchar(30) NOT NULL, Age Integer NOT NULL check (age > 18), Salary Integer NOT NULL check (Salary >= 0), YearsOfExp Integer NOT NULL check (YearsOfExp >= 0 and YearsOfExp < age - 18), Password varchar(7) DEFAULT (substring (md5(random()::text), 0, 8)) NOT NULL,PRIMARY KEY(Dr_id));
ALTER TABLE Department ADD CONSTRAINT FK_DOC FOREIGN KEY (hod) REFERENCES Doctor(Dr_id);

-- DONE WITH TABLES CREATION 

-- NOW CREATING THE RELATIONS 
CREATE TABLE Buys(P_id Integer NOT NULL, Pres_id Integer NOT NULL, Drug_id Integer NOT NULL, PRIMARY KEY(P_id, Pres_id, Drug_id), FOREIGN KEY (P_id) REFERENCES Patient(P_id), FOREIGN KEY (Pres_id) REFERENCES Prescription(Pres_id), FOREIGN KEY (Drug_id) REFERENCES DrugStore(Drug_id));
CREATE TABLE Takes(Test_id Integer NOT NULL, P_id Integer NOT NULL, Pres_id Integer NOT NULL, DateOfTest date default (current_date) not null, Timeoftest time default (current_time) NOT NULL, result jsonb,PRIMARY KEY(Test_id, P_id, Pres_id), FOREIGN KEY (Test_id) REFERENCES Test(Test_id), FOREIGN KEY (P_id) REFERENCES Patient(P_id), FOREIGN KEY (Pres_id) REFERENCES Prescription(Pres_id));
CREATE TABLE Prescribes(P_id Integer NOT NULL, Dr_id Integer NOT NULL, Pres_id Integer NOT NULL, PRIMARY KEY(P_id, Dr_id, Pres_id), FOREIGN KEY (P_id) REFERENCES Patient(P_id), FOREIGN KEY (Dr_id) REFERENCES Doctor(Dr_id), FOREIGN KEY (Pres_id) REFERENCES Prescription(Pres_id));
CREATE TABLE ReportTo(N_id Integer NOT NULL, Dr_id Integer NOT NULL, PRIMARY KEY(N_id, Dr_id), FOREIGN KEY (N_id) REFERENCES Nurse(N_id), FOREIGN KEY (Dr_id) REFERENCES Doctor(Dr_id));
CREATE TABLE Drug_Prod(Prod_id Integer NOT NULL, Drug_id Integer NOT NULL, Name varchar(20) NOT NULL, Cost numeric(5,2) NOT NULL check (Cost >=0), Quantity Integer NOT NULL check (Quantity >= 0),PRIMARY KEY(Drug_id, Prod_id), FOREIGN KEY (Drug_id) REFERENCES DrugStore(Drug_id), FOREIGN KEY (Prod_id) REFERENCES Producer(Prod_id));
CREATE TABLE Worksin(N_id Integer NOT NULL, A_id Integer NOT NULL, Shiftstart time NOT NULL, Shiftend time NOT NULL,Available varchar(3) check (Available in ('Yes', 'No')), PRIMARY KEY(N_id, A_id), FOREIGN KEY (N_id) REFERENCES Nurse(N_id), FOREIGN KEY (A_id) REFERENCES NurseAssignment(A_id));
create table BelongsTo (Dr_id Integer Not null, Dept_id Integer Not null, Foreign Key(Dr_id) references Doctor(Dr_id), Foreign Key(Dept_id) references Department(Dept_id), Primary Key(Dr_id, Dept_id));
create table isOf (Op_id Integer Not null, Dept_id Integer Not null, Foreign Key(Op_id) references Operations(Op_id), Foreign Key(Dept_id) references Department(Dept_id), Primary Key(Op_id, Dept_id));    
create table TakesAppoints(P_id Integer Not null, Dr_id Integer Not null, DateOfApp date default(current_date) not null , symptoms varchar(50) [], TimeofApp time default (current_time) NOT NULL, Fees Integer default (500) NOT NULL ,Foreign Key(P_id) references Patient(P_id), Foreign Key(Dr_id) references Doctor(Dr_id), Primary Key(P_id, Dr_id, DateOfApp));
create table OT (Pres_id Integer Not null, Dr_id Integer NOT NULL,P_id Integer Not null, Op_id Integer Not null, DateOfOp date not null, RoomNumber Integer not null, result jsonb,Foreign Key(Pres_id) references Prescription(Pres_id), Foreign Key(P_id) references Patient(P_id), Foreign Key(Op_id) references Operations(Op_id), Primary Key(Pres_id, P_id, Op_id), Foreign Key(Dr_id) references Doctor(Dr_id));


/*
	
	ORDER OF INSERTION in relations
	# hey muffinsss, the password is : 123456
	1. Takes Appointment DONE

	
	THEN TIGGER triggers on insertion into prescription

		Prescribes, Buys, Takes, Operation
		
	 	--- DONT NEED 

	CONSTRAINTS -> BUYS
					1. If drug in pres
					2. If patient has pres

				-> TAKES
					1. if patient has pres
					2. pres has test_id

				-> OP
					1. if patient has pres
					2. pres has op_id
		--- 


*/

/*
	
	check prescribes to make sure appointment bw

*/

--- FUNCTIONS START HERE

-- insert appointment
create or replace function newappointment(Doc_id Integer, name1 varchar(50), age1 int, symptoms1 varchar(50) [], sex1 varchar(50), weight1 numeric(5,2), height1 numeric(5,2)) 
	returns table( Patient_id int,NewPassword varchar(7))
language plpgsql
as $$
declare 
	s int;
begin
	insert into Patient (name, age, sex, weight, height) values (name1, age1, sex1, weight1, height1);
	SELECT p_id into s from Patient ORDER BY p_id desc limit 1;
	insert into TakesAppoints (P_id, Dr_id, symptoms) values (s, Doc_id, symptoms1);

	return query(select p_id,Password from Patient WHERE p_id = s);
end;
$$;


create or replace function appointment(Doc_id Integer, symptoms1 varchar(50) [], p_id1 int, Pass varchar(7)) returns void 
language plpgsql
as $$
declare 
	s int;
begin
	-- insert into Patient (name, age, sex, weight, height) values (name1, age1, sex1, weight1, height1);
	-- SELECT p_id into s from Patient where p_id = ;
	if(Pass = (SELECT Password FROM Patient WHERE p_id = p_id1))
	then
	begin
	insert into TakesAppoints (P_id, Dr_id, symptoms) values (p_id1, Doc_id, symptoms1);
	end ;
	else 
	begin 
		raise notice 'Wrong Patient_id/Password';
	end;
	end if;
end;
$$;


create or replace function check_doc_for_pres(p_id1 int, dr_id1 int)
returns VARCHAR(5)
language plpgsql
as
$$
begin
	if (current_date = (SELECT DateOfApp FROM TakesAppoints WHERE p_id = p_id1 AND Dr_id = dr_id1))
	then
		return 'True';
	else 
		return 'False';
	end if;
end;
$$;

ALTER TABLE Prescribes ADD CONSTRAINT check_doc_pres check (check_doc_for_pres(p_id, dr_id) = 'True');

CREATE OR REPLACE FUNCTION putpres(tests varchar(20) [], operations varchar(20) [], drugs varchar(20) [], p1_id int, dr1_id int) RETURNS VOID AS
$$
DECLARE
	testids INT[] DEFAULT  ARRAY[]::INT[];
	opids INT[] DEFAULT  ARRAY[]::INT[];
	drugids INT[] DEFAULT  ARRAY[]::INT[];
	i varchar(20);
	j int;
BEGIN
	

	FOREACH i IN ARRAY tests
	LOOP
		IF (i IN (SELECT test_name from Test)) THEN
    		
			SELECT Test_id into j FROM Test Where test_name = i;
			SELECT ARRAY_Append(testids, j) INTO testids;

		END IF;
    
    END LOOP;

  -- operations
  FOREACH i IN ARRAY operations
	LOOP
		IF (i IN (SELECT op_name from Operations)) THEN
    		
			SELECT op_id into j FROM Operations Where op_name = i;
			SELECT ARRAY_Append(opids, j) INTO opids;

		END IF;
    
    END LOOP;

  -- drugs

  FOREACH i IN ARRAY drugs
	LOOP
		IF (i IN (SELECT drug_name from DrugStore)) THEN
    		
			SELECT drug_id into j FROM DrugStore Where drug_name = i;
			SELECT ARRAY_Append(drugids, j) INTO drugids;

		END IF;
    
    END LOOP;

    if((select check_doc_for_pres(p1_id, dr1_id)) = 'True')
    Then
		INSERT INTO Prescription (Test_id, Op_id, Drug_id) VALUES (testids, opids, drugids);

		SELECT pres_id INTO j FROM Prescription ORDER BY pres_id DESC LIMIT 1;

		INSERT INTO Prescribes (pres_id, dr_id, p_id) VALUES (j, dr1_id, p1_id);
	end if;
	-- return j;

END
$$
LANGUAGE 'plpgsql';


--- Function to give rooms to patient
create or replace function give_room()
returns trigger
language plpgsql
as
$$
declare
	d date;
begin
	if (new.DateOfOp in (select DateOfOp from OT where RoomNumber = new.RoomNumber)) 
	then 
		begin
		
		SELECT DateOfOp into d from OT where RoomNumber = new.RoomNumber ORDER by DateOfOp desc limit 1;
		new.DateOfOp := d+1;

		end;
	end if;
	return new;
end;
$$;


--- Function for trigger to prescribes
create or replace function pres_trigger_func()
	returns trigger
	language plpgsql
	as 
	$$
	declare
		i int; 
		opids INT[];
		tids INT[];
		dids INT[]; 
		r int;
		c int;
		d date;
	begin
		
		SELECT op_id into opids from Prescription where pres_id = new.pres_id;		
		SELECT test_id into tids from Prescription where pres_id = new.pres_id;		
		SELECT drug_id into dids from Prescription where pres_id = new.pres_id;		
		
	-- insert into takes

		FOREACH i in ARRAY tids
			LOOP
				begin
					insert into Takes (Test_id, P_id, Pres_id) values (i, new.p_id, new.pres_id);
				end;
			END Loop;

	-- insert into buys

		FOREACH i in ARRAY dids
			LOOP
				begin
					insert into Buys (P_id, Pres_id, Drug_id) values (new.p_id, new.pres_id, i);
				end;
			END Loop;

	-- insert into ot

		FOREACH i in ARRAY opids
			LOOP
			    begin
			    	SELECT current_date + 7 into d;
					SELECT count(*)+1 into c from OT;
						if (c <= 25)
							then
								begin
								insert into OT values (new.pres_id, new.dr_id, new.p_id, i, d, c);
								end;
							else
								begin
								r := ((c-1)%25)+1;	
								insert into OT values (new.pres_id, new.dr_id, new.p_id, i, d, r);
								end;
						end if;
				end;
			end LOOP;
		return new;
	end;
	$$;

--- Creating trigers

create trigger pres_trigger
after insert
ON prescribes
for each row
execute procedure pres_trigger_func();

create trigger ot_trigger
before insert 
on OT
for each row
execute procedure give_room();



--medical history
create or replace function medical_history(p_id1 int)
returns table (
				Procedure varchar(50),
			   result jsonb, 
				Date date)
language plpgsql
as
$$
begin
	return query ((select Test.Test_name, Takes.result, takes.DateOfTest from Takes 
		join Test on Takes.test_id = Test.test_id WHERE takes.p_id = p_id1)
		union 
		(select Operations.op_name, OT.result, OT.DateOfOp from OT 
		join Operations on OT.op_id = Operations.op_id WHERE OT.p_id = p_id1));
end;
$$;

-- functions ot show the docs
create or replace function show_doc(dept varchar(50)) returns table
	(Name varchar(50),
	 ID Integer,
	 YearsOfExp Integer,
	 Age Integer)
language plpgsql
as $$
begin
	return query (select Doctor.name, Doctor.dr_id, Doctor.YearsOfExp, Doctor.age from Doctor
	join BelongsTo on BelongsTo.dr_id = Doctor.dr_id
	join Department on Department.dept_id = BelongsTo.dept_id
	where Department.dept_name = dept);
end;
$$;

-- SELECT * FROM show_doc('Cardiology');

-- Show list of tests 
create or replace function show_tests() returns table
	(Name varchar(50),
	 cost Integer)
language plpgsql
as $$
begin
	return query (select Test.Test_name, Test.cost from Test);
end;
$$;

--select * from show_tests();

--v2

create or replace function makeBill(pres_id1 integer, p_id1 Integer, pass varchar(7)) returns table
	(ServiceProvided varchar(50),
	 cost numeric(5,2),
	dateofservice date)
language plpgsql
as $$
begin
	

	if(pres_id1 IN (SELECT pres_id FROM prescribes WHERE p_id = p_id1) AND pass = (SELECT Password FROM Patient WHERE p_id = p_id1))
	then
	begin
	-- insert into TakesAppoints (P_id, Dr_id, symptoms) values (p_id1, Doc_id, symptoms1);
		return query ((select test.test_name, test.cost, takes.DateOfTest from test
				join Takes on test.test_id = Takes.test_id
				where Takes.pres_id = pres_id1)
			union 
			(select operations.op_name, Operations.cost, OT.DateOfOp from Operations
					join OT on Operations.op_id = OT.op_id
					where OT.pres_id = pres_id1)
			union 
			(select DrugStore.drug_name, max(Drug_Prod.cost), NULL as cost from Drug_Prod
					join DrugStore on DrugStore.drug_id = Drug_Prod.drug_id
					join Buys on Buys.drug_id = DrugStore.drug_id
					where Buys.pres_id = pres_id1
					GROUP BY DrugStore.drug_name)
			ORDER BY cost ASC
			);
		end ;
	else 
	begin 
		raise notice 'Wrong Patient_id/Password/Prescription_id';
	end;
	end if;

end;
$$;


--select * from makebill(1);


--- Function to call a nurse
create or replace function call_nurse(dr_id1 int,n_id1 int, pass varchar(7))
returns varchar(50)
language plpgsql
as
$$
declare
begin
    if(pass = (select Password from Doctor WHERE Dr_id = dr_id1) AND current_time <= (Select Shiftend from Worksin where n_id = n_id1) AND current_time >= (Select Shiftstart from Worksin where n_id = n_id1) AND (select Available from Worksin where n_id = n_id1) = 'Yes') THEN
        INSERT INTO ReportTo (N_id, Dr_id) VALUES (n_id1, dr_id1);
   		return 'Nurse will report to you';
    END IF;

    return 'Nurse unavailable / Incorrect Credentials';
end;
$$;

-- Function for trigger to insertion in ReportsTo

create or replace function trigger_reports_insert() returns trigger
language plpgsql
as $$
begin
    update Worksin set Available = 'No' where n_id = new.n_id;
    return new;
end;
$$;

-- Trigger for insertion in ReportsTo

create trigger trigger_reports_in 
after insert
on ReportTo
for each row
execute procedure trigger_reports_insert();

-- function for trigger to change availability
create or replace function release_nurse(dr_id1 int, n_id1 int, pass varchar(7))
returns void
language plpgsql
as
$$
declare
begin
	if(pass = (select Password from Doctor WHERE Doc_id = dr_id1)) 
	THEN
    DELETE FROM ReportTo WHERE N_id = n_id1 AND Dr_id = dr_id1;
    END IF;
end;
$$;


-- Function for trigger to deletion in ReportsTo

create or replace function trigger_reports_delete() returns trigger
language plpgsql
as $$
begin
    update Worksin set Available = 'Yes' where n_id = old.n_id;
    return old;
end;
$$;

-- Trigger

create trigger trigger_reports_out
after DELETE
ON ReportTo
for each row
execute procedure trigger_reports_delete();

create or replace function enter_test_results(n_id1 Integer, pass varchar(7), p_id1 Integer, test_id1 integer, pres_id1 integer, result1 jsonb) returns void
    language plpgsql
    as $$
    begin
        if (pass != (SELECT password from Nurse where n_id = n_id1))
            then
            begin
                raise notice 'User_id/Password is Incorrect!';
            end;
            else
            begin
                if ((select Worksin.A_id from Worksin join Nurse on Nurse.n_id = Worksin.n_id where Nurse.n_id = n_id1) = 1)
                then
                begin
                    update takes set result = result1 where p_id = p_id1 and test_id = test_id1 and pres_id = pres_id1;
                end;
                else
                begin
                    raise notice 'Nurse cannot make an entry to this table!';
                end;
                end if;
            end;
        end if;
    end;
    $$;

create or replace function enter_op_results(n_id1 Integer, pass varchar(7), p_id1 Integer, op_id1 integer, pres_id1 integer, result1 jsonb) returns void
language plpgsql
as $$
begin
    if (pass != (SELECT password from Nurse where n_id = n_id1))
        then
        begin
            raise notice 'User_id/Password is Incorrect!';
        end;
        else
        begin
            if ((select Worksin.A_id from Worksin join Nurse on Nurse.n_id = Worksin.n_id where Nurse.n_id = n_id1) = 2)
            then
            begin
                update ot set result = result1 where p_id = p_id1 and op_id = op_id1 and pres_id = pres_id1;
            end;
            else
            begin
                raise notice 'Nurse cannot make an entry to this table!';
            end;
            end if;
        end;
    end if;
end;
$$;

create or replace function get_all_pres(p_id1 Integer, pass varchar(7)) 
    returns table (
        pres_id int)
    language plpgsql
    as $$
        begin
            return query(select Prescribes.pres_id from prescribes 
                join Patient on prescribes.p_id = Patient.p_id
                where Patient.p_id = p_id1 AND Patient.password = pass);
        end;
    $$;

create or replace function change_pass_patient(p_id1 Integer, pass1 varchar(7), pass2 varchar(7))
    returns void
    language plpgsql
    as $$
    begin
        if (pass1 = (SELECT password from Patient where p_id = p_id1))
            then
            begin
                update Patient set password = pass2 where p_id = p_id1;
            end;
            else
            begin
                raise notice 'Incorrect User_id/Password!';
            end;
        end if;
    end;
    $$;

create or replace function change_pass_nurse(n_id1 Integer, pass1 varchar(7), pass2 varchar(7))
    returns void
    language plpgsql
    as $$
    begin
        if (pass1 = (SELECT password from Nurse where n_id = n_id1))
            then
            begin
                update Nurse set password = pass2 where n_id = n_id1;
            end;
            else
            begin
                raise notice 'Incorrect User_id/Password!';
            end;
        end if;
    end;
    $$;

create or replace function change_pass_doctor(d_id1 Integer, pass1 varchar(7), pass2 varchar(7))
    returns varchar(50)
    language plpgsql
    as $$
    begin
        if (pass1 = (SELECT password from Doctor where dr_id = d_id1))
            then
            begin
                update Doctor set password = pass2 where dr_id = d_id1;
                return 'Done';
            end;
            else
            begin
                -- raise notice 'Incorrect User_id/Password!';
            	return 'Failed/ Incorrect Credentials';
            end;
        end if;
    end;
    $$;



/*

	
	-- patient -> 

	-- 	show_docs()
	-- 	show_test()
	-- 	appoitment()
	-- 	newappointment()

	-- 	get_pres()
	-- 	make_bill()





	-- show_docs() : (deptname : [   ]) [submit]

	-- --	python code

	-- -- render []

	-- doctor ->

		
	-- 	medical_history(patient_id)  
	-- 	putpres()
	-- 	call_nurse()
	-- 	release_nurse()
*/


/*
	SEXY VIEWS
*/

-- create or replace view check_nurse_shift
--     as select Nurse.n_id, Nurse.name, Worksin.Shiftstart, Worksin.Shiftend from Nurse
--     join Worksin on Worksin.n_id = Nurse.n_id where current_time <= Worksin.Shiftend;

create or replace view check_nurse_shift
    as select Nurse.n_id, Nurse.name, Worksin.Shiftstart, Worksin.Shiftend, NurseAssignment.Assignment, Worksin.Available from Nurse
    join Worksin on Worksin.n_id = Nurse.n_id 
    join NurseAssignment on NurseAssignment.A_id = Worksin.A_id where current_time <= Worksin.Shiftend and current_time >= Worksin.Shiftstart;


create or replace view doc_view
    as select doctor.Dr_id, doctor.Name, doctor.Age, doctor.Salary, doctor.YearsOfExp, department.dept_name as Dept FROM Doctor
    join BelongsTo on BelongsTo.dr_id = Doctor.dr_id
    join Department on Department.dept_id = BelongsTo.dept_id;

create or replace view nurse_view
    as select Nurse.n_id, Nurse.name, Worksin.Shiftstart, Worksin.Shiftend, NurseAssignment.Assignment, Nurse.Salary, Nurse.YearsOfExp, Nurse.sex from Nurse
    join Worksin on Worksin.n_id = Nurse.n_id 
    join NurseAssignment on NurseAssignment.A_id = Worksin.A_id;

create or replace view patient_view
    as select p_id, Name, age, sex, height, weight from Patient;


/*
	
	Pending work:
	1. Functions check : 30 mins
	2. Required views : --
	3. Indexing : 1.5 hours
	4. Roles : 30 mins
	3. Report : 3 hrs -- Hand in hand
	
	Total : 6 hours

	10 -> 6 (8 hours)

	6 till when we sleep
	(finish and then only sleep)

*/

/*
	
	Functions which we have checked :
		
		1. appointment() : Takes an existing doctor_id, list of symptoms, patient_id, password and books an appointment.
		2. call_nurse() : Takes a nurse_id, doctor_id, and password, and appoints the nurse to the doctor if she is avaliable and has a shift at the current moment.
		3. change_pass_doctor() : Takes a doctor_id, old_password and a new password and changes the password in the table doctor.
		4. change_pass_patient() : Takes a patient_id, old_password and a new password and changes the password in the table patient.
		5. change_pass_nurse() 	: Takes a Nurse_id, old_password and a new password and changes the password in the table nurse.
		6. check_doc_for_pres() : Takes a patient_id, doctor_id and checks if the pair is present in the table takesappoints
		7. enter_op_results() 	: Takes a nurse_id, password, patient_id, operation_id, pres_id, and the result as a json, and puts in the OT table.
		8. enter_test_results() : Takes a nurse_id, password, patient_id, test_id, pres_id, and the result of the test(Json), and puts in the Takes table.
		9. get_all_pres()		: Takes a p_id, password and gives all prescriptions of this patient.
		10. give_room()			: Helper function for OT. 
		11. makebill()			: Takes a pres_id, p_id, and password of the patient, and returns the summary of costs and all tests/operations taken.
		12. medical_history()	: Takes a patient_id, and gives all the test, operations, their dates and their results for that patient.
		13. pres_trigger_func() : Helper function for the trigger on insertion into Prescribes to enter data into Takes, OT, Buys.
		14. putpres()			: A doctor can put in a prescription for a patient, along with a list of testnames, list of operation names, patient id, doctor_id, if there exists an appointment.
		15. release_nurse()		: A doctor can release the nurse he occupied once he is done. Takes dr_id, nurse_id and password of the doctor.
		16. show_tests()		: Show all tests offered by the hospital.
		17. trigger_reports_delete() : helper function for trigger to insert entry into reportsto once call_nurse is called.
		18. trigger_reports_insert() : helper function for trigger to delete entry from reportsto once release_nurse is called.

*/

/*
	Triggers :

		


	
	Index :

		1.	Hash index on patient_id in patient: useful for appointment(), change_pass_patient(), get_all_pres()
		2.	Hash index on Nurse_id in Worksin: Useful for call_nurse(), enter_op_results(), enter_test_results(), trigger_reports_delete(), trigger_reports_insert()
		3. 	Hash index on doctor_id : Useful for change_pass_doctor(), call_nurse(), release_nurse()
		4.	Hash index on Nurse_id in Nurse: Useful for change_pass_nurse(). enter_op_results(), enter_test_results(), trigger_reports_delete(), trigger_reports_insert()
		5. 	BTree index on (patient_id, dr_id) on takesappoints: Useful for check_doc_for_pres()
		6.  Btree index on room_num : Useful give_room()	
		7. 	Hash index on pres_id in OT : Useful for makebill()
		8. 	Hash index on pres_id in Takes : Useful for makebill()
		9. 	Hash index on pres_id in Buys : Useful for makebill()
		10. Hash index on p_id in Prescribes : Useful for makebill()
		11. Hash index on p_id in OT : Useful for medical_history()
		12. Hash index on p_id in Takes : Useful for medical_history()
		13. Hash index on pres_id in Prescribes : useful for pres_trigger_function()
		14. Hash index on test_name in Test: useful for putpres()
		15. Hash index on op_name in Operation: useful for putpres()
		16. Hash index on drug_name in Drugstore: useful for putpres()



	



		

select enter_test_results(9, 'daaafba', 3, 1, 1, '{"HB":"High","Sugar":"Low"}')

select enter_op_results(8, '5a4d5f6', 1, 1, 1, '{"Result":"Successful"}')


*/


 -- explain analyze select appointment(8, '{"Headache"}', 1, '5b68adf');

-- Indices

create index Patient_id on Patient using hash(P_id);
create index Doctor_id on Doctor using hash(Dr_id);
create index Nurse_id on Nurse using hash(N_id);
create index Nurse_id on Worksin using hash(N_id);
create index Pat_Doc_id on TakesAppoints using Btree(P_id, Dr_id);
create index room_num on OT using Btree(RoomNumber);

create index Patient_id on Prescribes using hash(P_id);
create index OT_pres_id on OT using hash(pres_id);
create index Takes_pres_id on Takes using hash(pres_id);
create index Buys_pres_id on Buys using hash(pres_id);

create index OT_pat_id on OT using hash(p_id);
create index Takes_pat_id on Takes using hash(p_id);

create index Pres_id on Prescription using hash(pres_id);

create index Test_name on Test using hash(test_name);
create index Op_name on Operations using hash(op_name);
create index Drug_name on DrugStore using hash(drug_name);



-- USERS
-- drop all priviliges on 

drop role doctors;
drop role drug_store_admin; 
drop role doctor_admin;
drop role patient;
drop role test_admin;
drop role opd_admin;
drop role nurses;
drop role nurse_admin;
drop role hospital_admin;



create role doctors login password 'doctors';
create role drug_store_admin login password 'drug_store_admin';
create role doctor_admin login password 'doctor_admin';
create role patient login password 'patient';
create role test_admin login password 'test_admin';
create role opd_admin login password 'opd_admin';
create role nurses login password 'nurses';
create role nurse_admin login password 'nurse_admin';
create role hospital_admin superuser login password 'hospital_admin';

-- Giving different permissions to roles on different tables

-- doctors

-- GRANT execute on function show_tests to patient;

GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO doctors;
grant INSERT on Prescription, Prescribes, Takes, Buys, OT, ReportTo to doctors;
grant UPDATE on Doctor, worksin to doctors;
grant Select on Prescription, Prescribes, Test, Operations, DrugStore, Patient, Doctor, 
	TakesAppoints, Takes, OT, Buys, Nurse, 
	Worksin, check_nurse_shift to doctors;
Grant delete on ReportTo to doctors;

-- GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO doctors;
GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO patient;
grant INSERT on TakesAppoints, Patient to patient;
grant UPDATE on Patient to patient;
grant Select on Prescription, Prescribes, Department, BelongsTo, Test, Operations, 
	DrugStore, Patient, Doctor, TakesAppoints, Takes, OT, 
	Buys, Producer, drug_prod to patient;


GRANT USAGE, SELECT ON ALL SEQUENCES IN SCHEMA public TO nurses;
grant UPDATE on OT, Takes, Nurse to nurses;
grant Select on Nurse, worksin, OT, Takes, Operations, Test, Buys, DrugStore to nurses;


grant all on Producer, Drug_Prod, DrugStore to drug_store_admin with grant option; 
grant all on Doctor, Department, Belongsto, check_nurse_shift doctor_admin with grant option; 
grant all on Test, Takes to test_admin with grant option; 
grant all on Operations, OT to opd_admin with grant option; 
grant all on Nurse to nurse_admin with grant option;



-- DATA INSERTION PARTY
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

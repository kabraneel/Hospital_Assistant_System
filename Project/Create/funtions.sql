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

create or replace function trigger_reports_insert() returns trigger
language plpgsql
as $$
begin
    update Worksin set Available = 'No' where n_id = new.n_id;
    return new;
end;
$$;

create or replace function trigger_reports_delete() returns trigger
language plpgsql
as $$
begin
    update Worksin set Available = 'Yes' where n_id = old.n_id;
    return old;
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


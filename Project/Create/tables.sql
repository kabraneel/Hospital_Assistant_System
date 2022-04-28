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

ALTER TABLE Department ADD CONSTRAINT FK_DOC FOREIGN KEY (hod) REFERENCES Doctor(Dr_id);

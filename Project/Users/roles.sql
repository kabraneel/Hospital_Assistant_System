
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

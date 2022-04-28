
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


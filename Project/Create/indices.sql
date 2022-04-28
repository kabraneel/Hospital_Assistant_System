
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


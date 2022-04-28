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


create trigger trigger_reports_in 
after insert
on ReportTo
for each row
execute procedure trigger_reports_insert();


create trigger trigger_reports_out
after DELETE
ON ReportTo
for each row
execute procedure trigger_reports_delete();

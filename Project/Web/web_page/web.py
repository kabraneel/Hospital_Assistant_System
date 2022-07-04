import os
from flask import Flask, flash, request, redirect, url_for, render_template
from flask import send_from_directory
from flask import session
import json


# pyimport psycopg2
# from psycopg2 import Error

# try:

#     connection = psycopg2.connect(user="perry", password="123",host="127.0.0.1",port="5432",database="hospital")
#     cur = connection.cursor()
#     cur.execute("SELECT * from fn();")
#     connection.commit()

#     print(cur.fetchall())


# except (Exception, Error) as error:
#     print("Error while connecting to PostgreSQL", error)

# finally:
#     if (connection):
#         cur.close()
#         connection.close()
		# print("PostgreSQL connection is closed")

# import deebeemses

import sqlalchemy
sqlalchemy.__version__ 


from sqlalchemy.engine import create_engine
from sqlalchemy.sql import text
	
class PostgresqlDB:
	def __init__(self,user_name,password,host,port,db_name):
		self.user_name = user_name
		self.password = password
		self.host = host
		self.port = port
		self.db_name = db_name
		self.engine = self.create_db_engine()

	def create_db_engine(self):
		try:
			db_uri = 'postgresql+psycopg2://{user_name}:{password}@{host}:{port}/{db_name}'.format(
					  user_name=self.user_name,password=self.password,
					  host=self.host,db_name=self.db_name,port=self.port)
			return create_engine(db_uri)
		except Exception as err:
			raise RuntimeError(f'Failed to establish connection -- {err}') from err

	def execute_dql_commands(self,stmnt,values=None):
		"""DQL - Data Query Language
		   SQLAlchemy execute query by default as 
			BEGIN
			....
			ROLLBACK
			BEGIN will be added implicitly everytime but if we don't mention commit or rollback eplicitly 
			then rollback will be appended at the end.
		   We can execute only retrieval query with above transaction block.If we try to insert or update data 
		   it will be rolled back.That's why it is necessary to use commit when we are executing 
		   Data Manipulation Langiage(DML) or Data Definition Language(DDL) Query.
		"""
		try:
			with self.engine.connect() as conn:
				if values is not None:
					result = conn.execute(stmnt,values)
				else:
					result = conn.execute(stmnt)
			return result
		except Exception as err:
			print(f'Failed to execute dql commands -- {err}')
	
	def execute_ddl_and_dml_commands(self,stmnt,values=None):
		connection = self.engine.connect()
		trans = connection.begin()
		try:
			if values is not None:
				result = connection.execute(stmnt,values)
			else:
				result = connection.execute(stmnt)
			print(result)
			trans.commit()
			connection.close()
			print('Command executed successfully.')
			return result
		except Exception as err:
			trans.rollback()
			print(f'Failed to execute ddl and dml commands -- {err}')
			return "Error"


USER_NAME = 'kabraneel'
PASSWORD = 'kabraneel'
PORT = 5432
DATABASE_NAME = 'hospital_system_assistant'
HOST = 'localhost'

db = PostgresqlDB(user_name=USER_NAME,
					password=PASSWORD,
					host=HOST,port=PORT,
					db_name=DATABASE_NAME)


def givelist(smp):

	if(len(smp) == 0):
		return "'{}'"

	symptoms = "'{"
	smp = smp.split(', ')
	for i in smp:
		symptoms += '"'+i+'",'
	symptoms = symptoms[:-1]+"}'"
	return symptoms



def row2dict(row):
	d = {}
	for column in row.__table__.columns:
		d[column.name] = str(getattr(row, column.name))

	return d

app = Flask(__name__, template_folder='web_templates', static_folder = 'static')
app.secret_key = "supersecretkey"

#home route.
@app.route('/', methods=['GET', 'POST'])
def upload_file():
	if request.method == 'POST':

		temp = request.form.get('hf')    
		# print(temp)

		if(temp == 'NUR'):
			return redirect(url_for('nurse_page'))

		if(temp == 'PAT'):
			return redirect(url_for('patient_page'))

		if(temp == 'DOC'):
			return redirect(url_for('doctor_page'))


	return render_template('home.html')


@app.route('/doctor', methods=['GET', 'POST'])
def doctor_page():
	if request.method == 'POST':

		temp = request.form.get('df')
		print("temp2")

		temp1 = [temp]

		for t in temp1:

			if(t == 'callnurse'):

				return redirect(url_for('call_nurse'))

			if(t == 'medical'):
				return redirect(url_for('medical_history'))

			if(t == 'putpres'):
				return redirect(url_for('putpres'))

			if(t == 'relnurse'):
				return redirect(url_for('relnurse'))

			if(t == 'shownurse'):
				select_query_stmnt = text("select * from check_nurse_shift;")
				print(select_query_stmnt) 
				result_1 = db.execute_dql_commands(select_query_stmnt)
				
				# toprintdict = {}
				result = []
				temp = []
				temp.extend(["Nurse_ID", "Nurse Name", "Start of Shift", "End of Shift", "Assignment", "isAvaliable"])

				for i in result_1:
					# result += json.dumps(dict([("Procedure ", i.procedure), ("Result ", i.result), ("Date", str(i.date))])) + "\n"
					temp = []
					temp.extend([i[0], i[1], i[2], i[3], i[4], i[5]])
					result.append(temp)

				return render_template("display.html", path = result)

			if(t == 'changepass'):

				return redirect(url_for ("chg_doc"))


	return render_template('doctor.html')

@app.route('/doctor/call_nurse', methods = ['GET', 'POST'])
def call_nurse():

	# print("here")
	if request.method == 'POST':

		X = request.form.getlist('nurseid')
		
		if(len(X) != 3):
			return "<h1>Please go back and fill all tables</h1>"

		n_id        = int(X[0])
		d_id        = int(X[1])
		password    = X[2]

		select_query_stmnt = text("select call_nurse(" + str(d_id) + "," + str(n_id) + ", '" + password +  "');")
		print(select_query_stmnt) 
		result_1 = db.execute_ddl_and_dml_commands(select_query_stmnt)

		
		if result_1 == "Error":
			return render_template("displaystmt.html", path = result_1)

		# toprintdict = {}

		for i in result_1:
			return render_template("displaystmt.html", path = i[0])

	  

	return render_template('callnurse.html')

@app.route('/doctor/release_nurse', methods = ['GET', 'POST'])
def relnurse():

	# print("here")
	if request.method == 'POST':

		X = request.form.getlist('nurseid')
		
		if(len(X) != 3):
			return "<h1>Please go back and fill all tables</h1>"

		n_id        = int(X[0])
		d_id        = int(X[1])
		password    = X[2]

		select_query_stmnt = text("select release_nurse(" + str(d_id) + "," + str(n_id) + ", '" + password +  "');")
		print(select_query_stmnt) 
		result_1 = db.execute_ddl_and_dml_commands(select_query_stmnt)

		
		if result_1 == "Error":
			return render_template("displaystmt.html", path = result_1)

		# toprintdict = {}

		for i in result_1:
			return render_template("displaystmt.html", path = i[0])

	return render_template('relnurse.html')



@app.route('/doctor/medical_history', methods = ['GET', 'POST'])
def medical_history():

	# print("here")
	if request.method == 'POST':

		X = request.form.getlist('nurseid')
		print(X)
		if(len(X) != 1):
			return "<h1>Please go back and select one</h1>"

		p_id  = int(X[0])
		
		select_query_stmnt = text("select * from medical_history(" + str(p_id) + ");")
		print(select_query_stmnt) 
		result_1 = db.execute_dql_commands(select_query_stmnt)
		
		# toprintdict = {}
		result = []
		temp = []
		temp.extend(["Procedure", "Result", "Date"])

		for i in result_1:
			# result += json.dumps(dict([("Procedure ", i.procedure), ("Result ", i.result), ("Date", str(i.date))])) + "\n"
			temp = []
			temp.extend([i.procedure, i.result, i.date])
			result.append(temp)

		return render_template("display.html", path = result)

	return render_template('medical.html')

# @app.route('/doctor/check_nurse_shift', methods = ['GET', 'POST'])
# def check_nurse_shift():

# 	# print("here")
# 	if request.method == 'POST':

# 		# X = request.form.getlist('nurseid')
		# print(X)
		# if(len(X) != 1):
		# 	return "<h1>Please go back and select one</h1>"

		# p_id  = int(X[0])
		
		

	# return render_template('check_nurse_shift.html')

@app.route('/doctor/putpres', methods = ['GET', 'POST'])
def putpres():

	# print("here")
	if request.method == 'POST':

		# X = request.form.getlist('nurseid')

		tests   = givelist(request.form.get('test'))
		ops     = givelist(request.form.get('ops'))
		drugs   = givelist(request.form.get('drugs'))
		p_id    = int(request.form.get('pid'))
		d_id    = int(request.form.get('drid'))
		
		select_query_stmnt = text("select putpres(" + tests + "," + ops + "," + drugs + "," + str(p_id) + "," + str(d_id) + ");")
		print(select_query_stmnt) 
		result_1 = db.execute_ddl_and_dml_commands(select_query_stmnt)
		print(result_1)
		# toprintdict = {}
		result = ""

		if result_1 == "Error":
			return render_template("displaystmt.html", path = result_1)

		for i in result_1:
			# result += json.dumps(dict([("Procedure ", i.procedure), ("Result ", i.result), ("Date", str(i.date))])) + "\n"
			return render_template("displaystmt.html", path = i[0])


	return render_template('putpres.html')


@app.route('/doctor/change_password', methods=['GET', 'POST'])
def chg_doc():
	if request.method == 'POST':
		pid = request.form.get('pid')
		pwd1 = request.form.get('pwd1')
		pwd2 = request.form.get('pwd2')

		query = "SELECT * from change_pass_doc("+pid+",'"+pwd1+"','"+pwd2+"');"
		# print(query)
		q_result = db.execute_ddl_and_dml_commands(text(query))

		if q_result == "Error":
			return render_template("displaystmt.html", path = q_result)

		for i in q_result:
			return render_template("displaystmt.html", path = i[0])

		

	return render_template('chg_doc.html')



# @app.route('/doctor/relnurse', methods = ['GET', 'POST'])
# def putpres():

#     # print("here")
#     if request.method == 'POST':

#         # X = request.form.getlist('nurseid')

#          X = request.form.getlist('nurseid')
		
#         if(len(X) != 3):
#             return "<h1>Please go back and select one</h1>"

#         n_id        = int(X[0])
#         d_id        = int(X[1])
#         password    = X[2]

#         select_query_stmnt = text("select release_nurse(" + str(d_id) + "," + str(n_id) + ", '" + password +  "');")
#         print(select_query_stmnt) 
#         result_1 = db.execute_dql_commands(select_query_stmnt)

		
#         toprintdict = {}

#         for i in result_1:
#             return render_template("display.html", path = i[0])


#     return render_template('putpres.html')

@app.route('/patient', methods=['GET', 'POST'])
def patient_page():
	
	if request.method == 'POST':

		# print(temp)
		choice = request.form.get('pf')
		print(choice)

		if choice[0:3] == 'DOC':
			dept = choice[3:]
			query = text("SELECT * from show_doc('"+str(dept)+"');")
			print(query)
			q_result = db.execute_dql_commands(query)
			result = []
			temp = []
			temp.extend(["ID", "Name", "Years Of Experience", "Age"])
			result.append(temp)


			for i in q_result:
				# result += json.dumps(dict([("name", i.name), ("ID", i.id), ("Years Of Experience", i.yearsofexp), ("Age", i.age)])) + "\n"
				temp = []
				temp.extend([i[1], i[0], i[2], i[3]])
				result.append(temp)
				# print(f'id: {i.id} stud_name: {i.name}')

			print(result)
			return render_template('display.html',path = result)


		
		elif choice[0:3] == 'TES':
			tests = choice[3:]
			query = text("SELECT * from show_tests();")
			print(query)
			q_result = db.execute_dql_commands(query)
			result = []
			temp = []
			temp.extend(["Test Name", "Cost"])
			result.append(temp)

			# print(q_result[0][0], q_result[0][1])
			for i in q_result:
				# print(i[0], i[1])
				temp = []
				temp.extend([i[0], i[1]])
				result.append(temp)

			return render_template('display.html',path = result)

		elif choice[0:3] == 'NEA':

			return redirect(url_for('new_app_page'))

		elif choice[0:3] == 'APP':
			return redirect(url_for('app_page'))

		elif choice[0:3] == "PRE":
			return redirect(url_for('get_pres'))

		elif choice[0:3] == "MAK":
			return redirect(url_for('make_bill'))

		elif choice[0:3] == "CHG":
			return redirect(url_for('chg_pat'))

	return render_template('patient.html')

@app.route('/patient/new_appointment', methods=['GET', 'POST'])
def new_app_page():
	if request.method == 'POST':

		did = request.form.get('dname')
		name = request.form.get('fname')
		age = request.form.get('age')
		smp = request.form.get('smp')
		sex = request.form.get('sex')
		weight = request.form.get('wgt')
		height = request.form.get('hgt')
		# print(did, name, age, smp, sex, weight, height)

		symptoms = "'{"
		smp = smp.split(', ')
		if (smp[0] != ''):
			for i in smp:
				symptoms += '"'+i+'",'

			symptoms = symptoms[:-1]+"}'"
		else:
			symptoms += "}'"

		query = "SELECT * from newappointment("+did+ ",'"+ name+ "',"+ age+ ","+ symptoms+ ",'"+ sex+ "',"+ weight+ ","+ height+");"
		
		print(query)
		q_result = db.execute_ddl_and_dml_commands(text(query))

		if q_result == "Error":
			return render_template("displaystmt.html", path = q_result)

		result = []
		temp = []
		temp.extend(["New Patient ID", "New Password"])
		result.append(temp)

		for i in q_result:
			# result += json.dumps(dict([("New Patient ID ", i.patient_id), ("NewPass ", i.newpassword)])) + "\n"
			temp = []
			temp.extend([i[0], i[1]])
			result.append(temp)
		
		return render_template("display.html", path = result)



	return render_template('new_app_page.html')

@app.route('/patient/appointment', methods=['GET', 'POST'])
def app_page():
	if request.method == 'POST':

		did = request.form.get('dname')
		smp = request.form.get('smp')
		pid = request.form.get('pid')
		pwd = request.form.get('pwd')
		result = ""

		# print(did, name, age, smp, sex, weight, height)

		symptoms = "'{"
		smp = smp.split(', ')
		if (smp[0] != ''):
			for i in smp:
				symptoms += '"'+i+'",'

			symptoms = symptoms[:-1]+"}'"
		else:
			symptoms += "}'"

		query = 'SELECT * from appointment('+did+ ','+ symptoms+ ','+ pid+ ",'"+ pwd+ "');"
		
		print(query)
		q_result = db.execute_ddl_and_dml_commands(text(query))

		if q_result == "Error":
			return render_template("displaystmt.html", path = q_result)

		for i in q_result:
			return render_template("displaystmt.html", path = i[0])


	return render_template('app_page.html')

@app.route('/patient/make_bill', methods=['GET', 'POST'])
def make_bill():
	if request.method == 'POST':

		pres_id = request.form.get('presid')
		pid = request.form.get('pid')
		pwd = request.form.get('pwd')


		query = "SELECT * from makeBill("+pres_id+","+pid+",'"+pwd+"');"
		print(query)
		q_result = db.execute_dql_commands(text(query))

		# if q_result == "Error":
		# 	return render_template("displaystmt.html", path = q_result)

		result = []
		temp = []
		temp.extend(["Service Provided", "Cost", "Date of service"])
		result.append(temp)

		for i in q_result:
			# result += json.dumps(dict([("New Patient ID ", i.patient_id), ("NewPass ", i.newpassword)])) + "\n"
			temp = []
			temp.extend([i[0], i[1], i[2]])
			result.append(temp)
		
		return render_template("display.html", path = result)



	return render_template('makeBill_page.html')

@app.route('/patient/get_prescriptions', methods=['GET', 'POST'])
def get_pres():
	if request.method == 'POST':
		pid = request.form.get('pid')
		pwd = request.form.get('pwd')


		query = "SELECT * from get_all_pres("+pid+",'"+pwd+"');"
		print(query)
		q_result = db.execute_dql_commands(text(query))

		# if q_result == "Error":
		# 	return render_template("displaystmt.html", path = q_result)

		result = []
		temp = []
		temp.extend(["Prescription IDs"])
		result.append(temp)

		for i in q_result:
			# result += json.dumps(dict([("New Patient ID ", i.patient_id), ("NewPass ", i.newpassword)])) + "\n"
			temp = []
			temp.extend([i[0]])
			result.append(temp)
		
		return render_template("display.html", path = result)

	return render_template('get_pres_page.html')

@app.route('/patient/change_password', methods=['GET', 'POST'])
def chg_pat():
	if request.method == 'POST':
		pid = request.form.get('pid')
		pwd1 = request.form.get('pwd1')
		pwd2 = request.form.get('pwd2')

		query = "SELECT * from change_pass_patient("+pid+",'"+pwd1+"','"+pwd2+"');"
		# print(query)
		q_result = db.execute_ddl_and_dml_commands(text(query))

		if q_result == "Error":
			return render_template("displaystmt.html", path = q_result)

		for i in q_result:
			return render_template("displaystmt.html", path = i[0])

		

	return render_template('chg_pat.html')


@app.route('/nurse', methods=['GET', 'POST'])
def nurse_page():
	if request.method == 'POST':

		temp = request.form.get('nf')
		# print("temp2")

		if temp == 'TES':
			return redirect(url_for('test_res'))
		elif temp == 'OPT':
			return redirect(url_for('op_res'))

		elif temp=="CHG":
			return redirect(url_for('chg_nur'))



	return render_template('nurse_page.html')

@app.route('/nurse/test_results', methods=['GET', 'POST'])
def test_res():
	if request.method == 'POST':

		nid = request.form.get('nid')
		pwd = request.form.get('pwd')
		pid = request.form.get('pid')
		tid = request.form.get('tid')
		presid = request.form.get('presid')
		res = request.form.get('res')

		res = res.split(', ')
		res1 = "'{"
		if res[0] == '':
			res1 += "}'"
		else: 	
			for i in res:
				res1 += '"'+i+'",'

			res1 = res1[:-1]+"}'"

		# print(res1)
		# print(nid, pwd, pid, tid, presid, res1)
		query = "SELECT * from enter_test_results ("+nid+",'"+pwd+"',"+tid+","+presid+","+res1+");"
		print(query)

		q_result = db.execute_ddl_and_dml_commands(text(query))

		if q_result == "Error":
			return render_template("displaystmt.html", path = q_result)

		for i in q_result:
			return render_template("displaystmt.html", path = i[0])



	return render_template('test_page.html')

@app.route('/nurse/op_results', methods=['GET', 'POST'])
def op_res():
	if request.method == 'POST':

		nid = request.form.get('nid')
		pwd = request.form.get('pwd')
		pid = request.form.get('pid')
		oid = request.form.get('oid')
		presid = request.form.get('presid')
		res = request.form.get('res')

		res = res.split(', ')
		res1 = "'{"
		if res[0] == '':
			res1 += "}'"
		else: 	
			for i in res:
				res1 += '"'+i+'",'

			res1 = res1[:-1]+"}'"

		query = "SELECT * from enter_test_results ("+nid+",'"+pwd+"',"+oid+","+presid+","+res1+");"
		print(query)

		q_result = db.execute_ddl_and_dml_commands(text(query))

		if q_result == "Error":
			return render_template("displaystmt.html", path = q_result)

		for i in q_result:
			return render_template("displaystmt.html", path = i[0])



	return render_template('op_page.html')

@app.route('/nurse/change_password', methods=['GET', 'POST'])
def chg_nur():
	if request.method == 'POST':
		pid = request.form.get('pid')
		pwd1 = request.form.get('pwd1')
		pwd2 = request.form.get('pwd2')

		query = "SELECT * from change_pass_nurse("+pid+",'"+pwd1+"','"+pwd2+"');"
		# print(query)
		q_result = db.execute_ddl_and_dml_commands(text(query))

		if q_result == "Error":
			return render_template("displaystmt.html", path = q_result)

		for i in q_result:
			return render_template("displaystmt.html", path = i[0])

		

	return render_template('chg_nur.html')


app.run(host="0.0.0.0", port=5000,debug=True,threaded=True)
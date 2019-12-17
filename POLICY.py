import mysql.connector
from mysql.connector import Error
con=mysql.connector.connect(host="localhost",username="chandra",password="@chennai1",database='moneesha')
cur=con.cursor()
try:
	#truncate before inserting
	tr='''truncate table policy;'''
	cur.execute(tr)
	#Inserting data from CLAIMS_Transaction Table
	in_qry='''INSERT ignore INTO POLICY(PolicyId,PolicyNumber,PolicYHolderName,PolicyStartDate,PolicyExpirationDate,PolicyType)select PolicyId,PolicyNumber,PolicYHolderName,PolicyStartDate,PolicyExpirationDate,PolicyType from claims_transaction;'''
	#commit changes
	cur.execute(in_qry)
	con.commit()
except Exception as e:
	print("Error : ", e)
	con.rollback()

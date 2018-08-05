from sqlalchemy import create_engine
import sqlalchemy.sql
import pandas as pd
import pymysql

engine = create_engine('mysql+pymysql://shiningsunnyday:MasterPower@aifoodmysql.culbrnd5oifv.us-west-1.rds.amazonaws.com:3306/aiFoodRDS')
connection = engine.connect()
print(engine.table_names())

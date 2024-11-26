import os
class Config:
    # Using the connection string that worked for you
    SQLALCHEMY_DATABASE_URI = (
        'mssql+pyodbc:///?odbc_connect='
        'DRIVER={ODBC Driver 17 for SQL Server};'
        'SERVER= DESKTOP-9LR8JQK\TEW_SQLEXPRESS;'
        'DATABASE=sales;'
        'Trusted_Connection=yes;'
    )
    SQLALCHEMY_TRACK_MODIFICATIONS = False
 #DESKTOP-STF9ONU\\SQLEXPRESS;
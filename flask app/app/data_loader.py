import pyodbc
import pandas as pd
from app.config import Config


loan_data = pd.read_csv("database/loan_data.csv")
loan_df = loan_data[:5]

def load_loan_data():
    return loan_data


def load_data():
    connection_string = Config.SQLALCHEMY_DATABASE_URI.replace('mssql+pyodbc:///?odbc_connect=', '')

    conn = pyodbc.connect(connection_string)

    # Define Queries
    Product_query = "SELECT * FROM Product"
    Customer_query = "SELECT * FROM Customer"
    Order_query = "SELECT * FROM [Order]"
    OrderItem_query =  "SELECT * FROM OrderItem"
    Supplier_query = "SELECT * FROM Supplier"

    # Fetch as Pandas Dataframes
    Product_df = pd.read_sql(Product_query, conn)
    Customer_df = pd.read_sql(Customer_query, conn)
    Order_df = pd.read_sql(Order_query, conn)
    OrderItem_df = pd.read_sql(OrderItem_query, conn)
    Supplier_df = pd.read_sql(Supplier_query, conn)

    Product_df.rename(columns={"Id" : "ProductId"}, inplace=True)
    Order_df.rename(columns={"Id" : "OrderId"}, inplace=True)
    Customer_df.rename(columns={"Id" : "CustomerId"}, inplace=True)
    OrderItem_df.rename(columns={"Id" : "OrderItemId"}, inplace=True)
    Supplier_df.rename(columns={"Id" : "SupplierId"}, inplace=True)

    # Merge Customer and Order data
    Order_Customer_df = pd.merge(Order_df, Customer_df, left_on="CustomerId", right_on="CustomerId", how = 'inner')

    # Merge Oder Customer with Order Item
    Order_Customer_Item_df = pd.merge(Order_Customer_df, OrderItem_df, left_on="OrderId", right_on="OrderId", how='inner') 

     # Merge Order_Customer_Item_df with Product data
    Order_Customer_Item_Product_df = pd.merge(Order_Customer_Item_df, Product_df, left_on='ProductId', right_on='ProductId', how='inner')

    # Optionally, if you want to include Supplier data
    Order_Customer_Item_Product_Supplier_df = pd.merge(Order_Customer_Item_Product_df, Supplier_df, left_on='SupplierId', right_on='SupplierId', how='inner')

    # Close Connection
    conn.close()

    # print success message
    print("Data frames loaded successfult!")

    Product_df = Product_df[:5]
    Customer_df = Customer_df[:5]
    Order_df = Order_df[:5]
    OrderItem_df = OrderItem_df[:5]
    Supplier_df = Supplier_df[:5]

    return loan_df, Customer_df, Order_df, OrderItem_df, Product_df, Supplier_df







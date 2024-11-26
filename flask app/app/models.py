from app import db

class Customer(db.Model):
    __tablename__ = 'customer'

    id = db.Column("Id", db.Integer, primary_key=True)  # Keep the Id as is
    first_name = db.Column("FirstName", db.String(50), nullable=False)  # Match the database column name
    last_name = db.Column("LastName", db.String(50), nullable=False)    # Match the database column name
    city = db.Column("City", db.String(50), nullable=True)               # Match the database column name
    country = db.Column("Country", db.String(50), nullable=True)         # Match the database column name
    phone = db.Column("Phone", db.String(20), nullable=True)             # Match the database column name

    def __repr__(self):
        return f'<Customer {self.first_name} {self.last_name}>'



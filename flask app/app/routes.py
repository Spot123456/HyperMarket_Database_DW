from flask import Blueprint, render_template, request, redirect, url_for
from app import db
from app.models import Customer
from app.forms import CustomerForm  # Adjusted to use the simple form class
from app.data_loader import loan_data, load_loan_data, load_data


main = Blueprint('main', __name__)

@main.route('/', methods=['GET', 'POST'])
def home():
    if request.method == 'POST':
        # Retrieve form data

        form = CustomerForm()

        # Create a new Customer instance
        new_customer = Customer(
            first_name=form.first_name,
            last_name=form.last_name,
            city=form.city,
            country=form.country,
            phone=form.phone
        )
        db.session.add(new_customer)  # Add to session
        db.session.commit()  # Commit the session to save changes
        return redirect(url_for('main.home'))  # Redirect to home after adding

    return render_template('home.html')  # Render home template

@main.route('/dataframes')
def display_dataframes():
    # Load Dataframes From Database
    loan_df, Customer_df, Order_df, OrderItem_df, Product_df, Supplier_df = load_data()

    #Convert Dataframes to HTML tables
    loan_html = loan_df.to_html(classes = 'data', header = True, index = False)
    customers_html = Customer_df.to_html(classes = 'data', header = True, index = False)
    orders_html = Order_df.to_html(classes = 'data', header = True, index = False)
    order_items_html = OrderItem_df.to_html(classes = 'data', header = True, index = False)
    supplier_html = Supplier_df.to_html(classes = 'data', header = True, index = False)
    products_html = Product_df.to_html(classes = 'data', header = True, index = False)

    return render_template('dataframes.html', loan = loan_html, customers = customers_html,
                           orders = orders_html, order_items = order_items_html, 
                           suppliers = supplier_html, products = products_html)
from flask import Flask, request, render_template, url_for, session, redirect
from models import *
from dbconnect import connection
from decimal import Decimal

app = Flask(__name__)



@app.route("/", methods = ['GET','POST'])
@app.route("/index", methods = ['GET','POST'])
def index():
    if 'username' in session:
        return "Logged in as "+session['username']
    return render_template("index.html")


@app.route("/login", methods = ['GET','POST'])
def login_page():
    return render_template("login_page.html")

@app.route("/login_Action", methods = ['GET','POST'])
def logged_in():
    if request.method == 'POST':
        result = request.form
        if result['loginType'] == "customer":
            cur, conn = connection()
            query = "select cust_id,passwd from zztemp_customers where cust_id like '"+result['username'].lower()+"'"
            #return query
            cur.execute(query)
            res = cur.fetchall()
            #return res[0][0]+" and "+res[0][1]
            if str(res[0][0]) == str(result['username']) and str(res[0][1]) == str(result['password']):
                return render_template("logged_in.html", result = result)
            else:
                return "<h2>Sorry, "+result['username']+" doesn't seem to exist or the password is wrong</h2>"
        elif result['loginType'] == "employee":
            cur, conn = connection()
            query = "select emp_id,passwd from zztemp_employees where emp_id ='"+result['username'].lower()+"'"
            #return query
            cur.execute(query)
            res = cur.fetchall()
            if str(res[0][0]) == str(result['username']) and str(res[0][1]) == str(result['password']):
                return render_template("logged_in.html", result = result)
            else:
                return "<h2>Sorry, "+result['username']+" doesn't seem to exist or the password is wrong</h2>"
    else:
        return "USED METHOD GET - Not a good idea"




@app.route("/registration_page")
def registration_page():
    return render_template("registration_page.html")

@app.route("/register", methods = ['GET','POST'])
def register():
    customer_name = request.form['customer_name']
    customer_id = request.form['username']
    customer_password = request.form['password']
    customer_phone = request.form['phone_number']
    try:
        cur, conn = connection()
        query = "insert into zztemp_customers (cust_id, cust_name, phone, DateCreated, passwd) values('%s','%s','%s',now(),'%s')" %(customer_id, customer_name, customer_phone, customer_password)
        #return query
        cur.execute(query)
        conn.commit()
        conn.close()
    except:
        conn.rollback()
        conn.close()
        print("Unexpected error:", sys.exc_info()[0])
        return "<h3>Sorry Error occured. Please try after sometime<h3>"
    return render_template("/login_page.html")




@app.route("/details_req")
def details_required():
    return render_template("checkout_details.html", result = '')

@app.route("/checkout_details_processing", methods =['POST'])
def checkout_details_processing():
    cur, conn = connection()
    if str(request.form['checkout_id']) == '0':
        if str(request.form['store_id']) != '0' and str(request.form['item_id']) != '0':
            cur.execute("select a.checkout_id, b.store_id, a.item_id from zztemp_checkout_item_details a, zztemp_checkout b where b.store_id = %s and a.item_id = %s and b.cust_id = '%s' and a.checkout_id = b.checkout_id" %(str(request.form['store_id']), str(request.form['item_id']), str(request.form['cust_id'])))
            result = cur.fetchall()
            return render_template("view_checkout_id.html", result = result)
        else:
            return render_template("checkout_details.html", result = 'Please enter either checkout_id or the other details')
    elif str(request.form['checkout_id']) != '0':
        query = "select a.checkout_id, b.store_id, a.item_id, a.quantity,c.price from zztemp_checkout_item_details a, zztemp_checkout b, zztemp_items c where a.checkout_id = %s and b.cust_id = '%s' and a.checkout_id = b.checkout_id and c.item_id = a.item_id" %(str(request.form['checkout_id']), str(request.form['cust_id']))
        #return query
        cur.execute(query)
        result = cur.fetchall()
        return render_template("view_checkout_id_results.html", result = result)
    else:
        return "checkout_id = "+str(request.form['checkout_id'])

@app.route("/list")
def list():
    return render_template("list.html")

@app.route("/list/items",methods=['GET','POST'])
def list_from_items():
    cur, conn = connection()
    query = ""
    print(str(request.form))
    #return "something "+str(request.form['value'])
    if str(request.form['option']) == str("item_id_based"):
        #return request.form['value']
        item_id = request.form['value']
        query = "select * from zztemp_items where item_id = "+str(item_id)
    elif request.form["option"] == "brand_based":
        brand = str(request.form['value'])
        query = "select * from zztemp_items where brand like '%"+str(brand)+"%'"
    elif request.form["option"] == "price_below":
        price_below = str(request.form['value'])
        query = "select * from zztemp_items where price < "+str(price_below)
    elif request.form["option"] == "price_above":
        price_above = str(request.form['value'])
        query = "select * from zztemp_items where price > "+str(price_above)
    elif request.form["option"] == "list_all_items":
        query = "select * from zztemp_items"
    elif request.form["option"] == "inventory_list":
        query = "select a.item_id,b.brand,b.description,sum(quantity_of_items_available) from zztemp_inventory a,zztemp_items b where a.item_id = b.item_id group by a.item_id,b.brand,b.description"
    cur.execute(query)
    result = cur.fetchall()
    conn.close()
    #return "result is "+ str(result)
    return render_template("view_items.html",result = result)

@app.route("/restock")
def restock():
    try:
        cur, conn = connection()
        query = "update zztemp_inventory set quantity_of_items_available = quantity_of_items_available + 30 where 1 = 1"
        cur.execute(query)
        conn.commit()
        return render_template("list.html")
    except:
        conn.rollback()
        conn.close()
        print("Unexpected error:", sys.exc_info()[0])
        return "<h3>Sorry Error occured. Please try again after sometime<h3>"


@app.route("/checkout_page")
def checkout_page():
    return render_template("checkout_page.html")

@app.route("/checkout_calculation", methods=['GET','POST'])
def checkout_calculation():
    cur, conn = connection()
    query = ""
    dictionary = {}
    if request.form['emp_id'] and request.form['store_id']:
        print("emp_id and store_id - present")
        query = "select emp_id from zztemp_employees where emp_id='"+str(request.form['emp_id'])+"'"
        cur.execute(query)
        res = cur.fetchall()
        query = "select store_id from zztemp_store where store_id='"+str(request.form['store_id'])+"'"
        cur.execute(query)
        res1 = cur.fetchall()
        if request.form['emp_id'] == str(res[0][0]) and request.form['store_id'] == str(res1[0][0]):
            req = request.form
            #return str(req)
            for key,value in req.items():
                dictionary[key] = value
            dictionary.pop('emp_id', None)
            dictionary.pop('cust_id', None)
            dictionary.pop('store_id', None)
            #return str(dictionary)
            subtotal = Decimal(0.00)
            #price = {}
            final_dict = {}
            final_dict[dictionary['item_id_1']] = dictionary['quantity_1']
            final_dict[dictionary['item_id_2']] = dictionary['quantity_2']
            final_dict[dictionary['item_id_3']] = dictionary['quantity_3']
            final_dict[dictionary['item_id_4']] = dictionary['quantity_4']
            final_dict[dictionary['item_id_5']] = dictionary['quantity_5']
            final_dict[dictionary['item_id_6']] = dictionary['quantity_6']
            final_dict[dictionary['item_id_7']] = dictionary['quantity_7']
            final_dict[dictionary['item_id_8']] = dictionary['quantity_8']
            final_dict[dictionary['item_id_9']] = dictionary['quantity_9']
            final_dict[dictionary['item_id_10']] = dictionary['quantity_10']
            final_dict[dictionary['item_id_11']] = dictionary['quantity_11']
            final_dict[dictionary['item_id_12']] = dictionary['quantity_12']
            final_dict[dictionary['item_id_13']] = dictionary['quantity_13']
            final_dict[dictionary['item_id_14']] = dictionary['quantity_14']
            final_dict[dictionary['item_id_15']] = dictionary['quantity_15']
            final_dict[dictionary['item_id_16']] = dictionary['quantity_16']
            final_dict[dictionary['item_id_17']] = dictionary['quantity_17']
            final_dict[dictionary['item_id_18']] = dictionary['quantity_18']
            final_dict[dictionary['item_id_19']] = dictionary['quantity_19']
            #return str(final_dict)
            for itemid,quantity in final_dict.items():
                if int(quantity) == 0:
                    pass
                else:
                    query = "select price from zztemp_items where item_id = "+str(itemid)
                    cur.execute(query)
                    result = cur.fetchone()
                    price = Decimal(result[0])
                    tot_per_item = Decimal(price * int(quantity))
                    subtotal = Decimal(subtotal + tot_per_item)
            try:
                cur.execute("insert into zztemp_checkout (cust_id, dateofcheckout, store_id, subtotal, emp_id) values('%s',now(),'%s','%s','%s') returning checkout_id" %(request.form['cust_id'],request.form['store_id'],subtotal,request.form['emp_id']))
            except:
                conn.rollback()
                conn.close()
                print("Unexpected error:", sys.exc_info()[0])
                return "<h3>Sorry Error occured. Please try after sometime<h3>"
            result_checkoutid = cur.fetchone()
            conn.commit()
            checkout_id_var = int(result_checkoutid[0])
            for itemid, quantity in final_dict.items():
                if int(quantity) == 0:
                    pass
                else:
                    try:
                        cur.execute("insert into zztemp_checkout_item_details (checkout_id, quantity, item_id) values('%s','%s','%s')" %(checkout_id_var, quantity, itemid))
                        if request.form['cust_id']:
                            cur.execute("update zztemp_customers set datelasttrans = now() where cust_id ='"+str(request.form['cust_id'])+"'")
                        cur.execute("update zztemp_inventory set quantity_of_items_available = quantity_of_items_available - '%s' where store_id = '%s' and item_id = '%s'" %(quantity, request.form['store_id'], itemid))
                    except:
                        conn.rollback()
                        conn.close()
                        print("Unexpected error:", sys.exc_info()[0])
                        return "<h3>Sorry Error occured. Please try after sometime<h3>"
            conn.commit()
            return render_template("checkout_done.html", result = checkout_id_var)
    else:
        print("Checkout page")
        return render_template("checkout_page.html")
    return render_template("checkout_page.html")


if __name__ == "__main__":
    app.run(debug = True)

CREATE TABLE zztemp_store
(
  store_id serial NOT NULL,
  address text,
  CONSTRAINT zztemp_store_pkey PRIMARY KEY (store_id)
)
WITH (
  OIDS=FALSE
);
--ALTER TABLE zztemp_store
  --OWNER TO flask_user;

insert into zztemp_store values (1, '1000 NE Sam Walton Ln, Lee''s Summit, MO 64086');
insert into zztemp_store values (2, '10300 E Highway 350, Raytown, MO 64138');
insert into zztemp_store values (3, '2015 W Foxwood Dr, Raymore, MO 64083');
insert into zztemp_store values (4, '4000 S Bolger Rd, Independence, MO 64055');
insert into zztemp_store values (5, '11701 Metcalf Ave, Overland Park, KS 66210');


CREATE TABLE zztemp_paytype
(
  paytype numeric(1,0) NOT NULL,
  description character varying,
  CONSTRAINT zztemp_paytype_pkey PRIMARY KEY (paytype),
  CONSTRAINT zztemp_paytype_check CHECK (paytype = 0::numeric OR paytype = 1::numeric)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE zztemp_paytype
  --OWNER TO flask_user;

insert into zztemp_paytype values (0, 'Part Time Pay');
insert into zztemp_paytype values (1, 'Full Time Pay');

CREATE TABLE zztemp_items
(
  item_id serial NOT NULL,
  brand character varying,
  description character varying,
  price numeric(10,2) NOT NULL,
  shapeofproduct character varying,
  sizeofproduct character varying,
  upc numeric(9,0) NOT NULL,
  weight numeric,
  item_group character varying,
  CONSTRAINT zztemp_items_pkey PRIMARY KEY (item_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE zztemp_items
  --OWNER TO flask_user;

insert into zztemp_items (brand, description, item_group, price, shapeofproduct, sizeofproduct, upc, weight) 
  values ('Google', 'Pixel', 'cell phone', 649.00, 'Bar', '143.8 x 69.5 x 8.5 mm', 949239308, 143);
  
insert into zztemp_items (brand, description, item_group, price, shapeofproduct, sizeofproduct, upc, weight) 
  values ('Apple', 'iPhone 5S', 'cell phone', 258.00, 'Bar', '123.8 x 58.6 x 7.6 mm', 949229308, 112);
  
insert into zztemp_items (brand, description, item_group, price, shapeofproduct, sizeofproduct, upc, weight) 
  values ('Apple', 'iPhone 7 Plus', 'cell phone', 769.00, 'Bar', '158.2 x 77.9 x 7.3 mm', 949223308, 188);
  
insert into zztemp_items (brand, description, item_group, price, shapeofproduct, sizeofproduct, upc, weight) 
  values ('ZTE', 'Axon 7', 'cell phone', 349.98, 'Bar', '151.7 x 75 x 7.9 mm', 949739308, 175);  


CREATE TABLE zztemp_inventory
(
  store_id integer NOT NULL,
  item_id integer NOT NULL,
  quantity_of_items_available numeric,
  CONSTRAINT zztemp_inventory_pkey PRIMARY KEY (store_id, item_id),
  CONSTRAINT zztemp_inventory_item_id_fkey FOREIGN KEY (item_id)
      REFERENCES zztemp_items (item_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT zztemp_inventory_store_id_fkey FOREIGN KEY (store_id)
      REFERENCES zztemp_store (store_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE zztemp_inventory
  --OWNER TO flask_user;

insert into zztemp_inventory values (1, 1, 10);
insert into zztemp_inventory values (2, 1, 10);
insert into zztemp_inventory values (3, 1, 10);
insert into zztemp_inventory values (4, 1, 10);
insert into zztemp_inventory values (5, 1, 10);

insert into zztemp_inventory values (1, 2, 10);
insert into zztemp_inventory values (2, 2, 10);
insert into zztemp_inventory values (3, 2, 10);
insert into zztemp_inventory values (4, 2, 10);
insert into zztemp_inventory values (5, 2, 10);


insert into zztemp_inventory values (1, 3, 10);
insert into zztemp_inventory values (2, 3, 10);
insert into zztemp_inventory values (3, 3, 10);
insert into zztemp_inventory values (4, 3, 10);
insert into zztemp_inventory values (5, 3, 10);


insert into zztemp_inventory values (1, 4, 10);
insert into zztemp_inventory values (2, 4, 10);
insert into zztemp_inventory values (3, 4, 10);
insert into zztemp_inventory values (4, 4, 10);
insert into zztemp_inventory values (5, 4, 10);


CREATE TABLE zztemp_employees
(
  emp_id character varying NOT NULL,
  emp_name character varying NOT NULL,
  ssn numeric(9,0) NOT NULL,
  phone numeric(10,0),
  store_id integer,
  dateofemploy date,
  address text,
  paytype numeric(1,0) NOT NULL,
  pay numeric(10,2),
  quitdate date,
  manager_id numeric,
  passwd character varying,
  CONSTRAINT zztemp_employees_pkey PRIMARY KEY (emp_id),
  CONSTRAINT zztemp_employees_paytype_fkey FOREIGN KEY (paytype)
      REFERENCES zztemp_paytype (paytype) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT zztemp_employees_store_id_fkey FOREIGN KEY (store_id)
      REFERENCES zztemp_store (store_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT zztemp_employees_ssn_key UNIQUE (ssn)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE zztemp_employees
  --OWNER TO flask_user;

insert into zztemp_employees (emp_id, emp_name, ssn, phone, store_id, dateofemploy, address, paytype, pay, quitdate, manager_id, passwd)
  values ('emp1', 'Alison', 920382683, 8163540203, 1, '09-09-2010', '711-2880 Nulla St., Missouri 64081', 0, 2400, '09-20-2016', 'emp2', 'password');

insert into zztemp_employees (emp_id, emp_name, ssn, phone, store_id, dateofemploy, address, paytype, pay, passwd)
  values ('emp2', 'Andrea', 920332683, 8155956203, 1, '09-09-2005', 'P.O. Box 283 8562 Fusce Rd., Missouri 64081', 1, 12400, 'password');

insert into zztemp_employees (emp_id, emp_name, ssn, phone, store_id, dateofemploy, address, paytype, pay, quitdate, manager_id, passwd)
  values ('emp3', 'Benjamin', 928782683, 8163945203, 2, '09-09-2010', '606-3727 Ullamcorper. Street, Missouri 64081', 0, 240, '09-20-2016', 'emp2', 'password');

insert into zztemp_employees (emp_id, emp_name, ssn, phone, store_id, dateofemploy, address, paytype, pay, quitdate, manager_id, passwd)
  values ('emp4', 'Brian', 920385683, 8163940287, 3, '09-09-2010', 'Ap #867-859 Sit Rd., Missouri 64081', 0, 240, '09-20-2016', 'emp2', 'password');

insert into zztemp_employees (emp_id, emp_name, ssn, phone, store_id, dateofemploy, address, paytype, pay, quitdate, manager_id, passwd)
  values ('emp5', 'Christian', 920982683, 8169940203, 4, '09-09-2010', '7292 Dictum Av., Missouri 64081', 0, 240, '09-20-2016', 'emp2', 'password');

insert into zztemp_employees (emp_id, emp_name, ssn, phone, store_id, dateofemploy, address, paytype, pay, quitdate, manager_id, passwd)
  values ('emp6', 'David', 920382634, 8163945603, 5, '09-09-2010', 'Ap #651-8679 Sodales Av., Missouri 64081', 1, 10000, '09-20-2016', 'emp2', 'password');

update zztemp_employees set quitdate = null where 1=1;


CREATE TABLE zztemp_customers
(
  cust_id character varying NOT NULL,
  cust_name character varying NOT NULL,
  phone numeric(10,0),
  datelasttrans date,
  datecreated date NOT NULL,
  passwd character varying,
  CONSTRAINT zztemp_customers_pkey PRIMARY KEY (cust_id)
)
WITH (
  OIDS=FALSE
);
ALTER TABLE zztemp_customers
  --OWNER TO flask_user;


insert into zztemp_customers (cust_id, cust_name, phone, datecreated, passwd)
 values ('cust1', 'Chloe', 8169304566, '08-21-2010', 'password');
 
 insert into zztemp_customers (cust_id, cust_name, phone, datecreated, passwd)
 values ('cust2', 'Brian', 8169308736, '04-21-2008', 'password');
 
 insert into zztemp_customers (cust_id, cust_name, phone, datecreated, passwd)
 values ('cust3', 'Ball', 8169304536, '03-25-2007', 'password');
 
 insert into zztemp_customers (cust_id, cust_name, phone, datecreated, passwd)
 values ('cust4', 'Brown', 8169338836, '04-26-2004', 'password');
 
 insert into zztemp_customers (cust_id, cust_name, phone, datecreated, passwd)
 values ('cust5', 'Anne', 8169308736, now(), 'password');


create sequence zztemp_checkout_checkout_id_seq;

CREATE TABLE zztemp_checkout
(
  checkout_id numeric NOT NULL DEFAULT nextval('zztemp_checkout_checkout_id_seq'::regclass),
  cust_id character varying NOT NULL,
  dateofcheckout date NOT NULL,
  store_id integer,
  subtotal numeric(10,2) NOT NULL,
  emp_id character varying NOT NULL,
  CONSTRAINT zztemp_checkout_pkey PRIMARY KEY (checkout_id),
  CONSTRAINT zztemp_checkout_emp_id_fkey FOREIGN KEY (emp_id)
      REFERENCES zztemp_employees (emp_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT zztemp_checkout_store_id_fkey FOREIGN KEY (store_id)
      REFERENCES zztemp_store (store_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE zztemp_checkout
  --OWNER TO flask_user; 

alter sequence zztemp_checkout_checkout_id_seq restart;


create sequence zztemp_checkout_item_details_sl_no_seq;

CREATE TABLE zztemp_checkout_item_details
(
  checkout_id numeric NOT NULL,
  quantity numeric NOT NULL,
  item_id integer NOT NULL,
  sl_no integer NOT NULL DEFAULT nextval('zztemp_checkout_item_details_sl_no_seq'::regclass),
  CONSTRAINT zztemp_checkout_item_details_pkey PRIMARY KEY (sl_no),
  CONSTRAINT zztemp_checkoutaction_checkout_id_fkey FOREIGN KEY (checkout_id)
      REFERENCES zztemp_checkout (checkout_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION,
  CONSTRAINT zztemp_checkoutaction_item_id_fkey FOREIGN KEY (item_id)
      REFERENCES zztemp_items (item_id) MATCH SIMPLE
      ON UPDATE NO ACTION ON DELETE NO ACTION
)
WITH (
  OIDS=FALSE
);
ALTER TABLE zztemp_checkout_item_details
  --OWNER TO flask_user; 

alter sequence zztemp_checkout_item_details_sl_no_seq restart;




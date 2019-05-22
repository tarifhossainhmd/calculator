--create customer table
drop table customers_backup;
drop table customers;
drop table address;
SET SERVEROUTPUT ON;

CREATE TABLE address(
	id number(5) PRIMARY KEY,
	city varchar(60), 
	post varchar(60), 
	upazilla varchar(60), 
	district varchar(60)
);

INSERT INTO address values(1, 'Dhaka', 'Dhaka', 'Rampura', 'Dhaka');
INSERT INTO address values(2, 'Dinajpur', 'Dinajpur', 'Dinajpur Sadar', 'Dinajpur');
INSERT INTO address values(3, 'Pirojpur', 'Pirojpur Sadar', 'Pirojpur', 'Pirojpur');

CREATE TABLE customers(
	ID number(5) PRIMARY KEY,
	NAME varchar(60) NOT NULL, 
	AGE number(3) default 0, 
	ADDRESS varchar(255), 
	SALARY number(5),
	address_id number(5),
	CONSTRAINT FK_address_id FOREIGN KEY (address_id)
    REFERENCES address(id)
);

CREATE TABLE customers_backup(
	ID number(5) PRIMARY KEY,
	NAME varchar(60) NOT NULL, 
	AGE number(3) default 0, 
	ADDRESS varchar(255), 
	SALARY number(5),
	address_id number(5)
);


-- Trigger insert 
CREATE or REPLACE TRIGGER customers_after_insert AFTER INSERT ON customers
	FOR EACH ROW	
	
	DECLARE
	
	BEGIN
		insert into customers_backup values (:new.id, :new.NAME, :new.AGE, :new.ADDRESS, :new.SALARY, :new.address_id);
		DBMS_OUTPUT.PUT_LINE('Record successfully inserted into customers_backup table');
	END;
	/
	
INSERT INTO customers values(1, 'Karim', 30, 'Dhaka', 20000, 1);
INSERT INTO customers values(2, 'Habib', 25, 'Pirojpur', 20000, 2);
INSERT INTO customers values(3, 'Nasir', 22, 'Tangail', 20000, 3);


--================ TRIGGER update
CREATE or REPLACE TRIGGER customers_after_update
	AFTER UPDATE ON customers
	FOR EACH ROW
	DECLARE
	
	BEGIN
		update customers_backup
		set id = :new.id, name = :new.name
		where id = :old.id;
		DBMS_OUTPUT.PUT_LINE('Record successfully updated into usa table');
	END;
	/
--========================
update customers set id=100, name = 'Asif'
where id=1;

SELECT * FROM customers_backup WHERE id = 100;
--========================
CREATE or REPLACE TRIGGER customers_after_delete
	AFTER DELETE ON customers
	FOR EACH ROW
	
	DECLARE
	BEGIN
		Delete from customers_backup
		where id = :old.id;
		DBMS_OUTPUT.PUT_LINE('Record successfully Deleted from table');
	END;
	/
delete from customers where id = 100;


--start procedure
CREATE OR REPLACE PROCEDURE insertCustomers(
	   p_id IN CUSTOMERS.id%TYPE,
	   p_name IN CUSTOMERS.name%TYPE,
	   p_age IN CUSTOMERS.age%TYPE,
	   p_address IN CUSTOMERS.address%TYPE,
	   p_salary IN CUSTOMERS.salary%TYPE,
	   p_address_id IN CUSTOMERS.address_id%TYPE)
IS
BEGIN
  INSERT INTO customers (id, name, age, address, salary, address_id) 
  VALUES (p_id, p_name,p_age, p_address, p_salary, p_address_id);
  COMMIT;
END;
/

BEGIN
   insertCustomers(101,'Nuruzzaman',22, 'Dhaka',20000, 2);
END;
/

--============================== Update Example=========================
CREATE OR REPLACE PROCEDURE updateCustomers(
	   p_id IN CUSTOMERS.id%TYPE,
	   p_name IN CUSTOMERS.name%TYPE)
IS
BEGIN

  update CUSTOMERS set name=p_name where id=p_id;

  COMMIT;

END;
/

Begin
updateCustomers(101, 'Rabiul Islam');
end;


--============================== Delete Example=========================
CREATE OR REPLACE PROCEDURE deleteCustomers(
	   p_id IN CUSTOMERS.id%TYPE)
IS
BEGIN

  delete from CUSTOMERS where id=p_id;

  COMMIT;

END;
/

changes here...

	


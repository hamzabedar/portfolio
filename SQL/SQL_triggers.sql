
USE employees;

COMMIT;


DELIMITER $$

CREATE TRIGGER before_salaries_insert
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = 0; 
	END IF; 
END $$

DELIMITER ;


DELIMITER $$

CREATE TRIGGER before_salaries_insert
BEFORE INSERT ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = 0; 
	END IF; 
END $$

DELIMITER ;

# Checking the values of the “Salaries” table for employee 10001.
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001';
    
# Insert a new entry for employee 10001, whose salary will be a negative number.

INSERT INTO salaries VALUES ('10001', -92891, '2010-06-22', '9999-01-01');

# Running the same SELECT query to see whether the newly created record has a salary of 0 dollars per year.
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001';
    

DELIMITER $$

CREATE TRIGGER trig_upd_salary
BEFORE UPDATE ON salaries
FOR EACH ROW
BEGIN 
	IF NEW.salary < 0 THEN 
		SET NEW.salary = OLD.salary; 
	END IF; 
END $$

DELIMITER ;

UPDATE salaries 
SET 
    salary = 98765
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        
# Executing the following SELECT statement to see that the record has been successfully updated.
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        
# Running another UPDATE statement, with which we will try to modify the salary earned by 10001 with a negative value, minus 50,000.

UPDATE salaries 
SET 
    salary = - 50000
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        
# Running the same SELECT statement to check if the salary value was adjusted.
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = '10001'
        AND from_date = '2010-06-22';
        


SELECT SYSDATE();

SELECT DATE_FORMAT(SYSDATE(), '%y-%m-%d') as today;


DELIMITER $$

CREATE TRIGGER trig_ins_dept_mng
AFTER INSERT ON dept_manager
FOR EACH ROW
BEGIN
	DECLARE v_curr_salary int;
    
    SELECT 
		MAX(salary)
	INTO v_curr_salary FROM
		salaries
	WHERE
		emp_no = NEW.emp_no;

	IF v_curr_salary IS NOT NULL THEN
		UPDATE salaries 
		SET 
			to_date = SYSDATE()
		WHERE
			emp_no = NEW.emp_no and to_date = NEW.to_date;

		INSERT INTO salaries 
			VALUES (NEW.emp_no, v_curr_salary + 20000, NEW.from_date, NEW.to_date);
    END IF;
END $$

DELIMITER ;


INSERT INTO dept_manager VALUES ('111534', 'd009', date_format(sysdate(), '%y-%m-%d'), '9999-01-01');


SELECT 
    *
FROM
    dept_manager
WHERE
    emp_no = 111534;
    
SELECT 
    *
FROM
    salaries
WHERE
    emp_no = 111534;

 
ROLLBACK;



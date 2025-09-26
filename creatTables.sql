-- CREATE DATABASE library;

--// Creat tables
DROP TABLE IF EXISTS branch;
CREATE TABLE branch (
    branch VARCHAR(10) PRIMARY KEY,
    manager_id VARCHAR(10),
    branch_address VARCHAR(100),
    conntact_number VARCHAR(15) 
);


DROP TABLE IF EXISTS employees;
CREATE TABLE employees (
    emp_id VARCHAR(10) PRIMARY KEY,
    emp_name VARCHAR(50),
    position VARCHAR(30),
    salary INT, 
    branch_id VARCHAR(10)
);

DROP TABLE IF EXISTS books;
CREATE TABLE books (
    isbn VARCHAR(10) PRIMARY KEY,
    book_title VARCHAR(50),
    category VARCHAR(50),
    rental_price FLOAT,
    status VARCHAR(20),
    author VARCHAR(50),
    publisher VARCHAR(50)
);

DROP TABLE IF EXISTS members;
CREATE TABLE members (
    member_id VARCHAR PRIMARY KEY,
    member_name VARCHAR(50),
    member_address VARCHAR(100),
    reg_date DATE
);

DROP TABLE IF EXISTS issued_status;
CREATE TABLE issued_status (
    issued_id VARCHAR(10) PRIMARY KEY,
    issued_member_id VARCHAR(10) ,
    issued_book_name VARCHAR(50),
    issued_date DATE,
    issued_book_isbn VARCHAR(20),
    issued_emp_id VARCHAR(20)
); 

DROP TABLE IF EXISTS returned_status;
CREATE TABLE returned_status (
    return_id VARCHAR(10) PRIMARY KEY,
    return_member_id VARCHAR(10),
    return_book_name VARCHAR(50),
    return_date DATE,
    return_book_isbn VARCHAR(20),
    return_emp_id VARCHAR(10)
);  

-- I set wrong type for member_id and i need to cahnge it to varchar(10)
ALTER TABLE members
ALTER COLUMN member_id TYPE VARCHAR(10)
USING member_id::VARCHAR;

--FOREIGN KEY CONSTRAINTS for datamodel

ALTER TABLE issued_status
ADD      fk_members
FOREIGN KEY (issued_member_id) REFERENCES members(member_id);




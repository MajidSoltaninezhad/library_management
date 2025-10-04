--CRUD Operations

--Task 1. Create a New Book Record 
-- "978-1-60129-456-2', 'To Kill a Mockingbird', 'Classic', 6.00, 'yes', 'Harper Lee', 'J.B. Lippincott & Co.')"
INSERT INTO books (
    isbn,
    book_title,
    category,
    rental_price,
    status,
    author,
    publisher
  )
VALUES (
    '978-1-60129-456-2',
    'To Kill a Mockingbird',
    'Classic',
    6.00,
    'yes',
    'Harper Lee',
    'J.B. Lippincott & Co.'
  );

--Task 2: Update an Existing Member's Address   

UPDATE members
SET member_address = '250 Main St'
WHERE member_id = 'C101';
SELECT * FROM members; 

--Task 3: Delete a Record from the Issued Status Table 
-- Objective: Delete the record with issued_id = 'IS121' from the issued_status table.

DELETE FROM issued_status
WHERE issued_id = 'IS121';
SELECT * FROM issued_status;

--Task 4: Retrieve All Books Issued by a Specific Employee 
-- Objective: Select all books issued by the employee with emp_id = 'E101'. 

SELECT * FROM issued_status
WHERE issued_emp_id = 'E101';


--Task 5: List Members Who Have Issued More Than One Book
-- Objective: Use GROUP BY to find members who have issued more than one book.
SELECT issued_member_id, COUNT(*) AS book_count
FROM issued_status
GROUP BY issued_member_id
HAVING COUNT(*) > 1;

--CTAS Operation

--Task 6: Create Summary Tables: Used CTAS to generate new tables based on query results
-- each book and total book_issued_cnt

CREATE TABLE book_cnts AS
SELECT 
        b.isbn,
        b.book_title,
        COUNT(ist.issued_book_isbn) as book_issued_cnt

FROM books as b
JOIN 
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1,2;

SELECT * FROM book_cnts;

--Data Analysis & Findings
--Task 7. Retrieve All Books in a Specific Category:

SELECT DISTINCT category  FROM books;

SELECT * FROM books
WHERE category = 'Fantasy';

--Task 8: Find Total Rental Income by Category:

SELECT b.category,
      SUM( b.rental_price),
      COUNT(*)
FROM books as b
JOIN 
issued_status as ist
ON ist.issued_book_isbn = b.isbn
GROUP BY 1;
 
--List Members Who Registered in the Last 180 Days:

SELECT * FROM members

WHERE reg_date >= CURRENT_DATE - INTERVAL '180 days';

--List Employees with Their Branch Manager's Name and their branch details:

SELECT 
    e1.emp_id,
    e1.emp_name,
    e2.emp_name as manager_name,
    b.*


FROM employees as e1
JOIN branch as b
ON b.branch_id = e1.branch_id
JOIN employees as e2
ON b.manager_id = e2.emp_id;

--Task 11. Create a Table of Books with Rental Price Above a Certain Threshold:

CREATE TABLE expensive_books
AS
SELECT * FROM books
WHERE rental_price > 7.00;

SELECT * FROM expensive_books;

--Task 12: Retrieve the List of Books Not Yet Returned

SELECT 
  DISTINCT ist.issued_book_name,
  b.isbn,
  ist.issued_id
FROM books as b
JOIN issued_status as ist
ON ist.issued_book_isbn = b.isbn
WHERE ist.issued_id NOT IN (
  SELECT issued_id FROM returned_status
);

SELECT * FROM returned_status;

--Task 13: Identify Members with Overdue Books

  SELECT
    ist.*,
    CASE 
      WHEN r.return_date IS NULL THEN CURRENT_DATE - ist.issued_date
      ELSE  r.return_date - ist.issued_date
    END as overdue_days
  FROM issued_status as ist
  LEFT JOIN returned_status as r
ON ist.issued_id = r.issued_id;

--Task 14: Update Book Status on Return

CREATE OR REPLACE PROCEDURE add_return_records(p_return_id VARCHAR(10), p_issued_id VARCHAR(10), p_book_quality VARCHAR(10))
LANGUAGE plpgsql
AS $$

DECLARE
    v_isbn VARCHAR(50);
    v_book_name VARCHAR(80);

BEGIN
    -- all your logic and code
    -- inserting into returns based on users input
    INSERT INTO returned_status(return_id, issued_id, return_date)
    VALUES
    (p_return_id, p_issued_id, CURRENT_DATE);

    SELECT
        issued_book_isbn,
        issued_book_name
        INTO
        v_isbn,
        v_book_name
    FROM issued_status
    WHERE issued_id = p_issued_id;

    UPDATE books
    SET status = 'yes'
    WHERE isbn = v_isbn;

    RAISE NOTICE 'Thank you for returning the book: %', v_book_name;

END;
$$


-- Testing FUNCTION add_return_records

issued_id = IS135
ISBN = WHERE isbn = '978-0-307-58837-1'

SELECT * FROM books
WHERE isbn = '978-0-307-58837-1';

SELECT * FROM issued_status
WHERE issued_book_isbn = '978-0-307-58837-1';

SELECT * FROM returned_status
WHERE issued_id = 'IS135';

-- calling function
CALL add_return_records('RS138', 'IS135', 'Good');

-- calling function
CALL add_return_records('RS148', 'IS140', 'Good');

SELECT * FROM returned_status;




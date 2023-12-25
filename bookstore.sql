#creating database
CREATE DATABASE IF NOT EXISTS bookstoreDB;  

USE bookstoreDB;

#creating table named 'books'
CREATE TABLE books(
book_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
title VARCHAR(255) NOT NULL,
author VARCHAR(255),
genre VARCHAR(255),
price DOUBLE NOT NULL,
quantity_in_stock INT
);

#inserting 10 books to db
INSERT INTO books(title, author, genre, price, quantity_in_stock)
VALUES('book1', 'author1', 'genre1', 1000.0, 1);

INSERT INTO books(title, author, genre, price, quantity_in_stock)
VALUES('book2', 'author2', 'genre2', 2000.0, 2);

INSERT INTO books(title, author, genre, price, quantity_in_stock)
VALUES('book3', 'author3', 'genre3', 3000.0, 3);

INSERT INTO books(title, author, genre, price, quantity_in_stock)
VALUES('book4', 'author4', 'genre4', 4000.0, 4);

INSERT INTO books(title, author, genre, price, quantity_in_stock)
VALUES('book5', 'author5', 'genre5', 5000.0, 5);

INSERT INTO books(title, author, genre, price, quantity_in_stock)
VALUES('book6', 'author6', 'genre6', 6000.0, 6);

INSERT INTO books(title, author, genre, price, quantity_in_stock)
VALUES('book7', 'author7', 'genre7', 7000.0, 7);

INSERT INTO books(title, author, genre, price, quantity_in_stock)
VALUES('book8', 'author8', 'genre8', 8000.0, 8);

INSERT INTO books(title, author, genre, price, quantity_in_stock)
VALUES('book9', 'author9', 'genre9', 9000.0, 9);

INSERT INTO books(title, author, genre, price, quantity_in_stock)
VALUES('book10', 'author10', 'genre10', 10000.0, 10);


#creating table named 'customer'
CREATE TABLE customers(
customer_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
`name` VARCHAR(255) NOT NULL,
email VARCHAR(255) NOT NULL,
phone VARCHAR(30)
);


#inserting 5 customers to the DB
INSERT INTO customers(`name`, email, phone)
VALUES('customer1', 'email1@gmail.com', '+37411111111');

INSERT INTO customers(`name`, email, phone)
VALUES('customer2', 'email2@gmail.com', '+37422222222');

INSERT INTO customers(`name`, email, phone)
VALUES('customer3', 'email3@gmail.com', '+37433333333');

INSERT INTO customers(`name`, email, phone)
VALUES('customer4', 'email4@gmail.com', '+37444444444');

INSERT INTO customers(`name`, email, phone)
VALUES('customer5', 'email5@gmail.com', '+37455555555');


#creating table sales
CREATE TABLE sales (
    sale_id INT PRIMARY KEY NOT NULL AUTO_INCREMENT,
    book_id INT,
    customer_id INT,
    date_of_sale DATE,
    quantity_sold INT,
    total_price DOUBLE,
    FOREIGN KEY (book_id) REFERENCES books(book_id),
    FOREIGN KEY (customer_id) REFERENCES customers(customer_id)
);

#Create a trigger to update the total_price column and check quantity in stock
DELIMITER //
CREATE TRIGGER update_total_price
BEFORE INSERT ON sales
FOR EACH ROW
BEGIN
    DECLARE available_quantity INT;

    #Get the available quantity in stock
    SELECT quantity_in_stock INTO available_quantity FROM books WHERE book_id = NEW.book_id;

    #Check if there are enough books in stock
    IF NEW.quantity_sold <= available_quantity THEN
        #Update the total_price column
        SET NEW.total_price = NEW.quantity_sold * (SELECT price FROM books WHERE book_id = NEW.book_id);

        #Decrease the quantity of books in stock
        UPDATE books SET quantity_in_stock = quantity_in_stock - NEW.quantity_sold WHERE book_id = NEW.book_id;
    ELSE
        #Raise an error if the quantity sold exceeds the available quantity
        SIGNAL SQLSTATE '45000' #five-character string that represents the SQL state code for the error. In this case, '45000' is a generic state code indicating an unhandled user-defined exception.
        SET MESSAGE_TEXT = 'Quantity in stock is insufficient for the sale';
    END IF;
END;
//
DELIMITER ;


#inserting some sales into DB
INSERT INTO sales(book_id, customer_id, date_of_sale, quantity_sold)
VALUES(1, 1, '2023-12-01', 1);

#inserting some sales into DB
INSERT INTO sales(book_id, customer_id, date_of_sale, quantity_sold)
VALUES(2, 2, '2023-12-01', 2);

#inserting some sales into DB
INSERT INTO sales(book_id, customer_id, date_of_sale, quantity_sold)
VALUES(3, 3, '2023-12-01', 3);

#inserting some sales into DB
INSERT INTO sales(book_id, customer_id, date_of_sale, quantity_sold)
VALUES(4, 4, '2023-12-01', 4);

#inserting some sales into DB
INSERT INTO sales(book_id, customer_id, date_of_sale, quantity_sold)
VALUES(5, 5, '2023-12-01', 5);


SELECT books.title, customers.name AS customer_name, sales.date_of_sale
FROM sales
JOIN books ON sales.book_id = books.book_id
JOIN customers ON sales.customer_id = customers.customer_id;


SELECT books.genre, SUM(sales.total_price) AS total_revenue
FROM sales
JOIN books ON sales.book_id = books.book_id
GROUP BY books.genre;

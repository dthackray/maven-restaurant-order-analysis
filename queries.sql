---

-- 1.1 View the menu_items table and write a query to find the number of items on the menu

    SELECT count(*) AS menu_items FROM restaurant_db.menu_items;

| menu_items |
| ---------- |
| 32         |

---
-- 1.2 What are the least and most expensive items on the menu?

    SELECT item_name, price FROM restaurant_db.menu_items ORDER BY price ASC LIMIT 1;

| item_name | price |
| --------- | ----- |
| Edamame   | 5.00  |

---


    SELECT item_name, price FROM restaurant_db.menu_items ORDER BY price DESC LIMIT 1;

| item_name     | price |
| ------------- | ----- |
| Shrimp Scampi | 19.95 |

---
-- 1.3 How many Italian dishes are on the menu? What are the least and most expensive Italian dishes on the menu?

    SELECT count(*) AS italian_menu_items FROM restaurant_db.menu_items WHERE category = "italian";

| italian_menu_items |
| ------------------ |
| 9                  |

---


    SELECT item_name, price FROM restaurant_db.menu_items WHERE category = "italian" ORDER BY price ASC LIMIT 1;

| item_name | price |
| --------- | ----- |
| Spaghetti | 14.50 |

---


    SELECT item_name, price FROM restaurant_db.menu_items WHERE category = "italian" ORDER BY price DESC LIMIT 1;

| item_name     | price |
| ------------- | ----- |
| Shrimp Scampi | 19.95 |

---
-- 1.4 How many dishes are in each category? What is the average dish price within each category?

    SELECT category, count(*) AS number_of_dishes FROM restaurant_db.menu_items GROUP BY category;

| category | number_of_dishes |
| -------- | ---------------- |
| American | 6                |
| Asian    | 8                |
| Italian  | 9                |
| Mexican  | 9                |

---


    SELECT category, ROUND(avg(price),2) AS average_dish_cost FROM restaurant_db.menu_items GROUP BY category;

| category | average_dish_cost |
| -------- | ----------------- |
| American | 10.07             |
| Asian    | 13.48             |
| Italian  | 16.75             |
| Mexican  | 11.80             |

---
-- 2.1 View the order_details table. What is the date range of the table?

    SELECT MIN(order_date) AS min_date, MAX(order_date) AS max_date FROM restaurant_db.order_details;

| min_date   | max_date   |
| ---------- | ---------- |
| 2023-01-01 | 2023-03-31 |

---
-- 2.2 How many orders were made within this date range? How many items were ordered within this date range?

    SELECT count(DISTINCT order_id) AS orders FROM restaurant_db.order_details;

| orders |
| ------ |
| 5370   |

---


    SELECT count(*) AS items FROM restaurant_db.order_details;

| items |
| ----- |
| 12234 |

---
-- 2.3 Which orders had the most number of items?

    SELECT * FROM (
      SELECT order_id, count(item_id) AS items FROM restaurant_db.order_details 
      GROUP BY order_id
      ORDER BY items DESC) AS sub
    WHERE items = (SELECT MAX(items) FROM (
      SELECT order_id, count(item_id) AS items FROM restaurant_db.order_details 
      GROUP BY order_id
      ORDER BY items DESC) subsub);

| order_id | items |
| -------- | ----- |
| 3473     | 14    |
| 4305     | 14    |
| 2675     | 14    |
| 1957     | 14    |
| 440      | 14    |
| 330      | 14    |
| 443      | 14    |

---
-- 2.4 How many orders had more than 12 items?

    SELECT count(*) AS orders_over_12_items FROM
    (SELECT order_id, count(item_id) AS num_items
     FROM restaurant_db.order_details
     GROUP BY order_id
     HAVING num_items > 12) AS num_orders;

| orders_over_12_items |
| -------------------- |
| 20                   |

---
 -- 3.1 Combine the menu_items and order_details tables into a single table

    SELECT *
    FROM restaurant_db.order_details 
    LEFT JOIN restaurant_db.menu_items
    ON restaurant_db.order_details.item_id = restaurant_db.menu_items.menu_item_id
    LIMIT 10;

| order_details_id | order_id | order_date | order_time | item_id | menu_item_id | item_name        | category | price |
| ---------------- | -------- | ---------- | ---------- | ------- | ------------ | ---------------- | -------- | ----- |
| 1                | 1        | 2023-01-01 | 11:38:36   | 109     | 109          | Korean Beef Bowl | Asian    | 17.95 |
| 2                | 2        | 2023-01-01 | 11:57:40   | 108     | 108          | Tofu Pad Thai    | Asian    | 14.50 |
| 3                | 2        | 2023-01-01 | 11:57:40   | 124     | 124          | Spaghetti        | Italian  | 14.50 |
| 4                | 2        | 2023-01-01 | 11:57:40   | 117     | 117          | Chicken Burrito  | Mexican  | 12.95 |
| 5                | 2        | 2023-01-01 | 11:57:40   | 129     | 129          | Mushroom Ravioli | Italian  | 15.50 |
| 6                | 2        | 2023-01-01 | 11:57:40   | 106     | 106          | French Fries     | American | 7.00  |
| 7                | 3        | 2023-01-01 | 12:12:28   | 117     | 117          | Chicken Burrito  | Mexican  | 12.95 |
| 8                | 3        | 2023-01-01 | 12:12:28   | 119     | 119          | Chicken Torta    | Mexican  | 11.95 |
| 9                | 4        | 2023-01-01 | 12:16:31   | 117     | 117          | Chicken Burrito  | Mexican  | 12.95 |
| 10               | 5        | 2023-01-01 | 12:21:30   | 117     | 117          | Chicken Burrito  | Mexican  | 12.95 |

---
-- 3.2 What were the least and most ordered items? What categories were they in?

    SELECT item_name, category, count(*) AS times_ordered
    FROM restaurant_db.order_details 
    LEFT JOIN restaurant_db.menu_items
    ON restaurant_db.order_details.item_id = restaurant_db.menu_items.menu_item_id
    GROUP BY item_name, category
    ORDER BY times_ordered ASC
    LIMIT 1;

| item_name     | category | times_ordered |
| ------------- | -------- | ------------- |
| Chicken Tacos | Mexican  | 123           |

---


    SELECT item_name, category, count(*) AS times_ordered
    FROM restaurant_db.order_details 
    LEFT JOIN restaurant_db.menu_items
    ON restaurant_db.order_details.item_id = restaurant_db.menu_items.menu_item_id
    GROUP BY item_name, category
    ORDER BY times_ordered DESC
    LIMIT 1;

| item_name | category | times_ordered |
| --------- | -------- | ------------- |
| Hamburger | American | 622           |

---
-- 3.3 What were the top 5 orders that spent the most money?

    SELECT order_id, SUM(price) AS order_cost
    FROM restaurant_db.order_details 
    LEFT JOIN restaurant_db.menu_items
    ON restaurant_db.order_details.item_id = restaurant_db.menu_items.menu_item_id
    GROUP BY order_id
    ORDER BY order_cost DESC
    LIMIT 5;

| order_id | order_cost |
| -------- | ---------- |
| 440      | 192.15     |
| 2075     | 191.05     |
| 1957     | 190.10     |
| 330      | 189.70     |
| 2675     | 185.10     |

---
-- 3.4 View the details of the highest spend order. Which specific items were purchased?

    SELECT *
    FROM restaurant_db.order_details 
    LEFT JOIN restaurant_db.menu_items
    ON restaurant_db.order_details.item_id = restaurant_db.menu_items.menu_item_id
    WHERE order_id = 440;

| order_details_id | order_id | order_date | order_time | item_id | menu_item_id | item_name             | category | price |
| ---------------- | -------- | ---------- | ---------- | ------- | ------------ | --------------------- | -------- | ----- |
| 1003             | 440      | 2023-01-08 | 12:16:34   | 116     | 116          | Steak Tacos           | Mexican  | 13.95 |
| 1004             | 440      | 2023-01-08 | 12:16:34   | 103     | 103          | Hot Dog               | American | 9.00  |
| 1005             | 440      | 2023-01-08 | 12:16:34   | 124     | 124          | Spaghetti             | Italian  | 14.50 |
| 1006             | 440      | 2023-01-08 | 12:16:34   | 125     | 125          | Spaghetti & Meatballs | Italian  | 17.95 |
| 1007             | 440      | 2023-01-08 | 12:16:34   | 125     | 125          | Spaghetti & Meatballs | Italian  | 17.95 |
| 1008             | 440      | 2023-01-08 | 12:16:34   | 126     | 126          | Fettuccine Alfredo    | Italian  | 14.50 |
| 1009             | 440      | 2023-01-08 | 12:16:34   | 126     | 126          | Fettuccine Alfredo    | Italian  | 14.50 |
| 1010             | 440      | 2023-01-08 | 12:16:34   | 109     | 109          | Korean Beef Bowl      | Asian    | 17.95 |
| 1011             | 440      | 2023-01-08 | 12:16:34   | 127     | 127          | Meat Lasagna          | Italian  | 17.95 |
| 1012             | 440      | 2023-01-08 | 12:16:34   | 113     | 113          | Edamame               | Asian    | 5.00  |
| 1013             | 440      | 2023-01-08 | 12:16:34   | 122     | 122          | Chips & Salsa         | Mexican  | 7.00  |
| 1014             | 440      | 2023-01-08 | 12:16:34   | 131     | 131          | Chicken Parmesan      | Italian  | 17.95 |
| 1015             | 440      | 2023-01-08 | 12:16:34   | 106     | 106          | French Fries          | American | 7.00  |
| 1016             | 440      | 2023-01-08 | 12:16:34   | 132     | 132          | Eggplant Parmesan     | Italian  | 16.95 |

---
-- 3.5 BONUS: View the details of the top 5 highest spend orders

    SELECT order_id, category, count(item_id) AS num_items
    FROM restaurant_db.order_details 
    LEFT JOIN restaurant_db.menu_items
    ON restaurant_db.order_details.item_id = restaurant_db.menu_items.menu_item_id
    WHERE order_id IN(440, 2075, 1957, 330, 2675)
    GROUP BY order_id, category;

| order_id | category | num_items |
| -------- | -------- | --------- |
| 330      | American | 1         |
| 330      | Asian    | 6         |
| 330      | Italian  | 3         |
| 330      | Mexican  | 4         |
| 440      | American | 2         |
| 440      | Asian    | 2         |
| 440      | Italian  | 8         |
| 440      | Mexican  | 2         |
| 1957     | American | 3         |
| 1957     | Asian    | 3         |
| 1957     | Italian  | 5         |
| 1957     | Mexican  | 3         |
| 2075     | American | 1         |
| 2075     | Asian    | 3         |
| 2075     | Italian  | 6         |
| 2075     | Mexican  | 3         |
| 2675     | American | 3         |
| 2675     | Asian    | 3         |
| 2675     | Italian  | 4         |
| 2675     | Mexican  | 4         |

---
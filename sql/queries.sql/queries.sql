create table daily_sales2 as

SELECT
    DATE(注文日時) AS daily_date,
    SUM(金額) AS total_sales,
"顧客ID" AS customer_id
FROM
    orders_full
GROUP BY
    customer_id,daily_date;

\copy daily_sales2 TO 'C:/Users/toyod/OneDrive/Desktop/portforio/daily_sales2.csv' CSV HEADER ENCODING 'UTF8';



postgres=# \copy daily_sales to 'daily_sales.csv' with (FORMAT CSV, HEADER);
daily_sales.csv: Permission denied
postgres=# \copy daily_sales to 'C:/temp/daily_sales.csv' with (FORMAT CSV, HEADER);
C:/temp/daily_sales.csv: No such file or directory
postgres=# \copy daily_sales to 'C:/temp/daily_sales.csv' with (FORMAT CSV, HEADER);
COPY 1096
postgres=# \copy daily_sales to 'C:/temp/daily_sales.csv' with (FORMAT CSV, HEADER);



年齢算出
\copy (SELECT "顧客ID", "生年月日", DATE_PART('year', AGE(CURRENT_DATE, "生年月日")) AS 年齢 FROM orders_full) TO 'C:/temp/birthday.csv' CSV HEADER ENCODING 'UTF8';


年齢＋性別
\copy (SELECT "顧客ID","生年月日",DATE_PART('year', AGE(CURRENT_DATE,"生年月日")) AS 年齢,"性別" FROM orders_full) TO 'C:/temp/birthday.csv' CSV HEADER ENCODING 'UTF8';




orders_fullをｃｓｖに
\copy orders_full TO 'C:/temp/orders_full.csv' CSV HEADER ENCODING 'UTF8';


商品カテゴリごとの合計売上金額
create table category_sales as SELECT 
    カテゴリ AS category,
    SUM(金額) AS total_sales,
    顧客ID
FROM orders_full
GROUP BY カテゴリ
ORDER BY total_sales DESC;

\copy category_sales TO 'C:/Users/toyod/OneDrive/Desktop/portforio/category_sales.csv' CSV HEADER ENCODING 'UTF8'


商品ID 売上トップ１０
CREATE TABLE product_sales_ranking as SELECT 
    商品ID AS product_id,
    SUM(金額) AS total_sales,
    SUM(数量) AS total_quantity
FROM orders_full
GROUP BY 商品ID
ORDER BY total_sales DESC
LIMIT 10;

\copy product_sales_ranking TO 'C:/Users/toyod/OneDrive/Desktop/portforio/product_sales_ranking.csv' CSV HEADER ENCODING 'UTF8';

 
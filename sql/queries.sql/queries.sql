


---空のorderテーブルを作る
CREATE TABLE orders (
    注文ID VARCHAR(255),
     注文日時 TIMESTAMP,
     顧客ID VARCHAR(255),
     商品ID VARCHAR(255),
     数量 INT,
     金額 INT,
     出荷日時 TIMESTAMP,
     キャンセル日時 TIMESTAMP,
     注文ステータス VARCHAR(50)


---全ての注文データをインポートし縦統合する
COPY orders FROM 'C:/sampledata/order_202001.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202002.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202003.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202004.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202005.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202006.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202007.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202008.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202009.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202010.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202011.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202012.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202101.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202102.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202103.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202104.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202105.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202106.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202107.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202108.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202109.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202110.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202111.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202112.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202201.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202202.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202203.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202204.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202205.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202206.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202207.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202208.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202209.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202210.csv' DELIMITER ',' CSV HEADER; 
COPY orders FROM 'C:/sampledata/order_202211.csv' DELIMITER ',' CSV HEADER;
COPY orders FROM 'C:/sampledata/order_202212.csv' DELIMITER ',' CSV HEADER;

---統合できてるか中身の確認
SELECT COUNT(*) FROM orders;
SELECT * FROM orders LIMIT 10;


---統合したテーブルをorder_rawテーブルに名前変更
CREATE TABLE orders_raw AS SELECT * FROM orders;

---customer_masterテーブルを作成(顧客情報)
CREATE TABLE customer_master (
    "顧客ID" VARCHAR(255) PRIMARY KEY,
    "氏名" VARCHAR(255),
    "氏名（ひらがな）" VARCHAR(255),
    "生年月日" DATE,
    "性別" VARCHAR(255),
    "都道府県" VARCHAR(255),
    "ステータス" VARCHAR(255)
);

---customer_masterテーブルにCSVファイルをインポートする
\copy customer_master FROM 'customer_master_20221231.csv' WITH (FORMAT csv, HEADER true);

---item_masterテーブルを作る(商品情報)
CREATE item_master (
    "商品id" VARCHAR(255) PRIMARY KEY,
    "商品名" VARCHAR(255),
    "カテゴリ" VARCHAR(255),
    "サブカテゴリ" VARCHAR(255),
    "色" VARCHAR(255),
    "サイズ" VARCHAR(255),
    "定価" INT
)


---item_masterテーブルにCSVファイルをインポートする
\copy item_master FROM 'item_master_20221231.csv' WITH (FORMAT csv, HEADER true);


---3つのテーブルをJOINしてorders_fullテーブルを作成
CREATE TABLE orders_full AS
SELECT
    *
FROM
    orders_raw 
JOIN
    customer_master  ON orders_raw."顧客ID" = customer_master."顧客id"
JOIN
    item_master  ON orders_raw."商品ID" = customer_master."商品id";





---注文日時、売上金額、顧客IDの要素を抽出して新しく日別売上のテーブルを作る

CREATE TABLE daily_sales2 as
SELECT
    DATE(注文日時) AS daily_date,
    SUM(金額) AS total_sales,
    "顧客ID" AS customer_id
FROM
    orders_full
GROUP BY
    customer_id,daily_date;


---daily_sales2テーブルをCSV形式にしてフォルダに保存
\copy daily_sales2 TO 'C:/Users/toyod/OneDrive/Desktop/portforio/daily_sales2.csv' CSV HEADER ENCODING 'UTF8';


/*生年月日を抽出して年齢を算出、
　顧客ID、性別を抽出し
  CSV形式にしてbirthday.csvフォルダに保存
*/
\copy (SELECT "顧客ID", "生年月日","性別", DATE_PART('year', AGE(CURRENT_DATE, "生年月日")) AS 年齢 
   FROM orders_full) TO 'C:/temp/age_group_count.csv' CSV HEADER ENCODING 'UTF8';



---BI　TABLEAUの年代のディメンションで計算フィールドを作成(年齢ごとではなく年代ごとで分析するため)
IF [年齢] < 10 THEN "10代未満"
ELSEIF [年齢] >= 10 AND [年齢] <= 19 THEN "10代"
ELSEIF [年齢] >= 20 AND [年齢] <= 29 THEN "20代"
ELSEIF [年齢] >= 30 AND [年齢] <= 39 THEN "30代"
ELSEIF [年齢] >= 40 AND [年齢] <= 49 THEN "40代"
ELSEIF [年齢] >= 50 AND [年齢] <= 59 THEN "50代"
ELSE "60代以上"
END



--商品カテゴリごとの合計売上金額テーブルを作る
CREATE TABLE category_sales as
 SELECT 
    カテゴリ AS category,
    SUM(金額) AS total_sales,
    顧客ID
FROM orders_full
GROUP BY カテゴリ
ORDER BY total_sales DESC;

--CSV形式に出力(bi tableauで可視化するため)
\copy category_sales TO 'C:/Users/toyod/OneDrive/Desktop/portforio/category_sales.csv' CSV HEADER ENCODING 'UTF8'



--orders_fullをｃｓｖに(bi tableauで可視化するため)
\copy orders_full TO 'C:/temp/orders_full.csv' CSV HEADER ENCODING 'UTF8';



--商品ID 売上トップ１０を抽出
CREATE TABLE product_sales_ranking as SELECT 
    商品ID AS product_id,
    SUM(金額) AS total_sales,
    SUM(数量) AS total_quantity
FROM orders_full
GROUP BY 商品ID
ORDER BY total_sales DESC
LIMIT 10;


--CSVに出力(bi tableauで可視化するため)
\copy product_sales_ranking TO 'C:/Users/toyod/OneDrive/Desktop/portforio/product_sales_ranking.csv' CSV HEADER ENCODING 'UTF8';

 
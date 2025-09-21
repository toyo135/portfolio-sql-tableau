# portfolio-sql-tableau
ポスグレSQLでデータを加工・抽出し、Tableauで可視化したポートフォリオ

# Portfolio: SQL + Tableau

## 概要
PostgreSQLでデータを整形し、Tableauで可視化したポートフォリオです。  
目的：売上データの月別・カテゴリ別の傾向を分析する。
分析結果：「アウター」が主力商品であり、「30代」の顧客が最も多い。この2つの要素を組み合わせた戦略が今後の事業拡大に繋がる。また、「BP-CUNN」のような単価の低い人気商品を活かした戦略に検討の価値がある。

## ファイル構成
- data/sample_orders.csv : サンプルデータ（個人情報は偽）
- sql/queries.sql        : 実行したSQLクエリ
- viz/dashboard.png      : テーブルのデータをTableauで可視化したダッシュボードのスクリーンショット

## 再現手順
1. リポジトリをクローン  
   ```bash
   git clone https://public.tableau.com/app/profile/.61827801/viz/_17581404845460/1

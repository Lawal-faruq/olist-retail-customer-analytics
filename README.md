# Olist Retail Customer Analytics.

## An end-to-end SQL + Power BI analytics project

![Dashboard Preview](dashboard_page1.png)

---

## Project Overview

This project delivers a full retail analytics solution built on the 
Olist Brazilian E-Commerce dataset — 100,000+ real orders spanning 
2016 to 2018. The goal was to move beyond surface-level reporting and 
answer the questions that actually drive business decisions:

- Which customer segments generate the most revenue — and which are 
  at risk of being lost?
- How has monthly revenue trended, and what does year-over-year 
  growth look like?
- Which product categories deliver the highest value, and which rely 
  on volume over premium pricing?

The project combines a production-style SQL Server data warehouse with 
a three-page Power BI dashboard, documented end-to-end.

---

## Technical Stack

| Layer | Tool |
|---|---|
| Database | Microsoft SQL Server |
| Data modelling | Star schema (fact + 5 dimensions) |
| Analysis | Advanced SQL (window functions, CTEs, RFM) |
| Visualisation | Power BI Desktop |
| Documentation | GitHub |

---

## Data Architecture

The raw Olist dataset (9 CSV files) was transformed into a clean star 
schema with one central fact table and five dimension tables.

### Star schema

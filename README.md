# 📈 Investigating Metric Spike – SQL Case Study

This project investigates an unexpected spike in user metrics using structured SQL analysis in **MySQL Workbench**. It involves parsing user events, signup trends, device-based engagement, and email activity to understand user behavior patterns across time.

---

## 🧰 Tools & Technologies

- **SQL Engine**: MySQL 8.0  
- **Platform**: MySQL Workbench  
- **Languages**: SQL  
- **Data Format**: CSV

---

## 📦 Dataset Overview

The project uses 3 core tables:

| Table Name     | Description                                                      |
|----------------|------------------------------------------------------------------|
| `users`        | User metadata including signup and activation timestamps         |
| `events`       | User activity logs (e.g., login, message, search)                |
| `email_events` | Email-related actions (e.g., sent, opened, clickthrough)         |

All timestamp columns were converted from `VARCHAR` to `DATETIME` using `STR_TO_DATE()` for accurate temporal analysis.

---

## 🎯 Project Objectives

1. Analyze weekly user activity and event volumes  
2. Evaluate user growth and retention trends  
3. Segment engagement by device type  
4. Quantify email engagement metrics  
5. Optimize database performance with views and indexes  

---

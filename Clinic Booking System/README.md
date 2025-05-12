# Clinic System

## Description
A relational database system to handle patient management, doctor scheduling, treatment records, and payment tracking in a clinical setting using MySQL.

## How to Setup

1. Install MySQL Server.
2. Clone this repository:
   ```bash
   git clone https://github.com/your-username/clinic-booking-system.git
   cd clinic-booking-system

## Import the SQL file:

1. run the file
   ```bash
   mysql -u your_user -p your_database < clinic_system.sql



## Entity-Relationship Diagram (ERD)

![ERD DIARGRAM](ERD.png)

Tables and Relationships:
Patients, Doctors, Appointments, Treatments, Payments

1-M: Patients -> Appointments

1-M: Doctors -> Appointments

1-M: Appointments -> Treatments

1-M: Patients -> Payments
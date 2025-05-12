-- Users table
CREATE TABLE Users (
    UserID INT AUTO_INCREMENT PRIMARY KEY,
    Username VARCHAR(50) NOT NULL UNIQUE,
    PasswordHash VARCHAR(255) NOT NULL,
    Role ENUM('Admin', 'Doctor', 'Nurse', 'Receptionist', 'LabTech') NOT NULL,
    Email VARCHAR(100) UNIQUE,
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

-- Departments table
CREATE TABLE Departments (
    DepartmentID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);

-- Insurance table
CREATE TABLE Insurance (
    InsuranceID INT AUTO_INCREMENT PRIMARY KEY,
    ProviderName VARCHAR(100) NOT NULL,
    PolicyNumber VARCHAR(100) NOT NULL UNIQUE,
    CoverageDetails TEXT,
    ValidUntil DATE
);

-- Patients table
CREATE TABLE Patients (
    PatientID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    DOB DATE NOT NULL,
    Gender ENUM('Male', 'Female', 'Other') NOT NULL,
    Phone VARCHAR(15) UNIQUE NOT NULL,
    Email VARCHAR(100) UNIQUE,
    Address TEXT,
    EmergencyContact VARCHAR(50),
    BloodType ENUM('A+', 'A-', 'B+', 'B-', 'O+', 'O-', 'AB+', 'AB-'),
    InsuranceID INT,
    RegisteredAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (InsuranceID) REFERENCES Insurance(InsuranceID)
);

-- Doctors table
CREATE TABLE Doctors (
    DoctorID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50) NOT NULL,
    LastName VARCHAR(50) NOT NULL,
    Email VARCHAR(100) UNIQUE NOT NULL,
    Phone VARCHAR(15) UNIQUE,
    SpecializationID INT,
    DepartmentID INT,
    HireDate DATE,
    LicenseNumber VARCHAR(50) UNIQUE,
    UserID INT UNIQUE,
    FOREIGN KEY (SpecializationID) REFERENCES Specializations(SpecializationID),
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Specializations table
CREATE TABLE Specializations (
    SpecializationID INT AUTO_INCREMENT PRIMARY KEY,
    Name VARCHAR(100) NOT NULL UNIQUE,
    Description TEXT
);

-- Nurses table
CREATE TABLE Nurses (
    NurseID INT AUTO_INCREMENT PRIMARY KEY,
    FirstName VARCHAR(50),
    LastName VARCHAR(50),
    DepartmentID INT,
    Phone VARCHAR(15),
    Email VARCHAR(100),
    UserID INT UNIQUE,
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID),
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

-- Rooms table
CREATE TABLE Rooms (
    RoomID INT AUTO_INCREMENT PRIMARY KEY,
    RoomNumber VARCHAR(10) NOT NULL UNIQUE,
    DepartmentID INT,
    RoomType ENUM('General', 'ICU', 'Private', 'Surgery') NOT NULL,
    Status ENUM('Available', 'Occupied', 'Maintenance') DEFAULT 'Available',
    FOREIGN KEY (DepartmentID) REFERENCES Departments(DepartmentID)
);

-- Appointments table
CREATE TABLE Appointments (
    AppointmentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    DoctorID INT NOT NULL,
    AppointmentDate DATETIME NOT NULL,
    DurationMinutes INT DEFAULT 30,
    Reason TEXT,
    Status ENUM('Scheduled', 'Completed', 'Cancelled', 'No-Show') DEFAULT 'Scheduled',
    CreatedAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID) ON DELETE CASCADE,
    FOREIGN KEY (DoctorID) REFERENCES Doctors(DoctorID) ON DELETE SET NULL
);

-- Visits table (walk-ins or admitted)
CREATE TABLE Visits (
    VisitID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    VisitDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    RoomID INT,
    AttendingDoctorID INT,
    Status ENUM('Admitted', 'Discharged') DEFAULT 'Admitted',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (RoomID) REFERENCES Rooms(RoomID),
    FOREIGN KEY (AttendingDoctorID) REFERENCES Doctors(DoctorID)
);

-- Treatments table
CREATE TABLE Treatments (
    TreatmentID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT,
    VisitID INT,
    Description TEXT NOT NULL,
    Cost DECIMAL(10,2) NOT NULL,
    TreatmentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);

-- Prescriptions table
CREATE TABLE Prescriptions (
    PrescriptionID INT AUTO_INCREMENT PRIMARY KEY,
    AppointmentID INT,
    VisitID INT,
    DatePrescribed DATETIME DEFAULT CURRENT_TIMESTAMP,
    Notes TEXT,
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);

-- Medications table
CREATE TABLE Medications (
    MedicationID INT AUTO_INCREMENT PRIMARY KEY,
    PrescriptionID INT NOT NULL,
    MedicationName VARCHAR(100) NOT NULL,
    Dosage VARCHAR(50),
    DurationDays INT,
    Frequency VARCHAR(50),
    FOREIGN KEY (PrescriptionID) REFERENCES Prescriptions(PrescriptionID) ON DELETE CASCADE
);

-- Payments table
CREATE TABLE Payments (
    PaymentID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    AppointmentID INT,
    VisitID INT,
    Amount DECIMAL(10,2) NOT NULL,
    PaymentDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Method ENUM('Cash', 'Card', 'Online', 'Insurance') NOT NULL,
    Status ENUM('Paid', 'Pending', 'Failed') DEFAULT 'Paid',
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (AppointmentID) REFERENCES Appointments(AppointmentID),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);

-- Medical Records table
CREATE TABLE MedicalRecords (
    RecordID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    RecordDate DATE NOT NULL,
    Diagnosis TEXT,
    Allergies TEXT,
    Notes TEXT,
    CreatedBy INT,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (CreatedBy) REFERENCES Users(UserID)
);

-- Lab Tests table
CREATE TABLE LabTests (
    LabTestID INT AUTO_INCREMENT PRIMARY KEY,
    PatientID INT NOT NULL,
    TestName VARCHAR(100) NOT NULL,
    OrderedBy INT,
    OrderDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (PatientID) REFERENCES Patients(PatientID),
    FOREIGN KEY (OrderedBy) REFERENCES Doctors(DoctorID)
);

-- Test Results table
CREATE TABLE TestResults (
    ResultID INT AUTO_INCREMENT PRIMARY KEY,
    LabTestID INT NOT NULL,
    ResultDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    ResultSummary TEXT,
    ResultFilePath VARCHAR(255),
    FOREIGN KEY (LabTestID) REFERENCES LabTests(LabTestID)
);

-- Discharge Summaries
CREATE TABLE DischargeSummaries (
    DischargeID INT AUTO_INCREMENT PRIMARY KEY,
    VisitID INT NOT NULL,
    DischargeDate DATETIME DEFAULT CURRENT_TIMESTAMP,
    Summary TEXT,
    AdvisedFollowUp VARCHAR(255),
    FOREIGN KEY (VisitID) REFERENCES Visits(VisitID)
);

-- Audit Log
CREATE TABLE AuditLog (
    LogID INT AUTO_INCREMENT PRIMARY KEY,
    UserID INT,
    Action VARCHAR(255) NOT NULL,
    IPAddress VARCHAR(45),
    ActionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (UserID) REFERENCES Users(UserID)
);

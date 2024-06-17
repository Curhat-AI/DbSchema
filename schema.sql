CREATE TABLE users (
    id VARCHAR(36) PRIMARY KEY,
    email VARCHAR(100) NOT NULL UNIQUE,
    name VARCHAR(100),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE userDetails (
    id INT PRIMARY KEY AUTO_INCREMENT,
    userId VARCHAR(36) UNIQUE,
    dob DATE NOT NULL,
    gender ENUM('m', 'f') NOT NULL,
    photoUrl VARCHAR(255),
    phone VARCHAR(15),
    FOREIGN KEY (userId) REFERENCES users(id)
);

CREATE TABLE counselorDetails (
    id INT PRIMARY KEY AUTO_INCREMENT,
    userId VARCHAR(36) UNIQUE,
    name VARCHAR(100),
    bio TEXT,
    experience INT NOT NULL,
    counselorType ENUM('peer', 'professional') NOT NULL,
    expertise VARCHAR(100),
    FOREIGN KEY (userId) REFERENCES users(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE userRoles (
    id INT PRIMARY KEY AUTO_INCREMENT,
    userId VARCHAR(36) NOT NULL,
    isPatient BOOLEAN DEFAULT false,
    isCounselor BOOLEAN DEFAULT false,
    FOREIGN KEY (userId) REFERENCES users(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE emotionDetections (
    id INT PRIMARY KEY AUTO_INCREMENT,
    userId VARCHAR(36) NOT NULL,
    emotion VARCHAR(50) NOT NULL,
    imageUrl VARCHAR(255),
    detectionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (userId) REFERENCES users(id),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE counselorSchedules (
    id INT PRIMARY KEY AUTO_INCREMENT,
    counselorId VARCHAR(36) NOT NULL,
    availableDate DATE NOT NULL,
    startTime TIME NOT NULL,
    endTime TIME NOT NULL,
    isBooked BOOLEAN DEFAULT false,
    FOREIGN KEY (counselorId) REFERENCES counselorDetails(userId),
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);

CREATE TABLE counselingSessions (
    id VARCHAR(36) PRIMARY KEY,
    counselorId VARCHAR(36) NOT NULL,
    patientId VARCHAR(36) NOT NULL,
    scheduleId INT NOT NULL,
    startTime TIMESTAMP,
    endTime TIMESTAMP,
    status ENUM('Berlangsung', 'Terlewat', 'Akan Datang', 'Dibatalkan', 'Selesai'),
    meetingLink VARCHAR(255),
    communicationPreference ENUM('chat', 'call', 'video_call'),
    counselorFeedback TEXT,
    patientFeedback TEXT,
    rating INT,
    counselingFee DECIMAL(10, 2) NOT NULL,
    discount DECIMAL(10, 2) NOT NULL,
    tax DECIMAL(10, 2) NOT NULL,
    totalPayment DECIMAL(10, 2) NOT NULL,
    paymentDate TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    paymentStatus ENUM('Sedang Menunggu Pembayaran', 'Berhasil Melakukan Pembayaran', 'Batal Melakukan Pembayaran') DEFAULT 'Sedang Menunggu Pembayaran',
    createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (counselorId) REFERENCES counselorDetails(userId),
    FOREIGN KEY (patientId) REFERENCES userRoles(userId),
    FOREIGN KEY (scheduleId) REFERENCES counselorSchedules(id)
);

-- Trigger to ensure payment is completed before session can proceed
CREATE TRIGGER trg_before_session
BEFORE INSERT ON counselingSessions
FOR EACH ROW
BEGIN
    IF NEW.paymentStatus != 'Berhasil Melakukan Pembayaran' THEN
        SIGNAL SQLSTATE '45000' SET MESSAGE_TEXT = 'Pembayaran tidak berhasil, tidak dapat melanjutkan sesi konsultasi.';
    END IF;
END;

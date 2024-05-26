CREATE TABLE users (
  id VARCHAR(36) PRIMARY KEY,
  email VARCHAR(100) NOT NULL UNIQUE,
  name VARCHAR(100),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE userDetails (
  id VARCHAR(36) PRIMARY KEY AUTO_INCREMENT,
  userId VARCHAR(36) PRIMARY KEY,
  dob DATE NOT NULL,
  gender ENUM('m', 'f') NOT NULL,
  photoUrl VARCHAR(255),
  phone VARCHAR(15),
  FOREIGN KEY (userId) REFERENCES users(id)
);
CREATE TABLE counselorDetails (
  id VARCHAR(36) PRIMARY KEY AUTO_INCREMENT,
  name VARCHAR(100),
  bio TEXT,
  userId VARCHAR(36) PRIMARY KEY,
  experience INT NOT NULL,
  counselorType ENUM('peer', 'professional') NOT NULL,
  expertise VARCHAR(100),
  FOREIGN KEY (userId) REFERENCES users(id),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE userRoles (
  id VARCHAR(36) PRIMARY KEY AUTO_INCREMENT,
  userId VARCHAR(36) NOT NULL,
  isPatient BOOLEAN DEFAULT false,
  isCounselor BOOLEAN DEFAULT false,
  FOREIGN KEY (userId) REFERENCES users(id),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE emotionDetections (
  id VARCHAR(36) PRIMARY KEY AUTO_INCREMENT,
  userId VARCHAR(36) NOT NULL,
  emotion VARCHAR(50) NOT NULL,
  imageUrl VARCHAR(255),
  detectionTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  FOREIGN KEY (userId) REFERENCES users(id),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE counselingSessions (
  id VARCHAR(36) PRIMARY KEY AUTO_INCREMENT,
  scheduleId VARCHAR(36) NOT NULL,
  startTime TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
  endTime TIMESTAMP,
  counselorFeedback TEXT,
  patientFeedback TEXT,
  rating INT,
  FOREIGN KEY (scheduleId) REFERENCES counselorSchedules(id),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
CREATE TABLE counselorSchedules (
  id VARCHAR(36) PRIMARY KEY AUTO_INCREMENT,
  counselorId VARCHAR(36) NOT NULL,
  patientId VARCHAR(36) NOT NULL,
  sessionId VARCHAR(36) NOT NULL,
  startTime TIME NOT NULL,
  endTime TIME NOT NULL,
  communicationPreference ENUM('chat', 'call', 'video_call') NOT NULL,
  meetingLink VARCHAR(255),
  FOREIGN KEY (counselorId) REFERENCES users(id),
  FOREIGN KEY (patientId) REFERENCES users(id),
  FOREIGN KEY (sessionId) REFERENCES counselingSessions(id),
  createdAt TIMESTAMP DEFAULT CURRENT_TIMESTAMP
);
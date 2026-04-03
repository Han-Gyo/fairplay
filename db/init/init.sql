-- 1. 데이터베이스 생성 및 선택

CREATE DATABASE IF NOT EXISTS fairplay;
USE fairplay;

-- 2. member (사용자 정보)
CREATE TABLE IF NOT EXISTS member (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(100) NOT NULL,
    real_name VARCHAR(50) NOT NULL,
    nickname VARCHAR(100) NOT NULL,
    email VARCHAR(100) NOT NULL UNIQUE,
    address VARCHAR(200),
    phone VARCHAR(20),
    status ENUM('ACTIVE', 'INACTIVE') DEFAULT 'ACTIVE',
    role VARCHAR(20) DEFAULT 'USER',
    created_at DATETIME NOT NULL DEFAULT CURRENT_TIMESTAMP,
    inactive_at DATETIME NULL,
    profile_image VARCHAR(255) DEFAULT 'default_profile.png'
) ENGINE=InnoDB;

-- 3. group (그룹 정보)
CREATE TABLE IF NOT EXISTS `group` (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(100) NOT NULL,
    description VARCHAR(255),
    code VARCHAR(8) NOT NULL,
    max_member INT DEFAULT 10,
    public_status BOOLEAN DEFAULT TRUE,
    profile_img VARCHAR(255),
    created_at DATETIME DEFAULT NOW(),
    admin_comment VARCHAR(255),
    leader_id INT NOT NULL
) ENGINE=InnoDB;

-- 4. group_member (관계 테이블)
CREATE TABLE IF NOT EXISTS group_member (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    member_id INT NOT NULL,
    role ENUM('LEADER', 'MEMBER') DEFAULT 'MEMBER',
    monthly_score INT DEFAULT 0,
    total_score INT DEFAULT 0,
    warning_count INT DEFAULT 0,
    last_counted_month VARCHAR(7) DEFAULT NULL,
    FOREIGN KEY (group_id) REFERENCES `group`(id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE,
    UNIQUE (group_id, member_id)
) ENGINE=InnoDB;

-- 5. todo (할 일)
CREATE TABLE IF NOT EXISTS todo (
    id INT AUTO_INCREMENT PRIMARY KEY,
    group_id INT NOT NULL,
    title VARCHAR(200) NOT NULL,
    assigned_to INT,
    status VARCHAR(20) DEFAULT '미신청',
    due_date DATETIME,
    completed BOOLEAN DEFAULT FALSE,
    difficulty_point INT DEFAULT 3,
    FOREIGN KEY (group_id) REFERENCES `group`(id) ON DELETE CASCADE,
    FOREIGN KEY (assigned_to) REFERENCES member(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 6. history (수행 기록)
CREATE TABLE IF NOT EXISTS history (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    todo_id INT NOT NULL,
    completed_at DATETIME DEFAULT NOW(),
    photo VARCHAR(255),
    memo TEXT,
    score INT,
    `check` BOOLEAN DEFAULT FALSE,
    check_member INT,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE,
    FOREIGN KEY (todo_id) REFERENCES todo(id) ON DELETE CASCADE,
    FOREIGN KEY (check_member) REFERENCES member(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 7. wallet (가계부)
CREATE TABLE IF NOT EXISTS wallet (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    group_id INT,
    item_name VARCHAR(100) NOT NULL,
    category VARCHAR(50),
    price INT NOT NULL,
    quantity INT DEFAULT 1,
    unit VARCHAR(50),
    unit_count INT DEFAULT 1,
    store VARCHAR(100),
    type ENUM('수입', '지출') NOT NULL,
    purchase_date DATE NOT NULL,
    memo TEXT,
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES `group`(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 8. history_comment (댓글)
CREATE TABLE IF NOT EXISTS history_comment (
    id INT AUTO_INCREMENT PRIMARY KEY,
    history_id INT NOT NULL,
    member_id INT NOT NULL,
    content TEXT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP,
    FOREIGN KEY (history_id) REFERENCES history(id) ON DELETE CASCADE,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE
) ENGINE=InnoDB;

-- 9. schedule (일정)
CREATE TABLE IF NOT EXISTS schedule (
    id INT AUTO_INCREMENT PRIMARY KEY,
    member_id INT NOT NULL,
    group_id INT,
    title VARCHAR(200) NOT NULL,
    memo TEXT,
    schedule_date DATE NOT NULL,
    visibility ENUM('private', 'group') DEFAULT 'private',
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    FOREIGN KEY (member_id) REFERENCES member(id) ON DELETE CASCADE,
    FOREIGN KEY (group_id) REFERENCES `group`(id) ON DELETE SET NULL
) ENGINE=InnoDB;

-- 10. needed_item (필요 물품)
CREATE TABLE IF NOT EXISTS needed_item (
    id INT PRIMARY KEY AUTO_INCREMENT,
    group_id INT NOT NULL,
    item_name VARCHAR(100) NOT NULL,
    quantity INT DEFAULT 1,
    added_by INT NOT NULL,
    is_purchased BOOLEAN DEFAULT FALSE,
    memo TEXT,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    updated_at DATETIME DEFAULT CURRENT_TIMESTAMP ON UPDATE CURRENT_TIMESTAMP
) ENGINE=InnoDB;
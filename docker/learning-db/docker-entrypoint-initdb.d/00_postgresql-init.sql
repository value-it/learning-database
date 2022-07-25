CREATE ROLE "learning-user" LOGIN PASSWORD 'weak-password';

CREATE
DATABASE learning_db
    OWNER "learning-user"
    ENCODING 'UTF-8'
    LC_COLLATE 'ja_JP.UTF-8'
    LC_CTYPE 'ja_JP.UTF-8'
    TEMPLATE template0;

GRANT ALL PRIVILEGES ON DATABASE
learning_db TO "learning-user";

--ユーザーを切り替え
\c learning_db "learning-user"

CREATE TABLE employees
(
    emp_no     INT         NOT NULL,
    birth_date DATE        NOT NULL,
    first_name VARCHAR(14) NOT NULL,
    last_name  VARCHAR(16) NOT NULL,
    gender     CHAR(1)     NOT NULL,
    hire_date  DATE        NOT NULL,
    PRIMARY KEY (emp_no)
);

CREATE TABLE departments
(
    dept_no   CHAR(4)     NOT NULL,
    dept_name VARCHAR(40) NOT NULL,
    PRIMARY KEY (dept_no),
    UNIQUE (dept_name)
);


CREATE TABLE dept_manager
(
    emp_no    INT     NOT NULL,
    dept_no   CHAR(4) NOT NULL,
    from_date DATE    NOT NULL,
    to_date   DATE    NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, dept_no)
);


CREATE TABLE dept_emp
(
    emp_no    INT     NOT NULL,
    dept_no   CHAR(4) NOT NULL,
    from_date DATE    NOT NULL,
    to_date   DATE    NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    FOREIGN KEY (dept_no) REFERENCES departments (dept_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, dept_no)
);

CREATE TABLE titles
(
    emp_no    INT         NOT NULL,
    title     VARCHAR(50) NOT NULL,
    from_date DATE        NOT NULL,
    to_date   DATE,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, title, from_date)
)
;

CREATE TABLE salaries
(
    emp_no    INT         NOT NULL,
    salary    INT         NOT NULL,
    from_date DATE        NOT NULL,
    to_date   DATE        NOT NULL,
    FOREIGN KEY (emp_no) REFERENCES employees (emp_no) ON DELETE CASCADE,
    PRIMARY KEY (emp_no, from_date)
)
;

CREATE
OR REPLACE VIEW dept_emp_latest_date AS
SELECT emp_no, MAX(from_date) AS from_date, MAX(to_date) AS to_date
FROM dept_emp
GROUP BY emp_no;

-- shows only the current department for each employee
CREATE
OR REPLACE VIEW current_dept_emp AS
SELECT l.emp_no, dept_no, l.from_date, l.to_date
FROM dept_emp d
         INNER JOIN dept_emp_latest_date l
                    ON d.emp_no = l.emp_no AND d.from_date = l.from_date AND l.to_date = d.to_date;
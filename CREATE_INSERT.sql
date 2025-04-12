
/*drop table Statystyka_gracza_za_mecz;
drop table Drużyna_Mecz;
drop table Drużyna_sponsor;
drop table Gracz;
drop table SPONSOR;
drop table Druzyna;
drop table Trener;
drop table Pozycja;
drop table Mecz;
drop table Statystyki;
drop table SEZON;
drop table Hala_sportowa;*/

CREATE TABLE Druzyna (
    Nazwa varchar2(30) NOT NULL,
    Rok_założenia date NOT NULL,
    Kraj_pochodzenia varchar2(20) NOT NULL,
    iD integer NOT NULL,
    Trener_ID integer NOT NULL,
    CONSTRAINT Druzyna_pk PRIMARY KEY (iD, Trener_ID)
);

-- Table: Drużyna_Mecz
CREATE TABLE Drużyna_Mecz (
    Druzyna_iD_Gosp integer NOT NULL,
    Trener_ID_Gosp integer NOT NULL,
    Druzyna_2_iD_Gość integer NOT NULL,
    Trener_ID_Gość integer NOT NULL,
    Mecz_ID integer NOT NULL,
    Hala_sportowa_ID integer NOT NULL,
    Sezon_ID integer NOT NULL,
    CONSTRAINT Drużyna_Mecz_pk PRIMARY KEY (Druzyna_iD_Gosp, Trener_ID_Gosp, Druzyna_2_iD_Gość, Trener_ID_Gość, Mecz_ID)
);

-- Table: Drużyna_sponsor
CREATE TABLE Drużyna_sponsor (
    Sponsor_ID integer NOT NULL,
    Druzyna_iD integer NOT NULL,
    Trener_ID integer NOT NULL,
    CONSTRAINT Drużyna_sponsor_pk PRIMARY KEY (Sponsor_ID, Druzyna_iD, Trener_ID)
);

-- Table: Gracz
CREATE TABLE Gracz (
    Imię varchar2(30) NOT NULL,
    Nazwisko varchar2(30) NOT NULL,
    Data_urodzenia date NOT NULL,
    Numer integer NOT NULL,
    Druzyna_iD integer NOT NULL,
    Trener_ID integer NOT NULL,
    Pozycja_ID integer NOT NULL,
    CONSTRAINT Gracz_pk PRIMARY KEY (Numer)
);

-- Table: Hala_sportowa
CREATE TABLE Hala_sportowa (
    Nazwa varchar2(30) NOT NULL,
    Lokajizacja varchar2(50) NOT NULL,
    Pojemność integer NOT NULL,
    ID integer NOT NULL,
    CONSTRAINT Hala_sportowa_pk PRIMARY KEY (ID)
);

-- Table: Mecz
CREATE TABLE Mecz (
    Data_i_czas_meczu date NOT NULL,
    Gospodarzy varchar2(30) NOT NULL,
    Gości varchar2(30) NOT NULL,
    Wynik varchar2(10) NOT NULL,
    ID integer NOT NULL,
    Hala_sportowa_ID integer NOT NULL,
    Sezon_ID integer NOT NULL,
    CONSTRAINT Mecz_pk PRIMARY KEY (ID, Hala_sportowa_ID, Sezon_ID)
);

-- Table: Pozycja
CREATE TABLE Pozycja (
    Nazwa varchar2(20) NOT NULL,
    ID integer NOT NULL,
    CONSTRAINT Pozycja_pk PRIMARY KEY (ID)
);

-- Table: Sezon
CREATE TABLE Sezon (
    Numer integer NOT NULL,
    Rok_rozpoczęcia date NOT NULL,
    Rok_zakończenia date NOT NULL,
    ID integer NOT NULL,
    CONSTRAINT Sezon_pk PRIMARY KEY (ID)
);

-- Table: Sponsor
CREATE TABLE Sponsor (
    Firma varchar2(30) NOT NULL,
    Branża varchar2(30) NOT NULL,
    Kontakt varchar2(50) NOT NULL,
    ID integer NOT NULL,
    CONSTRAINT Sponsor_pk PRIMARY KEY (ID)
);

-- Table: Statystyka_gracza_za_mecz
CREATE TABLE Statystyka_gracza_za_mecz (
    Mecz_ID integer NOT NULL,
    Hala_sportowa_ID integer NOT NULL,
    Sezon_ID integer NOT NULL,
    Statystyki_ID integer NOT NULL,
    Gracz_Numer integer NOT NULL,
    CONSTRAINT Statystyka_gracza_za_mecz_pk PRIMARY KEY (Mecz_ID, Statystyki_ID, Gracz_Numer)
);

-- Table: Statystyki
CREATE TABLE Statystyki (
    Punkty integer NOT NULL,
    Asysty integer NOT NULL,
    Zbiórki integer NOT NULL,
    ID integer NOT NULL,
    CONSTRAINT Statystyki_pk PRIMARY KEY (ID)
);

-- Table: Trener
CREATE TABLE Trener (
    Imię varchar2(30) NOT NULL,
    Nazwisko varchar2(30) NOT NULL,
    Data_urodzenia date NOT NULL,
    Doświadczenie number(12,2) NOT NULL,
    ID integer NOT NULL,
    CONSTRAINT Trener_pk PRIMARY KEY (ID)
);

-- foreign keys
-- Reference: Drużyna_Gosp (table: Drużyna_Mecz)
ALTER TABLE Drużyna_Mecz ADD CONSTRAINT Drużyna_Gosp
FOREIGN KEY (Druzyna_iD_Gosp, Trener_ID_Gosp)
REFERENCES Druzyna (iD, Trener_ID);

-- Reference: Drużyna_Gości (table: Drużyna_Mecz)
ALTER TABLE Drużyna_Mecz ADD CONSTRAINT Drużyna_Gości
FOREIGN KEY (Druzyna_2_iD_Gość, Trener_ID_Gość)
REFERENCES Druzyna (iD, Trener_ID);

-- Reference: Drużyna_Mecz_Mecz_1 (table: Drużyna_Mecz)
ALTER TABLE Drużyna_Mecz ADD CONSTRAINT Drużyna_Mecz_Mecz_1
FOREIGN KEY (Mecz_ID, Hala_sportowa_ID, Sezon_ID)
REFERENCES Mecz (ID, Hala_sportowa_ID, Sezon_ID);

-- Reference: Drużyna_sponsor_Druzyna (table: Drużyna_sponsor)
ALTER TABLE Drużyna_sponsor ADD CONSTRAINT Drużyna_sponsor_Druzyna
FOREIGN KEY (Druzyna_iD, Trener_ID)
REFERENCES Druzyna (iD, Trener_ID);

-- Reference: Drużyna_sponsor_Sponsor (table: Drużyna_sponsor)
ALTER TABLE Drużyna_sponsor ADD CONSTRAINT Drużyna_sponsor_Sponsor
FOREIGN KEY (Sponsor_ID)
REFERENCES Sponsor (ID);

-- Reference: Dryzyna_Trener (table: Druzyna)
ALTER TABLE Druzyna ADD CONSTRAINT Dryzyna_Trener
FOREIGN KEY (Trener_ID)
REFERENCES Trener (ID);

-- Reference: Gracz_Druzyna (table: Gracz)
ALTER TABLE Gracz ADD CONSTRAINT Gracz_Druzyna
FOREIGN KEY (Druzyna_iD, Trener_ID)
REFERENCES Druzyna (iD, Trener_ID);

-- Reference: Gracz_Pozycja (table: Gracz)
ALTER TABLE Gracz ADD CONSTRAINT Gracz_Pozycja
FOREIGN KEY (Pozycja_ID)
REFERENCES Pozycja (ID);

-- Reference: Mecz_Hala_sportowa (table: Mecz)
ALTER TABLE Mecz ADD CONSTRAINT Mecz_Hala_sportowa
FOREIGN KEY (Hala_sportowa_ID)
REFERENCES Hala_sportowa (ID);

-- Reference: Mecz_Sezon (table: Mecz)
ALTER TABLE Mecz ADD CONSTRAINT Mecz_Sezon
FOREIGN KEY (Sezon_ID)
REFERENCES Sezon (ID);

-- Reference: Statystyka_gracza_za_mecz_Gracz (table: Statystyka_gracza_za_mecz)
ALTER TABLE Statystyka_gracza_za_mecz ADD CONSTRAINT Statystyka_gracza_za_mecz_Gracz
FOREIGN KEY (Gracz_Numer)
REFERENCES Gracz (Numer);

-- Reference: Statystyka_gracza_za_mecz_Mecz (table: Statystyka_gracza_za_mecz)
ALTER TABLE Statystyka_gracza_za_mecz ADD CONSTRAINT Statystyka_gracza_za_mecz_Mecz
FOREIGN KEY (Mecz_ID, Hala_sportowa_ID, Sezon_ID)
REFERENCES Mecz (ID, Hala_sportowa_ID, Sezon_ID);

-- Reference: Statystyka_gracza_za_mecz_Statystyki (table: Statystyka_gracza_za_mecz)
ALTER TABLE Statystyka_gracza_za_mecz ADD CONSTRAINT Statystyka_gracza_za_mecz_Statystyki
FOREIGN KEY (Statystyki_ID)
REFERENCES Statystyki (ID);



--Dodawanie sponsorów
INSERT INTO Sponsor VALUES ('Nike', 'Sport', 'nike@example.com', 1);
INSERT INTO Sponsor VALUES ('Adidas', 'Sport', 'adidas@example.com', 2);
INSERT INTO Sponsor VALUES ('Red Bull', 'Energy Drinks', 'redbull@example.com', 3);


--Dodawanie trenerów
INSERT INTO Trener VALUES ('Phil', 'Jackson', TO_DATE('17-09-1945', 'DD-MM-YYYY'), 20, 1);
INSERT INTO Trener VALUES ('Gregg', 'Popovich', TO_DATE('28-01-1949', 'DD-MM-YYYY'), 25, 2);
INSERT INTO Trener VALUES ('Pat', 'Riley', TO_DATE('20-03-1945', 'DD-MM-YYYY'), 15, 3);
INSERT INTO Trener VALUES ('Erik', 'Spoelstra', TO_DATE('01-11-1970', 'DD-MM-YYYY'), 12, 4);


--Dodawanie pozycji
INSERT INTO Pozycja VALUES ('Point Guard', 1);
INSERT INTO Pozycja VALUES ('Shooting Guard', 2);
INSERT INTO Pozycja VALUES ('Small Forward', 3);
INSERT INTO Pozycja VALUES ('Power Forward', 4);
INSERT INTO Pozycja VALUES ('Center', 5);


--Dodawanie druzyny
INSERT INTO DRUZYNA VALUES ('Los Angeles Lakers', TO_DATE('16-01-1947', 'DD-MM-YYYY'), 'USA', 1, 3);
INSERT INTO DRUZYNA VALUES ('San Antonio Spurs', TO_DATE('16-01-1967', 'DD-MM-YYYY'), 'USA', 2, 2);
INSERT INTO DRUZYNA VALUES ('Golden State Warriors', TO_DATE('16-01-1946', 'DD-MM-YYYY'), 'USA', 3, 1);
INSERT INTO DRUZYNA VALUES ('Miami Heat', TO_DATE('16-01-1988', 'DD-MM-YYYY'), 'USA', 4, 3);
INSERT INTO DRUZYNA VALUES ('Chicago Bulls', TO_DATE('16-01-1966', 'DD-MM-YYYY'), 'USA', 5, 4);


--Dodawanie Hali
INSERT INTO Hala_sportowa VALUES ('Staples Center', 'Los Angeles', 1900, 1);
INSERT INTO Hala_sportowa VALUES ('AT&T Center', 'San Antonio', 1850, 2);
INSERT INTO Hala_sportowa VALUES ('Chase Center', 'San Francisco', 1800, 3);
INSERT INTO Hala_sportowa VALUES ('AmericanAirlines Arena', 'Miami', 2000, 4);
INSERT INTO Hala_sportowa VALUES ('United Center', 'Chicago', 2200, 5);


--Dodawanie Sezonu
INSERT INTO Sezon VALUES (2018/2019, TO_DATE('01-10-2018', 'DD-MM-YYYY'), TO_DATE('30-06-2019', 'DD-MM-YYYY'), 1);
INSERT INTO Sezon VALUES (2019/2020, TO_DATE('01-10-2019', 'DD-MM-YYYY'), TO_DATE('30-06-2020', 'DD-MM-YYYY'), 2);
INSERT INTO Sezon VALUES (2020/2021, TO_DATE('01-10-2020', 'DD-MM-YYYY'), TO_DATE('30-06-2021', 'DD-MM-YYYY'), 3);
INSERT INTO Sezon VALUES (2021/2022, TO_DATE('01-10-2021', 'DD-MM-YYYY'), TO_DATE('30-06-2022', 'DD-MM-YYYY'), 4);
INSERT INTO Sezon VALUES (2022/2023, TO_DATE('01-10-2022', 'DD-MM-YYYY'), TO_DATE('30-06-2023', 'DD-MM-YYYY'), 5);


--Dodawanie Meczu
INSERT INTO Mecz VALUES (TO_DATE('25-12-2020 18:00', 'DD-MM-YYYY HH24:MI'), 'Los Angeles Lakers', 'Golden State Warriors', '102-99', 1, 1, 1);
INSERT INTO Mecz VALUES (TO_DATE('25-12-2020 21:00', 'DD-MM-YYYY HH24:MI'), 'Miami Heat', 'San Antonio Spurs', '95-90', 2, 4, 2);
INSERT INTO Mecz VALUES (TO_DATE('25-12-2020 19:30', 'DD-MM-YYYY HH24:MI'), 'Chicago Bulls', 'Miami Heat', '110-108', 3, 5, 3);
INSERT INTO Mecz VALUES (TO_DATE('25-12-2020 20:00', 'DD-MM-YYYY HH24:MI'), 'San Antonio Spurs', 'Golden State Warriors', '85-87', 4, 2, 4);
INSERT INTO Mecz VALUES (TO_DATE('25-12-2020 22:00', 'DD-MM-YYYY HH24:MI'), 'Los Angeles Lakers', 'Chicago Bulls', '98-95', 5, 1, 5);



--Dodawanie Statystyki
INSERT INTO Statystyki VALUES (25, 8, 10, 1);
INSERT INTO Statystyki VALUES (30, 5, 5, 2);
INSERT INTO Statystyki VALUES (20, 10, 12, 3);
INSERT INTO Statystyki VALUES (15, 7, 9, 4);
INSERT INTO Statystyki VALUES (28, 6, 7, 5);


-- Dodawanie Gracza
INSERT INTO Gracz VALUES ('LeBron', 'James', TO_DATE('30-12-1984', 'DD-MM-YYYY'), 23, 1, 3, 1);
INSERT INTO Gracz VALUES ('Kawhi', 'Leonard', TO_DATE('29-06-1991', 'DD-MM-YYYY'), 2, 2, 2, 3);
INSERT INTO Gracz VALUES ('Stephen', 'Curry', TO_DATE('14-03-1988', 'DD-MM-YYYY'), 30, 3, 1, 2);
INSERT INTO Gracz VALUES ('Jimmy', 'Butler', TO_DATE('14-09-1989', 'DD-MM-YYYY'), 22, 4, 3, 4);
INSERT INTO Gracz VALUES ('Michael', 'Jordan', TO_DATE('17-02-1963', 'DD-MM-YYYY'), 24, 5, 4, 5);
-- Dla czytelności
INSERT INTO Gracz VALUES ('Kevin', 'Durant', TO_DATE('29-09-1988', 'DD-MM-YYYY'), 7, 3, 1, 4);
INSERT INTO Gracz VALUES ('Giannis', 'Antetokounmpo', TO_DATE('06-12-1994', 'DD-MM-YYYY'), 34, 2, 2, 3);
INSERT INTO Gracz VALUES ('Kyrie', 'Irving', TO_DATE('23-03-1992', 'DD-MM-YYYY'), 11, 3, 1, 1);
INSERT INTO Gracz VALUES ('James', 'Harden', TO_DATE('26-08-1989', 'DD-MM-YYYY'), 13, 3, 1, 2);
INSERT INTO Gracz VALUES ('Anthony', 'Davis', TO_DATE('11-03-1993', 'DD-MM-YYYY'), 3, 1, 3, 5);



-- Wstawianie danych do tabel asocjacyjnych



--Drużyna_sponsor
INSERT INTO Drużyna_sponsor VALUES (1, 1, 3);
INSERT INTO Drużyna_sponsor VALUES (1, 2, 2);
INSERT INTO Drużyna_sponsor VALUES (2, 3, 1);
INSERT INTO Drużyna_sponsor VALUES (2, 4, 3);
INSERT INTO Drużyna_sponsor VALUES (3, 5, 4);


--Drużyna_Mecz
INSERT INTO Drużyna_Mecz VALUES (1, 3, 3, 1, 1, 1, 1);
INSERT INTO Drużyna_Mecz VALUES (4, 3, 2, 2, 2, 4, 2);
INSERT INTO Drużyna_Mecz VALUES (5, 4, 4, 3, 3, 5, 3);
INSERT INTO Drużyna_Mecz VALUES (2, 2, 3, 1, 4, 2, 4);
INSERT INTO Drużyna_Mecz VALUES (1, 3, 5, 4, 5, 1, 5);



--STATYSTYKA_GRACZA_ZA_MECZ
INSERT INTO STATYSTYKA_GRACZA_ZA_MECZ VALUES (1, 1, 1, 1, 23);
INSERT INTO STATYSTYKA_GRACZA_ZA_MECZ VALUES (2, 4, 2, 2, 2);
INSERT INTO STATYSTYKA_GRACZA_ZA_MECZ VALUES (3, 5, 3, 3, 22);
INSERT INTO STATYSTYKA_GRACZA_ZA_MECZ VALUES (4, 2, 4, 4, 30);
INSERT INTO STATYSTYKA_GRACZA_ZA_MECZ VALUES (5, 1, 5, 5, 24);



--Sprawdzanie czy dane są dodane do tabeli
/*select *
from SPONSOR;

select *
from TRENER;

select *
from POZYCJA;

select *
from DRUZYNA;

select *
from HALA_SPORTOWA;

select *
from SEZON;

select *
from GRACZ;

select *
from MECZ;

select *
from STATYSTYKI;

select *
from DRUŻYNA_SPONSOR;

select *
from DRUŻYNA_MECZ;

select *
from STATYSTYKA_GRACZA_ZA_MECZ;*/



--Usuwanie danych
/*
TRUNCATE TABLE STATYSTYKA_GRACZA_ZA_MECZ;
TRUNCATE TABLE DRUŻYNA_MECZ;
TRUNCATE TABLE DRUŻYNA_SPONSOR;
TRUNCATE TABLE GRACZ;
TRUNCATE TABLE SPONSOR;
TRUNCATE TABLE DRUZYNA;
TRUNCATE TABLE TRENER;
TRUNCATE TABLE POZYCJA;
TRUNCATE TABLE MECZ;
TRUNCATE TABLE STATYSTYKI;
TRUNCATE TABLE SEZON;
TRUNCATE TABLE HALA_SPORTOWA;*/


select * from SEZON;


-- The procedure get_player_stats is designed to retrieve and calculate total statistics (points, assists, rebounds) for
-- a specific player during a given season in the basketball database. It takes a player's number and season ID as input
-- parameters and returns three values: total points, assists, and rebounds for that period.


CREATE OR REPLACE FUNCTION get_player_stats
(
    p_player_number IN INTEGER,
    p_season_id IN INTEGER
)
RETURN VARCHAR2
AS
    v_total_points INTEGER;
    v_total_assists INTEGER;
    v_total_rebounds INTEGER;
    v_result VARCHAR2(100);
BEGIN
    SELECT
        NVL(SUM(s.Punkty), 0),
        NVL(SUM(s.Asysty), 0),
        NVL(SUM(s.Zbiórki), 0)
    INTO
        v_total_points,
        v_total_assists,
        v_total_rebounds
    FROM Statystyka_gracza_za_mecz sgm
    JOIN Statystyki s ON sgm.Statystyki_ID = s.ID
    JOIN Mecz m ON sgm.Mecz_ID = m.ID
    WHERE sgm.Gracz_Numer = p_player_number
    AND m.Sezon_ID = p_season_id;

    v_result := 'Points: ' || v_total_points || ', Assists: ' || v_total_assists || ', Rebounds: ' || v_total_rebounds;

    RETURN v_result;
END;

SELECT get_player_stats(23, 1) AS player_statistics FROM DUAL;



-- The function get_team_players_stats is designed to retrieve information about all players from a specific team
-- and their statistics. It uses a cursor to iterate through all players, collecting their names, positions, and
-- statistical data (points, assists, rebounds). For each player, it shows their personal information and performance
-- metrics. The function takes a team ID as an input parameter and returns a formatted string containing the complete
-- team roster with statistics.


CREATE OR REPLACE FUNCTION get_team_players_stats
(
    p_team_id IN INTEGER
)
RETURN VARCHAR2
AS
    v_result VARCHAR2(4000);
    v_player_name VARCHAR2(60);
    v_position VARCHAR2(20);
    v_points NUMBER;
    v_assists NUMBER;
    v_rebounds NUMBER;
    CURSOR player_cursor
    IS
        SELECT
            g.Imię || ' ' || g.Nazwisko as full_name,
            p.Nazwa as Position,
            NVL(SUM(s.Punkty), 0) as Total_Points,
            NVL(SUM(s.Asysty), 0) as Total_Assists,
            NVL(SUM(s.Zbiórki), 0) as Total_Rebounds
        FROM Gracz g
        LEFT JOIN Pozycja p ON g.Pozycja_ID = p.ID
        LEFT JOIN Statystyka_gracza_za_mecz sgm ON g.Numer = sgm.Gracz_Numer
        LEFT JOIN Statystyki s ON sgm.Statystyki_ID = s.ID
        WHERE g.Druzyna_iD = p_team_id
        GROUP BY g.Imię, g.Nazwisko, p.Nazwa;
BEGIN
    v_result := 'Team Players Statistics:' || CHR(10);

    OPEN player_cursor;
    LOOP
        FETCH player_cursor INTO v_player_name, v_position, v_points, v_assists, v_rebounds;
        EXIT WHEN player_cursor%NOTFOUND;

        v_result := v_result || v_player_name || ' (' || v_position || ') - ' ||
                   'Points: ' || v_points ||
                   ', Assists: ' || v_assists ||
                   ', Rebounds: ' || v_rebounds || CHR(10);
    END LOOP;
    CLOSE player_cursor;

    RETURN v_result;
END;


SELECT get_team_players_stats(2) AS team_statistics FROM DUAL;



-- The trigger check_player_age is designed to validate a player's age before insertion into the Gracz table.
-- It ensures that only players who are 16 years or older can be added to the database.
-- The trigger fires BEFORE INSERT operation and raises an error if the age requirement is not met.


CREATE OR REPLACE TRIGGER check_player_age
BEFORE INSERT ON Gracz
FOR EACH ROW
DECLARE
    v_age NUMBER;
BEGIN
    -- Обчислюємо вік
    v_age := FLOOR(MONTHS_BETWEEN(SYSDATE, :NEW.Data_urodzenia) / 12);

    -- Перевіряємо чи вік >= 16
    IF v_age < 16 THEN
        RAISE_APPLICATION_ERROR(-20001, 'Player must be at least 16 years old. Current age: ' || v_age);
    END IF;
END;


-- Спроба додати гравця молодше 16 років (повинна викликати помилку)
INSERT INTO Gracz VALUES ('John', 'Young', TO_DATE('2010-01-01', 'YYYY-MM-DD'), 99, 1, 3, 1);

-- Спроба додати гравця старше 16 років (повинна пройти успішно)
INSERT INTO Gracz VALUES ('John', 'Adult', TO_DATE('2000-01-01', 'YYYY-MM-DD'), 98, 1, 3, 1);


-- The trigger update_team_stats is designed to automatically update team statistics after
-- a new player statistic record is inserted into Statystyka_gracza_za_mecz table.
-- It calculates and updates the total team points, assists, and rebounds for the corresponding team.


CREATE OR REPLACE TRIGGER update_team_stats
AFTER INSERT ON Statystyka_gracza_za_mecz
FOR EACH ROW
DECLARE
    v_team_id NUMBER;
    v_total_points NUMBER;
    v_player_name VARCHAR2(100);
BEGIN
    -- Отримуємо ID команди гравця та ім'я
    SELECT g.Druzyna_iD, g.Imię || ' ' || g.Nazwisko
    INTO v_team_id, v_player_name
    FROM Gracz g
    WHERE g.Numer = :NEW.Gracz_Numer;

    -- Отримуємо кількість очок з нової статистики
    SELECT s.Punkty
    INTO v_total_points
    FROM Statystyki s
    WHERE s.ID = :NEW.Statystyki_ID;

    -- Виводимо інформацію про оновлення
    DBMS_OUTPUT.PUT_LINE('Updated statistics for team ID: ' || v_team_id);
    DBMS_OUTPUT.PUT_LINE('Player ' || v_player_name || ' added ' || v_total_points || ' points');
END;



select * from statystyki;

INSERT INTO Statystyki VALUES (15, 5, 7, 6);
INSERT INTO Statystyka_gracza_za_mecz VALUES (1, 1, 1, 6, 23);

rollback;



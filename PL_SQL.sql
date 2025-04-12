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
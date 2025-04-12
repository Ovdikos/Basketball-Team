-- The procedure compare_players is designed to compare statistics between two players.
-- This will be useful for analyzing and comparing the performance of players

drop procedure compare_players;

GO
CREATE PROCEDURE compare_players
    @player1_number INT,
    @player2_number INT
AS
BEGIN
    DECLARE @player1_name VARCHAR(100)
    DECLARE @player2_name VARCHAR(100)

    SELECT @player1_name = Imie + ' ' + Nazwisko
    FROM Gracz
    WHERE Numer = @player1_number

    SELECT @player2_name = Imie + ' ' + Nazwisko
    FROM Gracz
    WHERE Numer = @player2_number

    SELECT
        @player1_name as Player1,
        @player2_name as Player2,
        s1.Punkty as Player1_Points,
        s2.Punkty as Player2_Points,
        s1.Asysty as Player1_Assists,
        s2.Asysty as Player2_Assists,
        s1.Zbiorki as Player1_Rebounds,
        s2.Zbiorki as Player2_Rebounds
    FROM Statystyka_gracza_za_mecz sgm1
    JOIN Statystyki s1 ON sgm1.Statystyki_ID = s1.ID
    CROSS JOIN Statystyka_gracza_za_mecz sgm2
    JOIN Statystyki s2 ON sgm2.Statystyki_ID = s2.ID
    WHERE sgm1.Gracz_Numer = @player1_number
    AND sgm2.Gracz_Numer = @player2_number;
END;
GO

-- LeBron James (23) and Stephen Curry (30)
EXEC compare_players @player1_number = 23, @player2_number = 30;


GO
-- The procedure calculate_player_stats is designed to calculate and display
-- the average statistics for a specific player using a cursor
CREATE PROCEDURE calculate_player_stats
    @player_number INT
AS
BEGIN
    DECLARE @player_cursor CURSOR;
    DECLARE @points INT;
    DECLARE @assists INT;
    DECLARE @rebounds INT;
    DECLARE @player_name VARCHAR(100);
    DECLARE @total_games INT = 0;
    DECLARE @total_points INT = 0;
    DECLARE @total_assists INT = 0;
    DECLARE @total_rebounds INT = 0;

    SELECT @player_name = Imie + ' ' + Nazwisko
    FROM Gracz
    WHERE Numer = @player_number;

    SET @player_cursor = CURSOR FOR
        SELECT s.Punkty, s.Asysty, s.Zbiorki
        FROM Statystyka_gracza_za_mecz sgm
        JOIN Statystyki s ON sgm.Statystyki_ID = s.ID
        WHERE sgm.Gracz_Numer = @player_number;

    OPEN @player_cursor;
    FETCH NEXT FROM @player_cursor INTO @points, @assists, @rebounds;

    WHILE @@FETCH_STATUS = 0
    BEGIN
        SET @total_games = @total_games + 1;
        SET @total_points = @total_points + @points;
        SET @total_assists = @total_assists + @assists;
        SET @total_rebounds = @total_rebounds + @rebounds;

        FETCH NEXT FROM @player_cursor INTO @points, @assists, @rebounds;
    END;

    CLOSE @player_cursor;
    DEALLOCATE @player_cursor;

    PRINT 'Statistics for player: ' + @player_name;
    PRINT 'Games played: ' + CAST(@total_games AS VARCHAR(10));
    PRINT 'Average points: ' + CAST(CAST(@total_points AS FLOAT)/@total_games AS VARCHAR(10));
    PRINT 'Average assists: ' + CAST(CAST(@total_assists AS FLOAT)/@total_games AS VARCHAR(10));
    PRINT 'Average rebounds: ' + CAST(CAST(@total_rebounds AS FLOAT)/@total_games AS VARCHAR(10));
END;
GO


EXEC calculate_player_stats @player_number = 23;






-- T R I G G E R S




GO
-- This trigger prevents scheduling multiple games at the same arena on the same day
-- It ensures proper arena availability management and prevents scheduling conflicts
CREATE TRIGGER block_arena_double_booking
ON Mecz
INSTEAD OF INSERT
AS
BEGIN
    DECLARE @arena_id INT;
    DECLARE @game_date DATE;
    DECLARE @arena_name VARCHAR(30);
    DECLARE @home_team VARCHAR(30);
    DECLARE @away_team VARCHAR(30);

    SELECT
        @arena_id = Hala_sportowa_ID,
        @game_date = CAST(Data_i_czas_meczu AS DATE),
        @home_team = Gospodarzy,
        @away_team = Gosci
    FROM INSERTED;

    SELECT @arena_name = Nazwa
    FROM Hala_sportowa
    WHERE ID = @arena_id;

    IF EXISTS (
        SELECT 1
        FROM Mecz
        WHERE Hala_sportowa_ID = @arena_id
        AND CAST(Data_i_czas_meczu AS DATE) = @game_date
    )
    BEGIN
        DECLARE @error_msg VARCHAR(200);
        SET @error_msg = 'Cannot schedule game at ' + @arena_name +
                        ' on ' + CAST(@game_date AS VARCHAR) +
                        '. Arena is already booked for another game.';
        THROW 50001, @error_msg, 1;
        RETURN;
    END

    INSERT INTO Mecz
    SELECT * FROM INSERTED;

    PRINT 'Game ' + @home_team + ' vs ' + @away_team +
          ' successfully scheduled at ' + @arena_name +
          ' on ' + CAST(@game_date AS VARCHAR);
END;
GO

INSERT INTO Mecz
VALUES
    (CONVERT(datetime, '25-12-2020 20:00', 105), -- Same date as already exist
    'Miami Heat',
    'Los Angeles Lakers',
    '95-92',
    7,
    1, -- Staples Center (have match in this day)
    1);


    INSERT INTO Mecz
VALUES
    (CONVERT(datetime, '26-12-2020 20:00', 105), -- next day(must work)
    'Miami Heat',
    'Los Angeles Lakers',
    '95-92',
    7,
    1,
    1);



GO
-- This trigger prevents deletion of players who have statistics recorded
-- This ensures data integrity and historical record preservation
CREATE TRIGGER prevent_player_deletion
ON Gracz
INSTEAD OF DELETE
AS
BEGIN
    DECLARE @player_number INT;
    DECLARE @has_stats BIT = 0;

    SELECT @player_number = Numer
    FROM DELETED;

    IF EXISTS (
        SELECT 1
        FROM Statystyka_gracza_za_mecz
        WHERE Gracz_Numer = @player_number
    )
    BEGIN
        THROW 50002, 'Cannot delete player with existing statistics', 1;
        RETURN;
    END

    DELETE FROM Gracz
    WHERE Numer = @player_number;
END;
GO

-- Trying do delete a player with statystic(EROR)
DELETE FROM Gracz WHERE Numer = 23;

-- Player without statystic(GOOD)
DELETE FROM Gracz WHERE Numer = 101;













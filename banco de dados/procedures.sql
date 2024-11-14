-- Stored procedures
CREATE or ALTER PROCEDURE GetTotalExerciciosLastSevenDays
    @idUsuario INT
AS
BEGIN
    SELECT 
        --e.dataEstudo AS Dia,
        SUM(e.qtosExercicios) AS TotalExerciciosFeitos
    FROM 
        Aprendize.Estudo e
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE)) 
        AND e.dataEstudo <= CAST(GETDATE() AS DATE) 
    GROUP BY 
        e.dataEstudo
    ORDER BY 
        e.dataEstudo ASC;

    -- Check if any results were found
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT 'No exercises found for the last seven days.' AS Message;
    END
END;

----------------------------------------------------------------------------------------------------------------------

CREATE or ALTER PROCEDURE GetTotalExerciciosLastFourWeeks
    @idUsuario INT
AS
BEGIN
    SELECT 
        --DATEPART(WEEK, e.dataEstudo) AS Semana,
        --MIN(e.dataEstudo) AS InicioSemana,
        --MAX(e.dataEstudo) AS FimSemana,
        SUM(e.qtosExercicios) AS TotalExerciciosFeitos
    FROM 
        Aprendize.Estudo e
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(WEEK, -4, CAST(GETDATE() AS DATE))  
        AND e.dataEstudo <= CAST(GETDATE() AS DATE)  
    GROUP BY 
        DATEPART(WEEK, e.dataEstudo)
    ORDER BY 
        DATEPART(WEEK, e.dataEstudo) ASC; -- CONFERIR SE ESTÁ INDO DO MAIS VELHO PARA O MAIS NOVO

    -- Check if any results were found
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT 'No exercises found for the last four weeks.' AS Message;
    END
END;

----------------------------------------------------------------------------------------------------------------------

CREATE or ALTER PROCEDURE GetTotalTempoLastSevenDays
    @idUsuario INT
AS
BEGIN
    SELECT 
        --e.dataEstudo AS Dia,
        SUM(DATEDIFF(SECOND, '00:00:00', e.qtoTempo)) AS TotalTempoSegundos
    FROM 
        Aprendize.Estudo e
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE)) 
        AND e.dataEstudo <= CAST(GETDATE() AS DATE) 
    GROUP BY 
        e.dataEstudo
    ORDER BY 
        e.dataEstudo ASC;

    -- Check if any results were found
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT 'No time spent found for the last seven days.' AS Message;
    END
END;

----------------------------------------------------------------------------------------------------------------------

CREATE or ALTER PROCEDURE GetTotalTempoLastFourWeeks
    @idUsuario INT
AS
BEGIN
    SELECT 
        --DATEPART(WEEK, e.dataEstudo) AS Semana,
        --MIN(e.dataEstudo) AS InicioSemana,
        --MAX(e.dataEstudo) AS FimSemana,
        SUM(DATEDIFF(SECOND, '00:00:00', e.qtoTempo)) AS TotalTempoSegundos
    FROM 
        Aprendize.Estudo e
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(WEEK, -4, CAST(GETDATE() AS DATE))  
        AND e.dataEstudo <= CAST(GETDATE() AS DATE)  
    GROUP BY 
        DATEPART(WEEK, e.dataEstudo)
    ORDER BY 
        DATEPART(WEEK, e.dataEstudo) ASC;

    -- Check if any results were found
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT 'No time spent found for the last four weeks.' AS Message;
    END
END;

-- Stored procedures
CREATE PROCEDURE GetTotalExerciciosLastSevenDays
    @idUsuario INT
AS
BEGIN
    SELECT 
        e.dataEstudo AS Dia,
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

CREATE PROCEDURE GetTotalExerciciosLastFourWeeks
    @idUsuario INT
AS
BEGIN
    SELECT 
        DATEPART(WEEK, e.dataEstudo) AS Semana,
        MIN(e.dataEstudo) AS InicioSemana,
        MAX(e.dataEstudo) AS FimSemana,
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
        Semana ASC;

    -- Check if any results were found
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT 'No exercises found for the last four weeks.' AS Message;
    END
END;

----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GetTotalTempoLastSevenDays
    @idUsuario INT
AS
BEGIN
    SELECT 
        e.dataEstudo AS Dia,
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

CREATE PROCEDURE GetTotalTempoLastFourWeeks
    @idUsuario INT
AS
BEGIN
    SELECT 
        DATEPART(WEEK, e.dataEstudo) AS Semana,
        MIN(e.dataEstudo) AS InicioSemana,
        MAX(e.dataEstudo) AS FimSemana,
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
        Semana ASC;

    -- Check if any results were found
    IF @@ROWCOUNT = 0
    BEGIN
        SELECT 'No time spent found for the last four weeks.' AS Message;
    END
END;

----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GetTopMateriasAndAverageExerciciosLastFourWeeks
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked materias
    CREATE TABLE #RankedMaterias (
        NomeMateria VARCHAR(100),
        TotalExercicios INT,
        MateriaRank INT
    );

    -- Insert the ranked materias into the temporary table
    INSERT INTO #RankedMaterias
    SELECT 
        m.nome AS NomeMateria,
        SUM(e.qtosExercicios) AS TotalExercicios,
        ROW_NUMBER() OVER (ORDER BY SUM(e.qtosExercicios) DESC) AS MateriaRank
    FROM 
        Aprendize.Estudo e
    INNER JOIN 
        Aprendize.Topico t ON e.idTopico = t.idTopico
    INNER JOIN 
        Aprendize.Materia m ON t.idMateria = m.idMateria
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(WEEK, -4, CAST(GETDATE() AS DATE))  -- Last 4 weeks
        AND e.dataEstudo <= CAST(GETDATE() AS DATE) 
    GROUP BY 
        m.nome;

    -- Select top 9 materias
    SELECT 
        NomeMateria,
        TotalExercicios
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank <= 9
    ORDER BY 
        TotalExercicios DESC;

    -- Calculate the average of the non-top 9 materias
    SELECT 
        AVG(TotalExercicios) AS AvgExerciciosNonTop9
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank > 9;

    -- Drop the temporary table
    DROP TABLE #RankedMaterias;
END;

----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GetTopMateriasAndAverageExerciciosLastSixMonths
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked materias
    CREATE TABLE #RankedMaterias (
        NomeMateria VARCHAR(100),
        TotalExercicios INT,
        MateriaRank INT
    );

    -- Insert the ranked materias into the temporary table
    INSERT INTO #RankedMaterias
    SELECT 
        m.nome AS NomeMateria,
        SUM(e.qtosExercicios) AS TotalExercicios,
        ROW_NUMBER() OVER (ORDER BY SUM(e.qtosExercicios) DESC) AS MateriaRank
    FROM 
        Aprendize.Estudo e
    INNER JOIN 
        Aprendize.Topico t ON e.idTopico = t.idTopico
    INNER JOIN 
        Aprendize.Materia m ON t.idMateria = m.idMateria
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(MONTH, -6, CAST(GETDATE() AS DATE))  -- Last 6 months
        AND e.dataEstudo <= CAST(GETDATE() AS DATE) 
    GROUP BY 
        m.nome;

    -- Select top 9 materias
    SELECT 
        NomeMateria,
        TotalExercicios
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank <= 9
    ORDER BY 
        TotalExercicios DESC;

    -- Calculate the average of the non-top 9 materias
    SELECT 
        AVG(TotalExercicios) AS AvgExerciciosNonTop9
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank > 9;

    -- Drop the temporary table
    DROP TABLE #RankedMaterias;
END;

----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GetTopMateriasAndAverageTempoLastFourWeeks
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked materias
    CREATE TABLE #RankedMaterias (
        NomeMateria VARCHAR(100),
        TotalTempo INT,  -- Store total time in seconds for easier calculations
        MateriaRank INT
    );

    -- Insert the ranked materias into the temporary table
    INSERT INTO #RankedMaterias
    SELECT 
        m.nome AS NomeMateria,
        SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) AS TotalTempo,  -- Sum in seconds
        ROW_NUMBER() OVER (ORDER BY SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) DESC) AS MateriaRank
    FROM 
        Aprendize.Estudo e
    INNER JOIN 
        Aprendize.Topico t ON e.idTopico = t.idTopico
    INNER JOIN 
        Aprendize.Materia m ON t.idMateria = m.idMateria
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(WEEK, -4, CAST(GETDATE() AS DATE))  -- Last 4 weeks
        AND e.dataEstudo <= CAST(GETDATE() AS DATE) 
    GROUP BY 
        m.nome;

    -- Select top 9 materias with total time converted back to time format
    SELECT 
        NomeMateria,
        CAST(DATEADD(SECOND, TotalTempo, '00:00:00') AS TIME) AS TotalTempo  -- Convert seconds back to TIME format
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank <= 9
    ORDER BY 
        TotalTempo DESC;

    -- Calculate the average of the non-top 9 materias
    SELECT 
        CAST(DATEADD(SECOND, AVG(TotalTempo), '00:00:00') AS TIME) AS AvgTempoNonTop9  -- Average time converted back to TIME format
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank > 9;

    -- Drop the temporary table
    DROP TABLE #RankedMaterias;
END;

----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GetTopMateriasAndAverageTempoLastSixMonths
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked materias
    CREATE TABLE #RankedMaterias (
        NomeMateria VARCHAR(100),
        TotalTempo INT,  -- Store total time in seconds for easier calculations
        MateriaRank INT
    );

    -- Insert the ranked materias into the temporary table
    INSERT INTO #RankedMaterias
    SELECT 
        m.nome AS NomeMateria,
        SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) AS TotalTempo,  -- Sum in seconds
        ROW_NUMBER() OVER (ORDER BY SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) DESC) AS MateriaRank
    FROM 
        Aprendize.Estudo e
    INNER JOIN 
        Aprendize.Topico t ON e.idTopico = t.idTopico
    INNER JOIN 
        Aprendize.Materia m ON t.idMateria = m.idMateria
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(MONTH, -6, CAST(GETDATE() AS DATE))  -- Last 6 months
        AND e.dataEstudo <= CAST(GETDATE() AS DATE) 
    GROUP BY 
        m.nome;

    -- Select top 9 materias with total time converted back to time format
    SELECT 
        NomeMateria,
        CAST(DATEADD(SECOND, TotalTempo, '00:00:00') AS TIME) AS TotalTempo  -- Convert seconds back to TIME format
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank <= 9
    ORDER BY 
        TotalTempo DESC;

    -- Calculate the average of the non-top 9 materias
    SELECT 
        CAST(DATEADD(SECOND, AVG(TotalTempo), '00:00:00') AS TIME) AS AvgTempoNonTop9  -- Average time converted back to TIME format
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank > 9;

    -- Drop the temporary table
    DROP TABLE #RankedMaterias;
END;

----------------------------------------------------------------------------------------------------------------------
CREATE PROCEDURE GetTopColecoesAndAverageExerciciosLastFourWeeks
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked collections
    CREATE TABLE #RankedColecoes (
        NomeColecao VARCHAR(100),  -- Store collection name
        TotalExercicios INT,  -- Store total exercises
        ColecaoRank INT
    );

    -- Insert the ranked collections into the temporary table
    INSERT INTO #RankedColecoes
    SELECT 
        c.nome AS NomeColecao,  -- Include the collection name
        SUM(e.qtosExercicios) AS TotalExercicios,  -- Sum total exercises
        ROW_NUMBER() OVER (ORDER BY SUM(e.qtosExercicios) DESC) AS ColecaoRank
    FROM 
        Aprendize.Estudo e
    INNER JOIN 
        Aprendize.Topico t ON e.idTopico = t.idTopico
    INNER JOIN 
        Aprendize.Materia m ON t.idMateria = m.idMateria
    INNER JOIN 
        Aprendize.Colecao c ON m.idColecao = c.idColecao  -- Join with the collection table
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(WEEK, -4, CAST(GETDATE() AS DATE))  -- Last 4 weeks
        AND e.dataEstudo <= CAST(GETDATE() AS DATE) 
    GROUP BY 
        c.nome;  -- Group by collection

    -- Select top 9 collections with total exercises
    SELECT 
        NomeColecao,
        TotalExercicios
    FROM 
        #RankedColecoes
    WHERE 
        ColecaoRank <= 9
    ORDER BY 
        TotalExercicios DESC;

    -- Calculate the average of the non-top 9 collections
    SELECT 
        AVG(TotalExercicios) AS AvgExerciciosNonTop9  -- Average exercises for non-top 9
    FROM 
        #RankedColecoes
    WHERE 
        ColecaoRank > 9;

    -- Drop the temporary table
    DROP TABLE #RankedColecoes;
END;


----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GetTopColecoesAndAverageExerciciosLastSixMonths
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked collections
    CREATE TABLE #RankedColecoes (
        NomeColecao VARCHAR(100),  -- Store collection name
        TotalExercicios INT,  -- Store total exercises
        ColecaoRank INT
    );

    -- Insert the ranked collections into the temporary table
    INSERT INTO #RankedColecoes
    SELECT 
        c.nome AS NomeColecao,  -- Include the collection name
        SUM(e.qtosExercicios) AS TotalExercicios,  -- Sum total exercises
        ROW_NUMBER() OVER (ORDER BY SUM(e.qtosExercicios) DESC) AS ColecaoRank
    FROM 
        Aprendize.Estudo e
    INNER JOIN 
        Aprendize.Topico t ON e.idTopico = t.idTopico
    INNER JOIN 
        Aprendize.Materia m ON t.idMateria = m.idMateria
    INNER JOIN 
        Aprendize.Colecao c ON m.idColecao = c.idColecao  -- Join with the collection table
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(MONTH, -6, CAST(GETDATE() AS DATE))  -- Last 6 months
        AND e.dataEstudo <= CAST(GETDATE() AS DATE) 
    GROUP BY 
        c.nome;  -- Group by collection

    -- Select top 9 collections with total exercises
    SELECT 
        NomeColecao,
        TotalExercicios
    FROM 
        #RankedColecoes
    WHERE 
        ColecaoRank <= 9
    ORDER BY 
        TotalExercicios DESC;

    -- Calculate the average of the non-top 9 collections
    SELECT 
        AVG(TotalExercicios) AS AvgExerciciosNonTop9  -- Average exercises for non-top 9
    FROM 
        #RankedColecoes
    WHERE 
        ColecaoRank > 9;

    -- Drop the temporary table
    DROP TABLE #RankedColecoes;
END;

----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GetTopColecoesAndAverageTempoLastFourWeeks
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked collections
    CREATE TABLE #RankedColecoes (
        NomeColecao VARCHAR(100),
        TotalTempo INT,  -- Store total time in seconds for easier calculations
        ColecaoRank INT
    );

    -- Insert the ranked collections into the temporary table
    INSERT INTO #RankedColecoes
    SELECT 
        c.nome AS NomeColecao,
        SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) AS TotalTempo,  -- Sum total time in seconds
        ROW_NUMBER() OVER (ORDER BY SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) DESC) AS ColecaoRank
    FROM 
        Aprendize.Estudo e
    INNER JOIN 
        Aprendize.Topico t ON e.idTopico = t.idTopico
    INNER JOIN 
        Aprendize.Materia m ON t.idMateria = m.idMateria
    INNER JOIN 
        Aprendize.Colecao c ON m.idColecao = c.idColecao  -- Join with the collection table
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(WEEK, -4, CAST(GETDATE() AS DATE))  -- Last 6 months
        AND e.dataEstudo <= CAST(GETDATE() AS DATE) 
    GROUP BY 
        c.nome;

    -- Select top 9 collections with total time converted back to time format
    SELECT 
        NomeColecao,
        CAST(DATEADD(SECOND, TotalTempo, '00:00:00') AS TIME) AS TotalTempo  -- Convert seconds back to TIME format
    FROM 
        #RankedColecoes
    WHERE 
        ColecaoRank <= 9
    ORDER BY 
        TotalTempo DESC;

    -- Calculate the average time for non-top 9 collections
    SELECT 
        CAST(DATEADD(SECOND, AVG(TotalTempo), '00:00:00') AS TIME) AS AvgTempoNonTop9  -- Average time converted back to TIME format
    FROM 
        #RankedColecoes
    WHERE 
        ColecaoRank > 9;

    -- Drop the temporary table
    DROP TABLE #RankedColecoes;
END;



----------------------------------------------------------------------------------------------------------------------

CREATE PROCEDURE GetTopColecoesAndAverageTempoLastSixMonths
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked collections
    CREATE TABLE #RankedColecoes (
        NomeColecao VARCHAR(100),
        TotalTempo INT,  -- Store total time in seconds for easier calculations
        ColecaoRank INT
    );

    -- Insert the ranked collections into the temporary table
    INSERT INTO #RankedColecoes
    SELECT 
        c.nome AS NomeColecao,
        SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) AS TotalTempo,  -- Sum total time in seconds
        ROW_NUMBER() OVER (ORDER BY SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) DESC) AS ColecaoRank
    FROM 
        Aprendize.Estudo e
    INNER JOIN 
        Aprendize.Topico t ON e.idTopico = t.idTopico
    INNER JOIN 
        Aprendize.Materia m ON t.idMateria = m.idMateria
    INNER JOIN 
        Aprendize.Colecao c ON m.idColecao = c.idColecao  -- Join with the collection table
    WHERE 
        e.idUsuario = @idUsuario
        AND e.dataEstudo >= DATEADD(MONTH, -6, CAST(GETDATE() AS DATE))  -- Last 6 months
        AND e.dataEstudo <= CAST(GETDATE() AS DATE) 
    GROUP BY 
        c.nome;

    -- Select top 9 collections with total time converted back to time format
    SELECT 
        NomeColecao,
        CAST(DATEADD(SECOND, TotalTempo, '00:00:00') AS TIME) AS TotalTempo  -- Convert seconds back to TIME format
    FROM 
        #RankedColecoes
    WHERE 
        ColecaoRank <= 9
    ORDER BY 
        TotalTempo DESC;

    -- Calculate the average time for non-top 9 collections
    SELECT 
        CAST(DATEADD(SECOND, AVG(TotalTempo), '00:00:00') AS TIME) AS AvgTempoNonTop9  -- Average time converted back to TIME format
    FROM 
        #RankedColecoes
    WHERE 
        ColecaoRank > 9;

    -- Drop the temporary table
    DROP TABLE #RankedColecoes;
END;
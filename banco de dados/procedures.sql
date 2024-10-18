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

CREATE PROCEDURE GetTopMateriasAndAverageExerciciosLastSevenDays
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
        AND e.dataEstudo >= DATEADD(DAY, -7, CAST(GETDATE() AS DATE))  -- Last 7 days
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


CREATE PROCEDURE GetTopMateriasAndAverageTempoByCollectionLastSixMonths
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked materias
    CREATE TABLE #RankedMaterias (
        NomeMateria VARCHAR(100),
        NomeColecao VARCHAR(100),  -- Store collection name
        TotalTempo INT,  -- Store total time in seconds for easier calculations
        MateriaRank INT
    );

    -- Insert the ranked materias into the temporary table
    INSERT INTO #RankedMaterias
    SELECT 
        m.nome AS NomeMateria,
        c.nome AS NomeColecao,  -- Include the collection name
        SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) AS TotalTempo,  -- Sum in seconds
        ROW_NUMBER() OVER (ORDER BY SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) DESC) AS MateriaRank
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
        m.nome, c.nome;  -- Group by subject and collection

    -- Select top 9 materias grouped by collection with total time converted back to time format
    SELECT 
        NomeMateria,
        NomeColecao,
        CAST(DATEADD(SECOND, TotalTempo, '00:00:00') AS TIME) AS TotalTempo,  -- Convert seconds back to TIME format
        MateriaRank
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank <= 9
    ORDER BY 
        TotalTempo DESC;

    -- Calculate the average of the non-top 9 materias

CREATE PROCEDURE GetTopMateriasAndAverageTempoByCollectionLastFourWeeks
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked materias
    CREATE TABLE #RankedMaterias (
        NomeMateria VARCHAR(100),
        NomeColecao VARCHAR(100),  -- Store collection name
        TotalTempo INT,  -- Store total time in seconds for easier calculations
        MateriaRank INT
    );

    -- Insert the ranked materias into the temporary table
    INSERT INTO #RankedMaterias
    SELECT 
        m.nome AS NomeMateria,
        c.nome AS NomeColecao,  -- Include the collection name
        SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) AS TotalTempo,  -- Sum in seconds
        ROW_NUMBER() OVER (ORDER BY SUM(DATEDIFF(SECOND, CAST('00:00:00' AS TIME), e.qtoTempo)) DESC) AS MateriaRank
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
        m.nome, c.nome;  -- Group by subject and collection

    -- Select top 9 materias grouped by collection with total time converted back to time format
    SELECT 
        NomeMateria,
        NomeColecao,
        CAST(DATEADD(SECOND, TotalTempo, '00:00:00') AS TIME) AS TotalTempo,  -- Convert seconds back to TIME format
        MateriaRank
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

CREATE PROCEDURE GetTopMateriasAndAverageExerciciosByCollectionLastFourWeeks
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked materias
    CREATE TABLE #RankedMaterias (
        NomeMateria VARCHAR(100),
        NomeColecao VARCHAR(100),  -- Store collection name
        TotalExercicios INT,  -- Store total exercises
        MateriaRank INT
    );

    -- Insert the ranked materias into the temporary table
    INSERT INTO #RankedMaterias
    SELECT 
        m.nome AS NomeMateria,
        c.nome AS NomeColecao,  -- Include the collection name
        SUM(e.qtosExercicios) AS TotalExercicios,  -- Sum total exercises
        ROW_NUMBER() OVER (ORDER BY SUM(e.qtosExercicios) DESC) AS MateriaRank
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
        m.nome, c.nome;  -- Group by subject and collection

    -- Select top 9 materias grouped by collection with total exercises
    SELECT 
        NomeMateria,
        NomeColecao,
        TotalExercicios,
        MateriaRank
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank <= 9
    ORDER BY 
        TotalExercicios DESC;

    -- Calculate the average of the non-top 9 materias
    SELECT 
        AVG(TotalExercicios) AS AvgExerciciosNonTop9  -- Average exercises for non-top 9
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank > 9;

    -- Drop the temporary table
    DROP TABLE #RankedMaterias;
END;

CREATE PROCEDURE GetTopMateriasAndAverageExerciciosByCollectionLastSixMonths
    @idUsuario INT
AS
BEGIN
    -- Create a temporary table to store the ranked materias
    CREATE TABLE #RankedMaterias (
        NomeMateria VARCHAR(100),
        NomeColecao VARCHAR(100),  -- Store collection name
        TotalExercicios INT,  -- Store total exercises
        MateriaRank INT
    );

    -- Insert the ranked materias into the temporary table
    INSERT INTO #RankedMaterias
    SELECT 
        m.nome AS NomeMateria,
        c.nome AS NomeColecao,  -- Include the collection name
        SUM(e.qtosExercicios) AS TotalExercicios,  -- Sum total exercises
        ROW_NUMBER() OVER (ORDER BY SUM(e.qtosExercicios) DESC) AS MateriaRank
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
        m.nome, c.nome;  -- Group by subject and collection

    -- Select top 9 materias grouped by collection with total exercises
    SELECT 
        NomeMateria,
        NomeColecao,
        TotalExercicios,
        MateriaRank
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank <= 9
    ORDER BY 
        TotalExercicios DESC;

    -- Calculate the average of the non-top 9 materias
    SELECT 
        AVG(TotalExercicios) AS AvgExerciciosNonTop9  -- Average exercises for non-top 9
    FROM 
        #RankedMaterias
    WHERE 
        MateriaRank > 9;

    -- Drop the temporary table
    DROP TABLE #RankedMaterias;
END;

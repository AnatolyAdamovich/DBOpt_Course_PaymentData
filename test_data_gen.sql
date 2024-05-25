USE PaymentData
GO

-- Генерация тестовых данных для таблицы PaymentParticipant
DECLARE @i INT = 1
WHILE @i <= 100
BEGIN
    INSERT INTO PaymentParticipant (Oid, Balance, Name, OptimisticLockField, GCRecord, ObjectType, ActiveFrom, InactiveFrom, BankDetails, Balance2, Balance3)
    VALUES (NEWID(), ROUND(RAND() * 1000000, 0), 'Participant ' + CAST(@i AS VARCHAR(10)), 1, NULL, ROUND(RAND() * 4, 0), DATEADD(day, ROUND(RAND() * 365, 0), '2022-01-01'), NULL, 'Bank details ' + CAST(@i AS VARCHAR(10)), ROUND(RAND() * 1000000, 0), ROUND(RAND() * 1000000, 0))
    SET @i = @i + 1
END


-- Генерация тестовых данных для таблицы Supplier
DECLARE @j INT = 1
WHILE @j <= 50
BEGIN
    INSERT INTO Supplier (Oid, Contact, ProfitByMaterialAsPayer, ProfitByMaterialAsPayee, CostByMaterialAsPayer)
    VALUES (NEWID(), 'Supplier ' + CAST(@j AS VARCHAR(10)), ROUND(RAND(), 0), ROUND(RAND(), 0), ROUND(RAND(), 0))
    SET @j = @j + 1
END

-- Генерация тестовых данных для таблицы Employee
DECLARE @k INT = 1
WHILE @k <= 50
BEGIN
    INSERT INTO Employee (Oid, BusyUntil, SecondName, Stuff, HourPrice, Patronymic, PlanfixId, Head, PlanfixMoneyRequestTask)
    VALUES (NEWID(), DATEADD(day, ROUND(RAND() * 365, 0), '2022-01-01'), 'Employee ' + CAST(@k AS VARCHAR(10)), ROUND(RAND() * 10, 0), ROUND(RAND() * 100, 0), 'Patronymic ' + CAST(@k AS VARCHAR(10)), ROUND(RAND() * 1000, 0), NULL, 'Planfix task ' + CAST(@k AS VARCHAR(10)))
    SET @k = @k + 1
END

-- Генерация тестовых данных для таблицы Project
DECLARE @l INT = 1
WHILE @l <= 50
BEGIN
    INSERT INTO Project (Oid, Name, Address, Client, Manager, Foreman, OptimisticLockField, GCRecord, Balance, BalanceByMaterial, BalanceByWork, PlaningStartDate, Status, FinishDate, Area, WorkPriceRate, WorkersPriceRate, RemainderTheAdvance, PlanfixWorkTask, PlanfixChangeRequestTask, UseAnalytics)
    VALUES (NEWID(), 'Project ' + CAST(@l AS VARCHAR(10)), 'Address ' + CAST(@l AS VARCHAR(10)), (SELECT TOP 1 Oid FROM Client ORDER BY NEWID()), (SELECT TOP 1 Oid FROM Employee ORDER BY NEWID()), (SELECT TOP 1 Oid FROM Employee ORDER BY NEWID()), 1, NULL, ROUND(RAND() * 1000000, 0), ROUND(RAND() * 1000000, 0), ROUND(RAND() * 1000000, 0), DATEADD(day, ROUND(RAND() * 365, 0), '2022-01-01'), ROUND(RAND() * 5, 0), DATEADD(day, ROUND(RAND() * 365, 0), '2022-01-01'), ROUND(RAND() * 1000, 0), RAND() * 100, RAND() * 50, ROUND(RAND() * 1000000, 0), 'Planfix work task ' + CAST(@l AS VARCHAR(10)), 'Planfix change request task ' + CAST(@l AS VARCHAR(10)), ROUND(RAND(), 0))
    SET @l = @l + 1
END

-- Генерация тестовых данных для таблицы Client
DECLARE @m INT = 1
WHILE @m <= 50
BEGIN
    INSERT INTO Client (Oid, FirstName, SecondName, Phone)
    VALUES (NEWID(), 'Client ' + CAST(@m AS VARCHAR(10)), 'Client ' + CAST(@m AS VARCHAR(10)), '555-' + CAST(@m AS VARCHAR(10)) + '-1234')
    SET @m = @m + 1
END


-- Генерация тестовых данных для таблицы Cashbox
DECLARE @n INT = 1
WHILE @n <= 50
BEGIN
    INSERT INTO Cashbox (Oid, AccountType)
    VALUES (NEWID(), (SELECT TOP 1 Oid FROM AccountType ORDER BY NEWID()))
    SET @n = @n + 1
END

-- Генерация тестовых данных для таблицы Bank
DECLARE @o INT = 1
WHILE @o <= 50
BEGIN
    INSERT INTO Bank (Oid, AccountType)
    VALUES (NEWID(), (SELECT TOP 1 Oid FROM AccountType ORDER BY NEWID()))
    SET @o = @o + 1
END

-- Генерация тестовых данных для таблицы Payment
DECLARE @p INT = 1
WHILE @p <= 1000
BEGIN
    INSERT INTO Payment (Oid, Amount, Category, Project, Justification, Comment, Date, Payer, Payee, OptimisticLockField, GCRecord, CreateDate, CheckNumber, IsAuthorized, Number)
    VALUES (NEWID(), ROUND(RAND() * 100000, 0), (SELECT TOP 1 Oid FROM PaymentCategory ORDER BY NEWID()), (SELECT TOP 1 Oid FROM Project ORDER BY NEWID()), 'Justification ' + CAST(@p AS VARCHAR(10)), 'Comment ' + CAST(@p AS VARCHAR(10)), DATEADD(day, ROUND(RAND() * 365, 0), '2022-01-01'), (SELECT TOP 1 Oid FROM PaymentParticipant ORDER BY NEWID()), (SELECT TOP 1 Oid FROM PaymentParticipant ORDER BY NEWID()), 1, NULL, DATEADD(day, ROUND(RAND() * 365, 0), '2022-01-01'), 'Check ' + CAST(@p AS VARCHAR(10)), ROUND(RAND(), 0), 'Number ' + CAST(@p AS VARCHAR(10)))
    SET @p = @p + 1
END
CREATE OR ALTER TRIGGER T_Payment_AI
ON dbo.Payment
AFTER INSERT, UPDATE 
AS
DECLARE @StartTime DATETIME, @EndTime DATETIME, @BalanceUpdateStartTime DATETIME, @BalanceUpdateEndTime DATETIME
DECLARE @TransactionDuration DECIMAL(18,2), @BalanceUpdateDuration DECIMAL(18,2), @BalanceUpdatePercentage DECIMAL(5,2)

-- Начало транзакции
SET @StartTime = GETUTCDATE()

-- Обновляем баланс у новых участников
SET @BalanceUpdateStartTime = GETUTCDATE()

-- У плательщика
UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(inserted.Payer)
FROM PaymentParticipant
JOIN Inserted ON PaymentParticipant.Oid = inserted.Payer

-- У получателя
UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(inserted.Payee)
FROM PaymentParticipant
JOIN Inserted ON PaymentParticipant.Oid = inserted.Payee

SET @BalanceUpdateEndTime = GETUTCDATE()

-- Обновляем баланс у старых участников
UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(deleted.Payer)
FROM PaymentParticipant
JOIN deleted ON PaymentParticipant.Oid = deleted.Payer

UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(deleted.Payee)
FROM PaymentParticipant
JOIN deleted ON PaymentParticipant.Oid = deleted.Payee

-- Обновляем баланс у новых объектов
UPDATE Project
SET BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(inserted.Project),
    BalanceByWork = dbo.F_CalculateBalanceByWork(inserted.Project),
    Balance = dbo.F_CalculateProjectBalance(inserted.Project)
FROM Project
JOIN Inserted ON Project.Oid = inserted.Project

-- Обновляем баланс у старых объектов
UPDATE Project
SET BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(deleted.Project),
    BalanceByWork = dbo.F_CalculateBalanceByWork(deleted.Project),
    Balance = dbo.F_CalculateProjectBalance(deleted.Project)
FROM Project
JOIN deleted ON Project.Oid = deleted.Project

-- Конец транзакции
SET @EndTime = GETUTCDATE()

-- Расчет времени выполнения транзакции
SET @TransactionDuration = DATEDIFF(ms, @StartTime, @EndTime)

-- Расчет времени, затраченного на обновление балансов
SET @BalanceUpdateDuration = DATEDIFF(ms, @BalanceUpdateStartTime, @BalanceUpdateEndTime)

-- Расчет доли времени, затраченного на обновление балансов
SET @BalanceUpdatePercentage = (@BalanceUpdateDuration * 100.0) / @TransactionDuration

PRINT 'Общее время выполнения транзакции: ' + CAST(@TransactionDuration AS VARCHAR(10)) + ' мс'
PRINT 'Время, затраченное на обновление балансов: ' + CAST(@BalanceUpdateDuration AS VARCHAR(10)) + ' мс'
PRINT 'Доля времени, затраченного на обновление балансов: ' + CAST(@BalanceUpdatePercentage AS VARCHAR(10)) + '%'

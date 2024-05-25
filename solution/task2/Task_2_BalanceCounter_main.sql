CREATE OR ALTER TRIGGER T_Payment_AI
ON dbo.Payment
AFTER INSERT, UPDATE 
AS
DECLARE @StartTime DATETIME, @EndTime DATETIME, @BalanceUpdateStartTime DATETIME, @BalanceUpdateEndTime DATETIME
DECLARE @TransactionDuration DECIMAL(18,2), @BalanceUpdateDuration DECIMAL(18,2), @BalanceUpdatePercentage DECIMAL(5,2)

-- ������ ����������
SET @StartTime = GETUTCDATE()

-- ��������� ������ � ����� ����������
SET @BalanceUpdateStartTime = GETUTCDATE()

-- � �����������
UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(inserted.Payer)
FROM PaymentParticipant
JOIN Inserted ON PaymentParticipant.Oid = inserted.Payer

-- � ����������
UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(inserted.Payee)
FROM PaymentParticipant
JOIN Inserted ON PaymentParticipant.Oid = inserted.Payee

SET @BalanceUpdateEndTime = GETUTCDATE()

-- ��������� ������ � ������ ����������
UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(deleted.Payer)
FROM PaymentParticipant
JOIN deleted ON PaymentParticipant.Oid = deleted.Payer

UPDATE PaymentParticipant
SET Balance = dbo.F_CalculatePaymentParticipantBalance(deleted.Payee)
FROM PaymentParticipant
JOIN deleted ON PaymentParticipant.Oid = deleted.Payee

-- ��������� ������ � ����� ��������
UPDATE Project
SET BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(inserted.Project),
    BalanceByWork = dbo.F_CalculateBalanceByWork(inserted.Project),
    Balance = dbo.F_CalculateProjectBalance(inserted.Project)
FROM Project
JOIN Inserted ON Project.Oid = inserted.Project

-- ��������� ������ � ������ ��������
UPDATE Project
SET BalanceByMaterial = dbo.F_CalculateBalanceByMaterial(deleted.Project),
    BalanceByWork = dbo.F_CalculateBalanceByWork(deleted.Project),
    Balance = dbo.F_CalculateProjectBalance(deleted.Project)
FROM Project
JOIN deleted ON Project.Oid = deleted.Project

-- ����� ����������
SET @EndTime = GETUTCDATE()

-- ������ ������� ���������� ����������
SET @TransactionDuration = DATEDIFF(ms, @StartTime, @EndTime)

-- ������ �������, ������������ �� ���������� ��������
SET @BalanceUpdateDuration = DATEDIFF(ms, @BalanceUpdateStartTime, @BalanceUpdateEndTime)

-- ������ ���� �������, ������������ �� ���������� ��������
SET @BalanceUpdatePercentage = (@BalanceUpdateDuration * 100.0) / @TransactionDuration

PRINT '����� ����� ���������� ����������: ' + CAST(@TransactionDuration AS VARCHAR(10)) + ' ��'
PRINT '�����, ����������� �� ���������� ��������: ' + CAST(@BalanceUpdateDuration AS VARCHAR(10)) + ' ��'
PRINT '���� �������, ������������ �� ���������� ��������: ' + CAST(@BalanceUpdatePercentage AS VARCHAR(10)) + '%'

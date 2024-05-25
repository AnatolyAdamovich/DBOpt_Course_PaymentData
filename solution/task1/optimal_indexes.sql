-- Создание некластерного индекса на столбце CostByMaterial
CREATE NONCLUSTERED INDEX IX_PaymentCategory_CostByMaterial
ON dbo.PaymentCategory (CostByMaterial)
INCLUDE (Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, NotInPaymentParticipantProfit)
GO

-- Создание некластерного индекса на столбце ProfitByMaterial  
CREATE NONCLUSTERED INDEX IX_PaymentCategory_ProfitByMaterial
ON dbo.PaymentCategory (ProfitByMaterial)
INCLUDE (Oid, Name, OptimisticLockField, GCRecord, CostByMaterial, NotInPaymentParticipantProfit)
GO

-- Создание некластерного индекса на столбце iPayment_Date
CREATE NONCLUSTERED INDEX iPayment_Date
ON dbo.Payment (Date)


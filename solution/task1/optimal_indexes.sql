-- Создание некластерного индекса на столбце CostByMaterial
CREATE NONCLUSTERED INDEX iPaymentCategory_CostByMaterial
ON dbo.PaymentCategory (CostByMaterial)
INCLUDE (Oid, Name, OptimisticLockField, GCRecord, ProfitByMaterial, NotInPaymentParticipantProfit)
GO

-- Создание некластерного индекса на столбце ProfitByMaterial  
CREATE NONCLUSTERED INDEX iPaymentCategory_ProfitByMaterial
ON dbo.PaymentCategory (ProfitByMaterial)
INCLUDE (Oid, Name, OptimisticLockField, GCRecord, CostByMaterial, NotInPaymentParticipantProfit)
GO

-- Создание некластерного индекса на столбце Date
CREATE NONCLUSTERED INDEX iPayment_Date
ON dbo.Payment (Date)

-- возможно еще подошел бы iPaymentCategory_Name
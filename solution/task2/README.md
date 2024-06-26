# Task 2
Директория содержит реализацию задач 2-го уровня

**Содержание:**
* `T_payment_AI_with_metrics.sql` - изменение триггера **T_payment_AI** таким образом, чтобы организовать сбор метрик (в данном случае -- времении). Это необходимо для количественной оценки затрат на вычисление баланса. Логика: измерить время выполнения транзакции + измерить время, затрачиваемой на обновление баланса внутри транзакции + измерить относительную долю 
* `test.sql` - файл с созданием платежа при обновленном триггере `T_payment_AI`
* Файл `сценарии оптимизации + выводы` является попыткой реализации задач 2.2 и 2.3. В файле приводится один из возможных сценариев, способных улучшить производительность целевой операции, а также рассматриваются недостатки данного подхода.  

**Результаты:**
- Общее время выполнения транзакции: 340.00 мс
- Время, затраченное на обновление балансов: 133.00 мс
- Доля времени, затраченного на обновление балансов: 39.12%

Это очень приблизительная оценка. Для более точных показателей можно:
- проанализировать данные метрики на примере большого числа транзакций (например, усреднить относительный процент или взять медиану)
- проанализировать более детально: "навесить" счетчики внутри используемых формул подсчета, чтобы вычислять ресурсы, затрачиваемые на вычисление конкретной формулы. На основе этой информации можно сделать вывод, обновление *какого* баланса (банка, кассы, клиента, поставщика) является самым неэффективным, и на основе этих данных сделать оптимизацию

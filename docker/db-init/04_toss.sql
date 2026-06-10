-- 결제 모듈을 포트원 → 토스페이먼츠로 교체 (paymentKey 저장)
ALTER TABLE orders RENAME COLUMN imp_uid TO payment_key;

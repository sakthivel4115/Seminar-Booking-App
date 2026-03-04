DECLARE @UserId INT = 1;       
DECLARE @MerchantId INT = 3;   
DECLARE @Amount DECIMAL(12,2) = 90000.00;   -- More than balance

BEGIN TRY
    BEGIN TRANSACTION;

    -- Check balance
    IF (SELECT Balance FROM Accounts 
        WHERE AccountId = @UserId AND AccountType='USER') < @Amount
    BEGIN
        RAISERROR('Insufficient balance in user account.', 16, 1);
    END

    -- Deduct
    UPDATE Accounts
    SET Balance = Balance - @Amount
    WHERE AccountId = @UserId AND AccountType='USER';

    IF @@ROWCOUNT <> 1
    BEGIN
        RAISERROR('User account not found / update failed.', 16, 1);
    END

    -- Add to merchant
    UPDATE Accounts
    SET Balance = Balance + @Amount
    WHERE AccountId = @MerchantId AND AccountType='MERCHANT';

    IF @@ROWCOUNT <> 1
    BEGIN
        RAISERROR('Merchant account not found / update failed.', 16, 1);
    END

    COMMIT TRANSACTION;
    PRINT 'Payment Successful. Transaction COMMITTED.';

END TRY
BEGIN CATCH
    IF @@TRANCOUNT > 0
        ROLLBACK TRANSACTION;

    PRINT 'Payment Failed. Transaction ROLLED BACK.';
    PRINT ERROR_MESSAGE();
END CATCH;
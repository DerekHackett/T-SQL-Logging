SET QUOTED_IDENTIFIER ON;
GO
SET ANSI_NULLS ON;
GO

CREATE PROCEDURE dbo.spLog
    @ObjectId INT,
    @DatabaseId INT = NULL,
    @LogLevel VARCHAR(5) = NULL,
    @AdditionalInfo VARCHAR(5000) = NULL
AS
BEGIN
    SET NOCOUNT ON;

    DECLARE @ObjectName NVARCHAR(400);
    DECLARE @ErrorMessage VARCHAR(5000);

    SET @ErrorMessage = CASE
                            WHEN LEN(ERROR_MESSAGE()) >= 4997 THEN
                                LEFT(ERROR_MESSAGE(), 4997) + '...'
                            ELSE
                                ERROR_MESSAGE()
                        END;

    SELECT @DatabaseId = COALESCE(@DatabaseId, DB_ID()),
           @ObjectName
               = COALESCE(
                             QUOTENAME(DB_NAME(@DatabaseId)) + '.'
                             + QUOTENAME(OBJECT_SCHEMA_NAME(@ObjectId, @DatabaseId)) + '.'
                             + QUOTENAME(OBJECT_NAME(@ObjectId, @DatabaseId)),
                             ERROR_PROCEDURE()
                         );

    INSERT dbo.Log
    (
        DatabaseId,
        ObjectId,
        LogLevel,
        ObjectName,
        CurrentUser,
        ErrorLine,
        ErrorMessage,
        AdditionalInfo
    )
    SELECT @DatabaseId,
           @ObjectId,
           CASE
               WHEN @LogLevel IS NULL THEN
                   'Error'
               ELSE
                   @LogLevel
           END,
           @ObjectName,
           SUSER_SNAME(),
           ERROR_LINE(),
           @ErrorMessage,
           @AdditionalInfo;

END;
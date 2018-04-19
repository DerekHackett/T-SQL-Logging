CREATE TABLE dbo.Log
(
    LogId INT NOT NULL IDENTITY(1, 1),
    LogDate SMALLDATETIME NOT NULL
        CONSTRAINT [DF_Log_LogDate]
            DEFAULT (GETDATE()),
    LogLevel VARCHAR(5) NOT NULL,
    DatabaseId INT NULL,
    ObjectId INT NULL,
    ObjectName VARCHAR(400),
    CurrentUser VARCHAR(50),
    ErrorLine INT NULL,
    ErrorMessage VARCHAR(5000),
    AdditionalInfo VARCHAR(5000)
) ON [PRIMARY];
GO
ALTER TABLE dbo.Log
ADD CONSTRAINT PK_Log_LogId
    PRIMARY KEY CLUSTERED (LogId) ON [PRIMARY];

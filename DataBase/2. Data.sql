-- 1. Create UserType

USE [AquariumAutomationApp]
GO

INSERT INTO [dbo].[UserTypeMaster]
           ([UserTypeName]
           ,[CreatedDate])
     VALUES
           ('sysadmin'
           ,GETDATE());
GO
INSERT INTO [dbo].[UserTypeMaster]
           ([UserTypeName]
           ,[CreatedDate])
     VALUES
           ('User'
           ,GETDATE());
GO




-- 2. Create JobStatus
INSERT INTO [dbo].[JobStatusMaster]
           ([JobStatus]
           ,[CreatedDate])
     VALUES
           ('Assigned'
           ,GETDATE());

INSERT INTO [dbo].[JobStatusMaster]
           ([JobStatus]
           ,[CreatedDate])
     VALUES
           ('Started'
           ,GETDATE());
GO

INSERT INTO [dbo].[JobStatusMaster]
           ([JobStatus]
           ,[CreatedDate])
     VALUES
           ('Pending'
           ,GETDATE());


INSERT INTO [dbo].[JobStatusMaster]
           ([JobStatus]
           ,[CreatedDate])
     VALUES
           ('Failed'
           ,GETDATE());


INSERT INTO [dbo].[JobStatusMaster]
           ([JobStatus]
           ,[CreatedDate])
     VALUES
           ('Cancelled'
           ,GETDATE());


INSERT INTO [dbo].[JobStatusMaster]
           ([JobStatus]
           ,[CreatedDate])
     VALUES
           ('Success'
           ,GETDATE());

GO

-- 3. Insert into Device type master
INSERT INTO [dbo].[DeviceTypeMaster]
           ([DeviceTypeName]
           ,[CreatedDate])
     VALUES
           ('sensor_temp'
           ,GETDATE());

INSERT INTO [dbo].[DeviceTypeMaster]
           ([DeviceTypeName]
           ,[CreatedDate])
     VALUES
           ('sensor_level'
           ,GETDATE());

INSERT INTO [dbo].[DeviceTypeMaster]
           ([DeviceTypeName]
           ,[CreatedDate])
     VALUES
           ('mech_fan'
           ,GETDATE());

INSERT INTO [dbo].[DeviceTypeMaster]
           ([DeviceTypeName]
           ,[CreatedDate])
     VALUES
           ('mech_pump'
           ,GETDATE());
GO


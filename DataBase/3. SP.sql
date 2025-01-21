USE [AquariumAutomationApp]
GO

/****** Object:  StoredProcedure [dbo].[uspRegisterUser]    Script Date: 21-01-2025 22:49:28 ******/

CREATE PROCEDURE [dbo].[uspRegisterUser] (
	@UserFirstName varchar(255),
	@UserLastname varchar(255),
	@UserEmail varchar(255),
	@UserPhoneNumber varchar(20),
	@UserTypeId int,
	@UserCreatedDate datetime,
	@PasswordHash varbinary(max),
	@PasswordSalt varbinary(max),
	@AccountCreatedDate datetime,
	@UserId int output,
	@AccountId int output
)
AS

BEGIN
    -- Begin Transaction to ensure atomicity
    BEGIN TRANSACTION;

    BEGIN TRY
        -- Declare variable to store the new primary key
        ---DECLARE @UserId INT;

        -- Insert into Table1 and get the new primary key
        INSERT INTO [dbo].[UserMaster]
           ([UserFirstName]
           ,[UserLastName]
           ,[UserEmail]
           ,[UserPhoneNumber]
           ,[UserTypeId]
		   ,[IsActive]
           ,[CreatedDate])
     VALUES
           (
				@UserFirstName,
				@UserLastName,
				@UserEmail,
				@UserPhoneNumber,
				@UserTypeId,
                1,
				@UserCreatedDate
			)

        SET @UserId = SCOPE_IDENTITY();

        -- Insert into Table2 using the primary key from Table1
        INSERT INTO [dbo].[AccountMaster]
           (
			[UserId]
           ,[PasswordHash]
           ,[PasswordSalt]
           ,[IsActive]
           ,[CreatedDate]
		   )
		VALUES
           (
				@UserId,
				@PasswordHash,
				@PasswordSalt,
                1,
				@AccountCreatedDate
			)
			SET @AccountId = SCOPE_IDENTITY();
        -- Commit the transaction
        COMMIT TRANSACTION;
    END TRY
    BEGIN CATCH
        -- Rollback the transaction in case of error
        ROLLBACK TRANSACTION;
			SET @UserId = -1;
			SET @AccountId = -1;
        -- Rethrow the error for debugging/logging
        THROW;
    END CATCH
END;
GO


/****** Object:  StoredProcedure [dbo].[uspGetUserByEmail]    Script Date: 21-01-2025 22:50:16 ******/

CREATE PROCEDURE [dbo].[uspGetUserByEmail] (@Email varchar(255))  
AS  
BEGIN    
    select 
		u.UserId, 
		a.AccountId, 
		u.UserFirstName, 
		u.UserLastName,
        u.UserEmail, 
		u.UserPhoneNumber, 
		u.UserTypeId, 
        u.CreatedDate, 
		a.PassWordHash, 
		a.PassWordSalt, 
		a.CreatedDate,
        a.IsActive 
	from 
	UserMaster as u 
	inner join 
	AccountMaster a 
	on u.UserId = a.UserId 
	where u.UserEmail=@Email  
END 
GO


/****** Object:  StoredProcedure [dbo].[uspCheckAquariumExists]    Script Date: 21-01-2025 22:53:02 ******/


CREATE PROCEDURE [dbo].[uspCheckAquariumExists]
(
	@AquariumId INT,
	@Status INT OUTPUT
)
AS
BEGIN
	BEGIN TRY
		-- Check if a row with the given AquariumId exists
		IF EXISTS (
			SELECT 1 
			FROM dbo.AquariumMaster 
			WHERE AquariumId = @AquariumId
		)
		BEGIN
			SET @Status = 1; -- Row exists
		END
		ELSE
		BEGIN
			SET @Status = 0; -- Row does not exist
		END
	END TRY
	BEGIN CATCH
		SET @Status = -1; -- Return -1 in case of any error
		THROW; -- Re-throw the error
	END CATCH
END;
GO


/****** Object:  StoredProcedure [dbo].[uspCreateAquarium]    Script Date: 21-01-2025 22:53:30 ******/


create procedure [dbo].[uspCreateAquarium]
(
	@AquariumName varchar(255),
	@AquariumDescription varchar(max),
	@UserId int,
	@IsActive bit,
	@AquariumComments varchar(max),
	@AquariumCreatedDate datetime,
	@AquariumFixedPropertyComments varchar(max),
	@Length int,
	@Height int,
	@Width int,
	@AquariumFixedPropertyCreatedDate datetime,
	@AquariumId int output,
	@AquariumFixedPropertyId int output
)
as

begin

	--begin transaction to ensure atomicity
	begin transaction;
	begin try
	--insert into dbo.AquariumMaster
		insert into dbo.AquariumMaster 
		(
			[AquariumName],
			[AquariumDescription],
			[UserId],
			[IsActive],
			[Comments],
			[CreatedDate]
		)
		values
		(
			@AquariumName,
			@AquariumDescription,
			@UserId,
			@IsActive,
			@AquariumComments,
			@AquariumCreatedDate
		)
		set @AquariumId = SCOPE_IDENTITY();

		--insert into fixed properties table
		insert into dbo.AquariumFixedProperty
		(
			[AquariumId],
			[Comments],
			[Length],
			[Height],
			[Width],
			[CreatedDate]
		)
		values
		(
			@AquariumId,
			@AquariumFixedPropertyComments,
			@Length,
			@Height,
			@Width,
			@AquariumFixedPropertyCreatedDate
		)
		set @AquariumFixedPropertyId = SCOPE_IDENTITY();
	
		-- commit the transaction
		commit transaction;
	end try
	begin catch
		--rollback transaction in case of error
		rollback transaction;
		set @AquariumId = -1;
		set @AquariumFixedPropertyId = -1;
		--rethrow error for debug/log
		throw;
	end catch
end;
GO


/****** Object:  StoredProcedure [dbo].[uspGetAquariumByAquariumId]    Script Date: 21-01-2025 22:54:09 ******/



CREATE PROCEDURE [dbo].[uspGetAquariumByAquariumId] (@AquariumId int)  
AS  
BEGIN    
    select 
		am.AquariumId,
		am.AquariumName,
		am.AquariumDescription,
		am.UserId,
		am.IsActive,
		am.Comments as AquariumComments,
		am.CreatedDate as AquariumCreatedDate,
		afp.AquariumFixedPropertyId,
		afp.Comments as AquariumFixedPropertyComments,
		afp.Length,
		afp.Height,
		afp.Width,
		afp.CreatedDate as AquariumFixedPropertyCreatedDate
	from AquariumMaster am inner join AquariumFixedProperty afp on am.AquariumId = afp.AquariumId
	where afp.AquariumId = @AquariumId;
END 
GO

USE [AquariumAutomationApp]
GO

/****** Object:  StoredProcedure [dbo].[uspGetAquariumByUserId]    Script Date: 21-01-2025 22:54:24 ******/


CREATE PROCEDURE [dbo].[uspGetAquariumByUserId] (@UserId int)  
AS  
BEGIN    
    select 
		am.AquariumId,
		am.AquariumName,
		am.AquariumDescription,
		am.UserId,
		am.IsActive,
		am.Comments as AquariumComments,
		am.CreatedDate as AquariumCreatedDate,
		afp.AquariumFixedPropertyId,
		afp.Comments as AquariumFixedPropertyComments,
		afp.Length,
		afp.Height,
		afp.Width,
		afp.CreatedDate as AquariumFixedPropertyCreatedDate
	from AquariumMaster am inner join AquariumFixedProperty afp on am.AquariumId = afp.AquariumId
	where am.UserId = @UserId;
END 
GO


/****** Object:  StoredProcedure [dbo].[uspUpdateAquarium]    Script Date: 21-01-2025 22:56:01 ******/

create procedure [dbo].[uspUpdateAquarium]
(
	@AquariumId int,
	@AquariumName varchar(255),
	@AquariumDescription varchar(max),
	@AquariumMasterComments varchar(max),
	@AquariumFixedPropertyId int,
	@AquariumFixedPropertyComments varchar(max),
	@Length int,
	@Width int,
	@Height int,
	@Status int output
)
as

begin
	--begin transaction to ensure atomicity
	begin transaction
	begin try
		update dbo.AquariumMaster
			set AquariumName = @AquariumName,
			AquariumDescription = @AquariumDescription,
			Comments = @AquariumMasterComments
		where AquariumId = @AquariumId;

		update dbo.AquariumFixedProperty
			set Comments = @AquariumFixedPropertyComments,
				Length = @Length,
				Width = @Width,
				Height = @Height
			where AquariumFixedPropertyId = @AquariumFixedPropertyId;
		SET @Status = 1;
		commit transaction;
	end try
	begin catch
		rollback transaction;
		set @Status = -1;
		throw;
	end catch
end;
GO


/****** Object:  StoredProcedure [dbo].[uspCreateAgent]    Script Date: 21-01-2025 23:01:59 ******/
create procedure [dbo].[uspCreateAgent]
(
	@AquariumId int,
	@AgentName varchar(255),
	@AgentDescription varchar(max),
	@AgentUserId int,
	@AgentWifiMacAddress varchar(255),
	@AgentBluetoothMacAddress varchar(255),
	@AgentIpAddress varchar(255),
	@IsActive bit,
	@CreatedDate datetime,
	@AgentId int output
)
as

begin

	--begin transaction to ensure atomicity
	begin transaction;
	begin try
	--insert into dbo.AgentMaster
		insert into dbo.AgentMaster 
		(
			[AquariumId]
           ,[AgentName]
           ,[AgentDescription]
           ,[AgentUserId]
           ,[AgentWifiMacAddress]
           ,[AgentBluetoothMacAddress]
           ,[AgentIpAddress]
           ,[IsActive]
           ,[CreatedDate]	
		)
		values
		(
			@AquariumId,
			@AgentName,
			@AgentDescription,
			@AgentUserId,
			@AgentWifiMacAddress,
			@AgentBluetoothMacAddress,
			@AgentIpAddress,
			@IsActive,
			@CreatedDate
		)
		set @AgentId = SCOPE_IDENTITY();
		-- commit the transaction
		commit transaction;
	end try
	begin catch
		--rollback transaction in case of error
		rollback transaction;
		set @AgentId = -1;
		--rethrow error for debug/log
		throw;
	end catch
end;
GO


/****** Object:  StoredProcedure [dbo].[uspGetAgentByAgentId]    Script Date: 21-01-2025 23:02:29 ******/

CREATE PROCEDURE [dbo].[uspGetAgentByAgentId] (@AgentId int)  
AS  
BEGIN    

SELECT [AgentId]
      ,[AquariumId]
      ,[AgentName]
      ,[AgentDescription]
      ,[AgentUserId]
      ,[AgentWifiMacAddress]
      ,[AgentBluetoothMacAddress]
      ,[AgentIpAddress]
      ,[IsActive]
      ,[CreatedDate]
  FROM [dbo].[AgentMaster] where AgentId = @AgentId
		
END 
GO


/****** Object:  StoredProcedure [dbo].[uspGetAgentByAquariumId]    Script Date: 21-01-2025 23:02:47 ******/
CREATE PROCEDURE [dbo].[uspGetAgentByAquariumId] (@AquariumId int)  
AS  
BEGIN    

SELECT [AgentId]
      ,[AquariumId]
      ,[AgentName]
      ,[AgentDescription]
      ,[AgentUserId]
      ,[AgentWifiMacAddress]
      ,[AgentBluetoothMacAddress]
      ,[AgentIpAddress]
      ,[IsActive]
      ,[CreatedDate]
  FROM [dbo].[AgentMaster] where AquariumId = @AquariumId
		
END 
GO


/****** Object:  StoredProcedure [dbo].[uspUpdateAgent]    Script Date: 21-01-2025 23:03:33 ******/
create procedure [dbo].[uspUpdateAgent]
(
	@AgentId int,
	--@AquariumId bigint,
	@AgentName varchar(255),
	@AgentDescription varchar(max),
	--@AgentUserId varchar(255),
	@AgentWifiMacAddress varchar(255),
	@AgentBluetoothMacAddress varchar(255),
	@AgentIpAddress varchar(255),
	@IsActive bit,
	@CreatedDate datetime,
	@Status int output
)
as

begin
	--begin transaction to ensure atomicity
	begin transaction
	begin try
		update dbo.AgentMaster
			set 
			AgentName = @AgentName,
			AgentDescription = @AgentDescription,
			AgentWifiMacAddress = @AgentWifiMacAddress,
			AgentBluetoothMacAddress = @AgentBluetoothMacAddress,
			AgentIpAddress = @AgentIpAddress,
			IsActive = @IsActive,
			CreatedDate = @CreatedDate
		where AgentId = @AgentId;



		SET @Status = 1;
		commit transaction;
	end try
	begin catch
		rollback transaction;
		set @Status = -1;
		throw;
	end catch
end;
GO



/****** Object:  StoredProcedure [dbo].[uspCreateDeviceType]    Script Date: 21-01-2025 23:04:34 ******/
create procedure [dbo].[uspCreateDeviceType]
(
	@DeviceTypeName varchar(255),
	@CreatedDate datetime,
	@DeviceTypeId int output
)

as 
begin

	begin transaction;
	begin try
		insert into dbo.DeviceTypemaster
		(
			DeviceTypeName,
			CreatedDate
		)
		values
		(
			@DeviceTypeName,
			@CreatedDate
		)
		set @DeviceTypeId = SCOPE_IDENTITY();
		commit transaction;
	end try

	begin catch
		rollback transaction;
		set @DeviceTypeId = -1;
		throw;
	end catch
end;
GO

/****** Object:  StoredProcedure [dbo].[uspGetAllDeviceType]    Script Date: 21-01-2025 23:05:05 ******/
CREATE procedure [dbo].[uspGetAllDeviceType]
as
begin


SELECT [DeviceTypeId]
      ,[DeviceTypeName]
      ,[CreatedDate]
  FROM [dbo].[DeviceTypeMaster]

end;
GO


/****** Object:  StoredProcedure [dbo].[uspUpdateDeviceType]    Script Date: 21-01-2025 23:05:37 ******/
create procedure [dbo].[uspUpdateDeviceType]
(
	@DeviceTypeId int,
	@DeviceTypeName varchar(255),
	@Status int output
)
as
begin

	begin transaction;
	begin try
		update dbo.DeviceTypeMaster
		set DeviceTypeName = @DeviceTypeName
		where DeviceTypeId = @DeviceTypeId;
		set @Status = 1;
		commit transaction;
	end try
	begin catch
		rollback transaction;
		set @Status = -1;
		throw;
	end catch
end;
GO


/****** Object:  StoredProcedure [dbo].[uspCreateDevice]    Script Date: 21-01-2025 23:06:15 ******/
create procedure [dbo].[uspCreateDevice]
(
	@AgentId int,
	@DeviceName varchar(255),
	@DeviceDescription varchar(max),
	@DeviceTypeId int,
	@IsExternalDevice bit,
	@IsActive bit,
	@CreatedDate datetime,
	@DeviceId int output
)
as
begin
	begin transaction;
	begin try
		insert into dbo.DeviceMaster
		(
			AgentId,
			DeviceName,
			DeviceDescription,
			DeviceTypeId,
			IsExternalDevice,
			IsActive,
			CreatedDate
		)
		values
		(
			@AgentId,
			@DeviceName,
			@DeviceDescription,
			@DeviceTypeId,
			@IsExternalDevice,
			@IsActive,
			@CreatedDate
		)
		set @DeviceId = SCOPE_IDENTITY();
		commit transaction;
	end try
	begin catch
		rollback transaction;
		set @DeviceId = -1;
		throw;
	end catch
end;
GO



/****** Object:  StoredProcedure [dbo].[uspGetDeviceByAgentId]    Script Date: 21-01-2025 23:06:45 ******/
create procedure [dbo].[uspGetDeviceByAgentId]
(
	@AgentId int
)
as
begin

	SELECT [DeviceId]
      ,[AgentId]
      ,[DeviceName]
      ,[DeviceDescription]
      ,[DeviceTypeId]
      ,[IsExternalDevice]
      ,[IsActive]
      ,[CreatedDate]
	FROM [dbo].[DeviceMaster] where AgentId = @AgentId;
	
end;
GO



/****** Object:  StoredProcedure [dbo].[uspGetDeviceByDeviceId]    Script Date: 21-01-2025 23:07:14 ******/
CREATE procedure [dbo].[uspGetDeviceByDeviceId]
(
	@DeviceId int
)
as
begin

	SELECT [DeviceId]
      ,[AgentId]
      ,[DeviceName]
      ,[DeviceDescription]
      ,[DeviceTypeId]
      ,[IsExternalDevice]
      ,[IsActive]
      ,[CreatedDate]
	FROM [dbo].[DeviceMaster] where DeviceId = @DeviceId;
	
end;
GO



USE [AquariumAutomationApp]
GO

/****** Object:  StoredProcedure [dbo].[uspUpdateDevice]    Script Date: 21-01-2025 23:07:38 ******/
CREATE procedure 
[dbo].[uspUpdateDevice]
(
	@DeviceId int,
	@AgentId int,
	@DeviceName varchar(255),
	@DeviceDescription varchar(max),
	@DeviceTypeId int,
	@IsExternalDevice bit,
	@IsActive bit,
	@CreatedDate datetime,
	@Status int output
)
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY
		UPDATE dbo.DeviceMaster
		SET 
			AgentId = @AgentId,
			DeviceName = @DeviceName,
			DeviceDescription = @DeviceDescription,
			DeviceTypeId = @DeviceTypeId,
			IsExternalDevice = @IsExternalDevice,
			IsActive = @IsActive,
			CreatedDate = @CreatedDate
		WHERE DeviceId = @DeviceId;

		SET @Status = 1;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @Status = -1;
		THROW;
	END CATCH
END;
GO


/****** Object:  StoredProcedure [dbo].[uspCreateJob]    Script Date: 21-01-2025 23:08:23 ******/
create procedure [dbo].[uspCreateJob]
(
	@JobName varchar(255),
	@JobDescription varchar(max),
	@DeviceId int,
	@JobType varchar(255),
	@Period int,
	@IsActive bit,
	@CreatedDate datetime,
	@JobId int output
)
as
begin
	begin transaction;
	begin try
		insert into dbo.JobMaster
		(
			JobName,
			JobDescription,
			DeviceId,
			JobType,
			Period,
			IsActive,
			CreatedDate
		)
		values
		(
			@JobName,
			@JobDescription,
			@DeviceId,
			@JobType,
			@Period,
			@IsActive,
			@CreatedDate
		)
		set @JobId = SCOPE_IDENTITY();
		commit transaction;
	end try
	begin catch
		rollback transaction;
		set @JobId = -1;
		throw;
	end catch
end;
GO



USE [AquariumAutomationApp]
GO

/****** Object:  StoredProcedure [dbo].[uspGetJobByDeviceId]    Script Date: 21-01-2025 23:08:58 ******/
create procedure [dbo].[uspGetJobByDeviceId]
(
	@DeviceId int
)
as
begin

SELECT [JobId]
      ,[JobName]
      ,[JobDescription]
      ,[DeviceId]
      ,[JobType]
      ,[Period]
      ,[IsActive]
      ,[CreatedDate]
  FROM [dbo].[JobMaster] where DeviceId = @DeviceId;
end;
GO



/****** Object:  StoredProcedure [dbo].[uspGetJobByJobId]    Script Date: 21-01-2025 23:09:33 ******/
CREATE procedure [dbo].[uspGetJobByJobId]
(
	@JobId int
)
as
begin


SELECT [JobId]
      ,[JobName]
      ,[JobDescription]
      ,[DeviceId]
      ,[JobType]
      ,[Period]
      ,[IsActive]
      ,[CreatedDate]
  FROM [dbo].[JobMaster] where JobId = @JobId;
end;
GO



/****** Object:  StoredProcedure [dbo].[uspUpdateJob]    Script Date: 21-01-2025 23:10:09 ******/
create procedure [dbo].[uspUpdateJob]
(
	@JobId int,
	@JobName varchar(255),
	@JobDescription varchar(max),
	@DeviceId int,
	@JobType varchar(255),
	@Period int,
	@IsActive bit,
	@CreatedDate datetime,
	@Status int output
)
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY
		UPDATE dbo.JobMaster
		SET 
			JobName = @JobName,
			JobDescription = @JobDescription,
			DeviceId = @DeviceId,
			JobType = @JobType,
			Period = @Period,
			IsActive = @IsActive,
			CreatedDate = @CreatedDate
		WHERE JobId = @JobId;

		SET @Status = 1;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @Status = -1;
		THROW;
	END CATCH
END;
GO




/****** Object:  StoredProcedure [dbo].[uspCreateJobStatus]    Script Date: 21-01-2025 23:10:46 ******/
create procedure [dbo].[uspCreateJobStatus]
(
	@JobStatus varchar(255),
	@CreatedDate datetime,
	@JobStatusId int output
)
as
begin
	begin transaction;
	begin try
		insert into dbo.JobStatusMaster
		(
			JobStatus,
			CreatedDate
		)
		values
		(
			@JobStatus,
			@CreatedDate
		)
		set @JobStatusId = SCOPE_IDENTITY();
		commit transaction;
	end try
	begin catch
		rollback transaction;
		set @JobStatusId = -1;
		throw;
	end catch
end;
GO



/****** Object:  StoredProcedure [dbo].[uspGetAllJobStatus]    Script Date: 21-01-2025 23:11:13 ******/
CREATE procedure [dbo].[uspGetAllJobStatus]
AS
BEGIN

SELECT [JobStatusId]
      ,[JobStatus]
      ,[CreatedDate]
  FROM [dbo].[JobStatusMaster]

END;
GO



/****** Object:  StoredProcedure [dbo].[uspUpdateJobStatus]    Script Date: 21-01-2025 23:11:52 ******/
create procedure [dbo].[uspUpdateJobStatus]
(
    @JobStatusId int,
    @JobStatus varchar(255),
    @CreatedDate datetime,
	@Status int output
)
as
begin
    begin transaction;
    begin try
        update dbo.JobStatusMaster
        set
            JobStatus = @JobStatus,
            CreatedDate = @CreatedDate
        where
            JobStatusId = @JobStatusId;
		set @Status = 1;
        commit transaction;
    end try
    begin catch
        rollback transaction;
		set @Status = -1;
        throw;
    end catch
end;
GO




/****** Object:  StoredProcedure [dbo].[uspCreateJobTransaction]    Script Date: 21-01-2025 23:13:22 ******/
create procedure [dbo].[uspCreateJobTransaction]
(
	@JobId int,
	@UserId int,
	@StatusId int,
	@IsActive bit,
	@CreatedDate datetime,
	@CompletedDate datetime,
	@JobTransactionId int output
)
as
begin
	begin transaction;
	begin try
		insert into dbo.JobTransaction
		(
			JobId,
			UserId,
			StatusId,
			IsActive,
			CreatedDate,
			CompletedDate
		)
		values
		(
			@JobId,
			@UserId,
			@StatusId,
			@IsActive,
			@CreatedDate,
			@CompletedDate
		)
		set @JobTransactionId = SCOPE_IDENTITY();
		commit transaction;
	end try
	begin catch
		rollback transaction;
		set @JobTransactionId = -1;
		throw;
	end catch

end;
GO



USE [AquariumAutomationApp]
GO

/****** Object:  StoredProcedure [dbo].[uspGetJobTransactionByJobTransactionId]    Script Date: 21-01-2025 23:13:48 ******/
--  to get all job transaction by JobTransactionId
CREATE procedure 
[dbo].[uspGetJobTransactionByJobTransactionId]
(
	@JobTransactionId int
)
AS
BEGIN

SELECT [JobTransactionId]
      ,[JobId]
      ,[UserId]
      ,[StatusId]
      ,[IsActive]
      ,[CreatedDate]
      ,[CompletedDate]
  FROM [dbo].[JobTransaction] WHERE JobTransactionId = @JobTransactionId;
END;
GO




/****** Object:  StoredProcedure [dbo].[uspGetJobTransactionByJobId]    Script Date: 21-01-2025 23:14:41 ******/
-- to get all job transaction by JobId
create PROCEDURE [dbo].[uspGetJobTransactionByJobId]
(
	@JobId int
)
AS
BEGIN


SELECT [JobTransactionId]
      ,[JobId]
      ,[UserId]
      ,[StatusId]
      ,[IsActive]
      ,[CreatedDate]
      ,[CompletedDate]
  FROM [dbo].[JobTransaction]	WHERE JobId = @JobId;
END;
GO




/****** Object:  StoredProcedure [dbo].[uspGetJobTransactionByUserId]    Script Date: 21-01-2025 23:15:20 ******/
-- to get all job transaction by JobId
create PROCEDURE [dbo].[uspGetJobTransactionByUserId]
(
	@UserId int
)
AS
BEGIN


SELECT [JobTransactionId]
      ,[JobId]
      ,[UserId]
      ,[StatusId]
      ,[IsActive]
      ,[CreatedDate]
      ,[CompletedDate]
  FROM [dbo].[JobTransaction]	WHERE UserId = @UserId;
END;
GO


/****** Object:  StoredProcedure [dbo].[uspUpdateJobTransaction]    Script Date: 22-01-2025 00:51:13 ******/

CREATE PROCEDURE [dbo].[uspUpdateJobTransaction]
(
	@JobTransactionId int,
	@JobId int,
	@UserId int,
	@StatusId int,
	@IsActive bit,
	@CreatedDate datetime,
	@CompletedDate datetime,
	@Status int output
)
AS
BEGIN
	BEGIN TRANSACTION;
	BEGIN TRY
		UPDATE dbo.JobTransaction
		SET 
			JobId = @JobId,
			UserId = @UserId,
			StatusId = @StatusId,
			IsActive = @IsActive,
			CreatedDate = @CreatedDate,
			CompletedDate = @CompletedDate
		WHERE JobTransactionId = @JobTransactionId;

		SET @Status = 1;
		COMMIT TRANSACTION;
	END TRY
	BEGIN CATCH
		ROLLBACK TRANSACTION;
		SET @Status = -1;
		THROW;
	END CATCH
END;
GO




/****** Object:  StoredProcedure [dbo].[uspCreateTemperatureHistory]    Script Date: 21-01-2025 23:16:33 ******/
-- to create row in Temperature History
create procedure [dbo].[uspCreateTemperatureHistory]
(
    @JobTransactionId int,
    @AquariumId int,
    @TemperatureValue decimal(8,2),
    @CreatedDate datetime,
    @TemperatureHistoryTransactionId int output
)
as
begin
    begin transaction;
    begin try
        insert into dbo.TemperatureHistory
        (
            JobTransactionId,
            AquariumId,
            TemperatureValue,
            CreatedDate
        )
        values
        (
            @JobTransactionId,
            @AquariumId,
            @TemperatureValue,
            @CreatedDate
        )
        set @TemperatureHistoryTransactionId = SCOPE_IDENTITY();
        commit transaction;
    end try
    begin catch
        rollback transaction;
        set @TemperatureHistoryTransactionId = -1;
        throw;
    end catch
end;

GO




/****** Object:  StoredProcedure [dbo].[uspGetTemperatureHistoryByAquariumId]    Script Date: 21-01-2025 23:17:51 ******/
--  to get all temperature history by AquariumId
Create procedure [dbo].[uspGetTemperatureHistoryByAquariumId]
(
    @AquariumId int
)
as
begin

SELECT [TemperatureHistoryTransactionId]
      ,[JobTransactionId]
      ,[AquariumId]
      ,[TemperatureValue]
      ,[CreatedDate]
  FROM [dbo].[TemperatureHistoryTransaction]    where AquariumId = @AquariumId;
end;
GO





/****** Object:  StoredProcedure [dbo].[uspGetTemperatureHistoryByJobTransactionId]    Script Date: 21-01-2025 23:18:09 ******/
--  to get all temperature history by AquariumId
Create procedure [dbo].[uspGetTemperatureHistoryByJobTransactionId]
(
    @JobTransactionId int
)
as
begin

SELECT [TemperatureHistoryTransactionId]
      ,[JobTransactionId]
      ,[AquariumId]
      ,[TemperatureValue]
      ,[CreatedDate]
  FROM [dbo].[TemperatureHistoryTransaction]    where JobTransactionId = @JobTransactionId;
end;
GO




/****** Object:  StoredProcedure [dbo].[uspUpdateTemperatureHistory]    Script Date: 22-01-2025 01:12:52 ******/
-- to update row in Temperature History
create procedure [dbo].[uspUpdateTemperatureHistory]
(
    @TemperatureHistoryTransactionId bigint,
    @JobTransactionId bigint,
    @AquariumId bigint,
    @TemperatureValue decimal(8,2),
    @CreatedDate datetime,
	@Status int output
)
as
begin
    begin transaction;
    begin try
        update dbo.TemperatureHistoryTransaction
        set
            JobTransactionId = @JobTransactionId,
            AquariumId = @AquariumId,
            TemperatureValue = @TemperatureValue,
            CreatedDate = @CreatedDate
        where
            TemperatureHistoryTransactionId = @TemperatureHistoryTransactionId;

		set @Status = 1;
        commit transaction;
    end try
    begin catch
        rollback transaction;
		set @Status = -1;
        throw;
    end catch
end;
GO

